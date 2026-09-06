"""Window features. Missing sensors stay NaN and are imputed only at train time."""

from __future__ import annotations

import numpy as np
import pandas as pd

from ml.paths import FEATURE_VERSION

FEATURE_NAMES = [
    "hr_mean",
    "hr_std",
    "hr_delta_prev",
    "hr_delta_baseline",
    "spo2_mean",
    "spo2_min",
    "spo2_delta_baseline",
    "temp_mean",
    "temp_slope",
    "temp_delta_baseline",
    "eda_mean",
    "eda_delta_baseline",
    "accel_mag_mean",
    "accel_mag_std",
    "accel_mag_delta_prev",
]


def _stat_mean(values: np.ndarray) -> float:
    finite = values[np.isfinite(values)]
    if finite.size == 0:
        return np.nan
    return float(np.mean(finite))


def _stat_std(values: np.ndarray) -> float:
    finite = values[np.isfinite(values)]
    if finite.size < 2:
        return np.nan
    return float(np.std(finite, ddof=1))


def _stat_min(values: np.ndarray) -> float:
    finite = values[np.isfinite(values)]
    if finite.size == 0:
        return np.nan
    return float(np.min(finite))


def _slope(values: np.ndarray) -> float:
    finite = values[np.isfinite(values)]
    if finite.size < 2:
        return np.nan
    x = np.arange(finite.size, dtype=float)
    return float(np.polyfit(x, finite, 1)[0])


def subject_relax_baseline(windows: list[dict]) -> dict[str, float]:
    relax = [window for window in windows if window.get("label") == "Relax"]
    if not relax:
        return {}
    return {
        "hr": float(np.nanmedian([_stat_mean(window["hr"]) for window in relax])),
        "spo2": float(np.nanmedian([_stat_mean(window["spo2"]) for window in relax])),
        "temp": float(np.nanmedian([_stat_mean(window["temp"]) for window in relax])),
        "eda": float(np.nanmedian([_stat_mean(window["eda"]) for window in relax])),
    }


def extract_window_features(
    window: dict,
    *,
    previous: dict | None,
    baseline: dict[str, float],
) -> dict[str, float]:
    hr_mean = _stat_mean(window["hr"])
    spo2_mean = _stat_mean(window["spo2"])
    temp_mean = _stat_mean(window["temp"])
    eda_mean = _stat_mean(window["eda"])
    accel_mean = _stat_mean(window["accel_mag"])
    prev_hr = _stat_mean(previous["hr"]) if previous is not None else np.nan
    prev_accel = _stat_mean(previous["accel_mag"]) if previous is not None else np.nan
    return {
        "hr_mean": hr_mean,
        "hr_std": _stat_std(window["hr"]),
        "hr_delta_prev": hr_mean - prev_hr if np.isfinite(hr_mean) and np.isfinite(prev_hr) else np.nan,
        "hr_delta_baseline": hr_mean - baseline["hr"]
        if np.isfinite(hr_mean) and "hr" in baseline and np.isfinite(baseline["hr"])
        else np.nan,
        "spo2_mean": spo2_mean,
        "spo2_min": _stat_min(window["spo2"]),
        "spo2_delta_baseline": spo2_mean - baseline["spo2"]
        if np.isfinite(spo2_mean) and "spo2" in baseline and np.isfinite(baseline["spo2"])
        else np.nan,
        "temp_mean": temp_mean,
        "temp_slope": _slope(window["temp"]),
        "temp_delta_baseline": temp_mean - baseline["temp"]
        if np.isfinite(temp_mean) and "temp" in baseline and np.isfinite(baseline["temp"])
        else np.nan,
        "eda_mean": eda_mean,
        "eda_delta_baseline": eda_mean - baseline["eda"]
        if np.isfinite(eda_mean) and "eda" in baseline and np.isfinite(baseline["eda"])
        else np.nan,
        "accel_mag_mean": accel_mean,
        "accel_mag_std": _stat_std(window["accel_mag"]),
        "accel_mag_delta_prev": accel_mean - prev_accel
        if np.isfinite(accel_mean) and np.isfinite(prev_accel)
        else np.nan,
        "feature_version": FEATURE_VERSION,
    }


def features_frame(windows: list[dict], baseline: dict[str, float]) -> pd.DataFrame:
    rows = []
    previous = None
    for window in windows:
        feats = extract_window_features(window, previous=previous, baseline=baseline)
        rows.append(
            {
                "subject": window["subject"],
                "source_id": window["source_id"],
                "dataset": window["dataset"],
                "t_start": window["t_start"],
                "label": window.get("label", ""),
                **feats,
            }
        )
        previous = window
    return pd.DataFrame(rows)
