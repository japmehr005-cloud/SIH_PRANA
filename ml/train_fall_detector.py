"""Train a SisFall window-feature fall detector with a subject-level split.

If the archive is missing and cannot be downloaded, exit without writing a
fake model. The Flutter app then keeps fall-seq-v1.
"""

from __future__ import annotations

import json
import math
import re
import sys
import zipfile
from pathlib import Path
from urllib.request import urlretrieve

import numpy as np
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import f1_score, recall_score, precision_score
from sklearn.model_selection import GroupKFold
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "sisfall"
ASSET_MODELS = ROOT / "assets" / "models"
FEATURE_NAMES = [
    "smv_max",
    "smv_mean",
    "smv_std",
    "smv_min",
    "post_peak_mean",
    "gyro_mean",
]
WINDOW_SAMPLES = 400  # 2 s at 200 Hz
STRIDE = 200
MIN_SAMPLES = 80
SUBJECT_RE = re.compile(r"_(S[AE]\d+)_", re.I)
FILE_RE = re.compile(r"^[DF]\d+", re.I)


def _find_txt_files(root: Path) -> list[Path]:
    return [path for path in root.rglob("*.txt") if FILE_RE.search(path.name)]


DOWNLOAD_CANDIDATES = [
    "https://huggingface.co/datasets/Algo-rythmic/Sisfall_Dataset/resolve/main/SisFall_dataset.zip",
    "http://sistemic.udea.edu.co/wp-content/uploads/2019/02/SisFall_dataset.zip",
]


def _try_huggingface(root: Path) -> bool:
    try:
        from huggingface_hub import snapshot_download
    except ImportError:
        return False
    try:
        snapshot_download(
            repo_id="Algo-rythmic/Sisfall_Dataset",
            repo_type="dataset",
            local_dir=str(root),
        )
        return bool(_find_txt_files(root))
    except Exception as error:  # noqa: BLE001
        print(f"Hugging Face snapshot failed: {error}")
        return False


def _ensure_raw() -> Path:
    existing = _find_txt_files(RAW)
    if existing:
        return RAW
    RAW.mkdir(parents=True, exist_ok=True)
    if _try_huggingface(RAW):
        return RAW
    zip_path = RAW / "SisFall_dataset.zip"
    last_error = None
    for url in DOWNLOAD_CANDIDATES:
        try:
            print(f"Downloading SisFall from {url}")
            urlretrieve(url, zip_path)
            with zipfile.ZipFile(zip_path) as archive:
                archive.extractall(RAW)
            if _find_txt_files(RAW):
                return RAW
        except Exception as error:  # noqa: BLE001
            last_error = error
            print(f"Download failed: {error}")
    print("SisFall was not available. Keeping fall-seq-v1.")
    if last_error:
        print(last_error)
    sys.exit(1)


def _load_signal(path: Path) -> np.ndarray:
    rows = []
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = line.strip().replace(";", ",")
        if not line:
            continue
        parts = [item for item in re.split(r"[, \t]+", line) if item]
        if len(parts) < 3:
            continue
        try:
            values = [float(item) for item in parts[:6]]
        except ValueError:
            continue
        rows.append(values)
    if len(rows) < MIN_SAMPLES:
        return np.empty((0, 6))
    return np.asarray(rows, dtype=float)


def _features(window: np.ndarray) -> list[float | None]:
    accel = window[:, :3]
    smv = np.sqrt(np.sum(np.square(accel), axis=1))
    if smv.size == 0:
        return [None] * len(FEATURE_NAMES)
    peak = int(np.argmax(smv))
    tail = smv[peak + 1 :]
    gyro = None
    if window.shape[1] >= 6:
        rotation = window[:, 3:6]
        gyro = float(np.mean(np.sqrt(np.sum(np.square(rotation), axis=1))))
    return [
        float(np.max(smv)),
        float(np.mean(smv)),
        float(np.std(smv)),
        float(np.min(smv)),
        float(np.mean(tail)) if tail.size else None,
        gyro,
    ]


