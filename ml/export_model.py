"""Export the fitted sklearn model as ONNX and Dart-readable JSON."""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.neural_network import MLPClassifier


def model_to_json(
    model,
    *,
    feature_names: list[str],
    imputer_median: list[float],
    scaler_mean: list[float],
    scaler_scale: list[float],
) -> dict:
    classes = [str(item) for item in model.classes_]
    payload = {
        "type": type(model).__name__,
        "classes": classes,
        "feature_names": feature_names,
        "imputer_median": imputer_median,
        "scaler_mean": scaler_mean,
        "scaler_scale": scaler_scale,
    }
    if isinstance(model, LogisticRegression):
        payload["coef"] = np.asarray(model.coef_, dtype=float).tolist()
        payload["intercept"] = np.asarray(model.intercept_, dtype=float).tolist()
        payload["inference"] = "logistic"
    elif isinstance(model, MLPClassifier):
        payload["mlp_weights"] = [np.asarray(layer, dtype=float).tolist() for layer in model.coefs_]
        payload["mlp_biases"] = [np.asarray(layer, dtype=float).tolist() for layer in model.intercepts_]
        payload["mlp_activation"] = model.activation
        payload["inference"] = "mlp"
    else:
        raise TypeError(f"unsupported model {type(model)}")
    return payload


def write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def write_onnx(model, path: Path, n_features: int) -> bool:
    try:
        from skl2onnx import convert_sklearn
        from skl2onnx.common.data_types import FloatTensorType
    except ImportError:
        return False
    try:
        onx = convert_sklearn(
            model,
            initial_types=[("features", FloatTensorType([None, n_features]))],
            target_opset=12,
        )
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(onx.SerializeToString())
        return True
    except Exception:
        return False
