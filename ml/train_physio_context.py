"""Train a physiological-context model on Non-EEG ATR labels only."""

from __future__ import annotations

import json
from collections import Counter

import numpy as np
import pandas as pd
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report, f1_score
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from ml.datasets.e4_loader import load_all_sessions
from ml.datasets.noneeg_loader import load_all_subjects
from ml.export_model import model_to_json, write_json, write_onnx
from ml.features import FEATURE_NAMES, features_frame, subject_relax_baseline
from ml.paths import (
    ARTIFACTS,
    ASSET_MODELS,
    DATASET_ID,
    FEATURES,
    MODEL_NAME,
    MODEL_VERSION,
    PREPROCESS_VERSION,
    PROCESSED,
    FEATURE_VERSION,
    WINDOW_SECONDS,
)
from ml.preprocess import sanitize_noneeg, window_subject
from ml.splits import write_noneeg_split


CONTEXT_MAP = {
    "Relax": "rest",
    "PhysicalStress": "exertion",
    "EmotionalStress": "elevated_load",
    "CognitiveStress": "elevated_load",
}


def _matrix(frame: pd.DataFrame) -> np.ndarray:
    return frame[FEATURE_NAMES].to_numpy(dtype=float)


def _fit_candidates(x_train, y_train, x_val, y_val):
    candidates = {
        "logistic": LogisticRegression(
            max_iter=400,
            class_weight="balanced",
        ),
        "mlp": MLPClassifier(
            hidden_layer_sizes=(16,),
            activation="relu",
            max_iter=800,
            random_state=7,
        ),
    }
    ranked = []
    for name, model in candidates.items():
        pipe = Pipeline(
            [
                ("imputer", SimpleImputer(strategy="median")),
                ("scaler", StandardScaler()),
                ("model", model),
            ]
        )
        try:
            pipe.fit(x_train, y_train)
            pred = pipe.predict(x_val)
            score = float(f1_score(y_val, pred, average="macro", zero_division=0))
            ranked.append((score, name, pipe))
        except Exception as error:
            print(f"Skipping {name}: {error}")
    if not ranked:
        raise RuntimeError("no estimator could be fitted")
    ranked.sort(reverse=True, key=lambda item: item[0])
    return ranked


def _metrics(y_true, y_pred, labels) -> dict:
    report = classification_report(
        y_true,
        y_pred,
        labels=labels,
        output_dict=True,
        zero_division=0,
    )
    return {
        "accuracy": float(accuracy_score(y_true, y_pred)),
        "macro_f1": float(f1_score(y_true, y_pred, average="macro", zero_division=0)),
        "support": {str(label): int((np.array(y_true) == label).sum()) for label in labels},
        "classification_report": report,
    }


def _build_noneeg_features(aligned: pd.DataFrame) -> pd.DataFrame:
    frames = []
    replay_rows = []
    for subject, group in aligned.groupby("subject"):
        windows = window_subject(group, label_column="label")
        baseline = subject_relax_baseline(windows)
        feats = features_frame(windows, baseline)
        frames.append(feats)
        for window in windows:
            hr = window["hr"]
            spo2 = window["spo2"]
            temp = window["temp"]
            accel = window["accel_mag"]
            eda = window["eda"]
            mid = len(hr) // 2
            replay_rows.append(
                {
                    "timestamp_ms": int(window["t_start"] * 1000),
                    "hr_bpm": _or_blank(hr[mid]),
                    "spo2": _or_blank(spo2[mid]),
                    "temp_c": _or_blank(temp[mid]),
                    "accel_mag": _or_blank(accel[mid]),
                    "eda": _or_blank(eda[mid]),
                    "source_id": window["source_id"],
                    "label": window["label"],
                    "subject": subject,
                }
            )
    PROCESSED.joinpath("noneeg").mkdir(parents=True, exist_ok=True)
    pd.DataFrame(replay_rows).to_csv(
        PROCESSED / "noneeg" / "replay_windows.csv",
        index=False,
    )
    return pd.concat(frames, ignore_index=True)


def _or_blank(value: float) -> str:
    if value is None or not np.isfinite(value):
        return ""
    return f"{float(value):.4f}"