def _windows(signal: np.ndarray) -> list[np.ndarray]:
    if signal.shape[0] < MIN_SAMPLES:
        return []
    if signal.shape[0] <= WINDOW_SAMPLES:
        return [signal]
    chunks = []
    for start in range(0, signal.shape[0] - WINDOW_SAMPLES + 1, STRIDE):
        chunks.append(signal[start : start + WINDOW_SAMPLES])
        if len(chunks) >= 8:
            break
    return chunks


def _matrix(rows: list[list[float | None]]) -> np.ndarray:
    data = np.array(
        [[math.nan if value is None else float(value) for value in row] for row in rows],
        dtype=float,
    )
    return data


def main() -> None:
    root = _ensure_raw()
    files = _find_txt_files(root)
    features: list[list[float | None]] = []
    labels: list[int] = []
    groups: list[str] = []
    for path in files:
        match = SUBJECT_RE.search(path.name)
        if match is None:
            continue
        subject = match.group(1).upper()
        is_fall = path.name.upper().startswith("F")
        signal = _load_signal(path)
        for window in _windows(signal):
            features.append(_features(window))
            labels.append(1 if is_fall else 0)
            groups.append(subject)
    if len(set(groups)) < 4 or not features:
        print("Not enough SisFall subjects. Keeping fall-seq-v1.")
        sys.exit(1)

    x = _matrix(features)
    y = np.asarray(labels, dtype=int)
    groups_array = np.asarray(groups)
    splitter = GroupKFold(n_splits=min(5, len(set(groups))))
    scores = []
    trained = None
    for train_idx, test_idx in splitter.split(x, y, groups_array):
        pipe = Pipeline(
            [
                ("imputer", SimpleImputer(strategy="median")),
                ("scaler", StandardScaler()),
                (
                    "model",
                    LogisticRegression(max_iter=400, class_weight="balanced"),
                ),
            ]
        )
        pipe.fit(x[train_idx], y[train_idx])
        pred = pipe.predict(x[test_idx])
        scores.append(
            {
                "sensitivity": float(recall_score(y[test_idx], pred, zero_division=0)),
                "precision": float(precision_score(y[test_idx], pred, zero_division=0)),
                "specificity": float(
                    recall_score(y[test_idx], pred, pos_label=0, zero_division=0)
                ),
                "f1": float(f1_score(y[test_idx], pred, zero_division=0)),
            }
        )
        trained = pipe

    if trained is None:
        print("Training failed. Keeping fall-seq-v1.")
        sys.exit(1)

    imputer: SimpleImputer = trained.named_steps["imputer"]
    scaler: StandardScaler = trained.named_steps["scaler"]
    model: LogisticRegression = trained.named_steps["model"]
    payload = {
        "type": "LogisticRegression",
        "classes": ["adl", "fall"],
        "feature_names": FEATURE_NAMES,
        "imputer_median": imputer.statistics_.astype(float).tolist(),
        "scaler_mean": scaler.mean_.astype(float).tolist(),
        "scaler_scale": scaler.scale_.astype(float).tolist(),
        "coef": model.coef_.astype(float).tolist(),
        "intercept": model.intercept_.astype(float).tolist(),
        "inference": "logistic",
    }
    mean = {key: float(np.mean([row[key] for row in scores])) for key in scores[0]}
    metadata = {
        "version": "fall-window-v1",
        "dataset": "sisfall",
        "split": "GroupKFold-subject",
        "threshold": 0.5,
        "n_windows": int(len(y)),
        "n_subjects": int(len(set(groups))),
        "sensitivity": mean["sensitivity"],
        "specificity": mean["specificity"],
        "precision": mean["precision"],
        "f1": mean["f1"],
        "folds": scores,
        "notes": "IMU fall versus ADL window features. Not clinical validation.",
    }
    ASSET_MODELS.mkdir(parents=True, exist_ok=True)
    (ASSET_MODELS / "fall_window.json").write_text(
        json.dumps(payload, indent=2),
        encoding="utf-8",
    )
    (ASSET_MODELS / "fall_window.meta.json").write_text(
        json.dumps(metadata, indent=2),
        encoding="utf-8",
    )
    print(json.dumps(metadata, indent=2))


if __name__ == "__main__":
    main()