def main() -> None:
    split = write_noneeg_split()
    print("Loading Non-EEG subjects from WFDB...")
    aligned = sanitize_noneeg(load_all_subjects())
    PROCESSED.joinpath("noneeg").mkdir(parents=True, exist_ok=True)
    aligned.to_csv(PROCESSED / "noneeg" / "aligned_1hz.csv", index=False)

    features = _build_noneeg_features(aligned)
    features = features[features["label"].isin(CONTEXT_MAP)]
    FEATURES.mkdir(parents=True, exist_ok=True)
    features.to_csv(FEATURES / "noneeg_windows.csv", index=False)

    print("Loading E4 sessions for processed windows only (not used as train labels)...")
    e4 = load_all_sessions(include_constrained=False)
    if not e4.empty:
        PROCESSED.joinpath("wearable_e4").mkdir(parents=True, exist_ok=True)
        e4.to_csv(PROCESSED / "wearable_e4" / "aligned_1hz.csv", index=False)

    train = features[features["subject"].isin(split["train"])]
    val = features[features["subject"].isin(split["val"])]
    test = features[features["subject"].isin(split["test"])]
    labels = sorted(features["label"].unique().tolist())

    x_train, y_train = _matrix(train), train["label"].to_numpy()
    x_val, y_val = _matrix(val), val["label"].to_numpy()
    x_test, y_test = _matrix(test), test["label"].to_numpy()

    ranked = _fit_candidates(x_train, y_train, x_val, y_val)
    val_f1, chosen_name, pipe = ranked[0]
    print(f"Selected {chosen_name} by validation macro-F1={val_f1:.4f}")
    for score, name, _ in ranked:
        print(f"  val {name}: macro-F1={score:.4f}")

    y_val_pred = pipe.predict(x_val)
    y_test_pred = pipe.predict(x_test)
    val_metrics = _metrics(y_val, y_val_pred, labels)
    test_metrics = _metrics(y_test, y_test_pred, labels)
    print("Held-out test metrics:")
    print(json.dumps({k: test_metrics[k] for k in ("accuracy", "macro_f1", "support")}, indent=2))

    imputer: SimpleImputer = pipe.named_steps["imputer"]
    scaler: StandardScaler = pipe.named_steps["scaler"]
    model = pipe.named_steps["model"]
    model_json = model_to_json(
        model,
        feature_names=FEATURE_NAMES,
        imputer_median=[float(v) for v in imputer.statistics_],
        scaler_mean=[float(v) for v in scaler.mean_],
        scaler_scale=[float(v) for v in scaler.scale_],
    )
    write_json(ASSET_MODELS / "physio_context.json", model_json)
    onnx_ok = write_onnx(model, ARTIFACTS / "physio_context.onnx", len(FEATURE_NAMES))

    metadata = {
        "name": MODEL_NAME,
        "version": MODEL_VERSION,
        "dataset_id": DATASET_ID,
        "preprocess_version": PREPROCESS_VERSION,
        "feature_version": FEATURE_VERSION,
        "window_seconds": WINDOW_SECONDS,
        "feature_names": FEATURE_NAMES,
        "classes": model_json["classes"],
        "context_map": CONTEXT_MAP,
        "selected_estimator": chosen_name,
        "subject_split": split,
        "train_label_counts": dict(Counter(y_train)),
        "val_label_counts": dict(Counter(y_val)),
        "test_label_counts": dict(Counter(y_test)),
        "validation_metrics": val_metrics,
        "test_metrics": test_metrics,
        "onnx_exported": onnx_ok,
        "target_runtime": ["dart-json-web", "onnx-mobile-future"],
        "medical_scope": (
            "Healthy-participant experimental states only. "
            "Not a diagnostic or fall-detection model."
        ),
    }
    write_json(ASSET_MODELS / "physio_context.meta.json", metadata)
    write_json(ARTIFACTS / "physio_context.meta.json", metadata)
    print(f"Wrote {ASSET_MODELS / 'physio_context.json'}")
    print(f"ONNX exported: {onnx_ok}")


if __name__ == "__main__":
    main()
