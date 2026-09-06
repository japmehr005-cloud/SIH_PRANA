"""Window aligned 1 Hz streams. Do not invent missing values."""

from __future__ import annotations

import numpy as np
import pandas as pd

from ml.paths import PREPROCESS_VERSION, WINDOW_SECONDS


def sanitize_noneeg(frame: pd.DataFrame) -> pd.DataFrame:
    out = frame.copy()
    out.loc[(out["hr"] <= 0) | (out["hr"] > 220), "hr"] = np.nan
    out.loc[(out["spo2"] <= 0) | (out["spo2"] > 100), "spo2"] = np.nan
    out.loc[(out["temp"] < 20) | (out["temp"] > 45), "temp"] = np.nan
    out.loc[out["eda"] < 0, "eda"] = np.nan
    out.loc[out["accel_mag"] < 0, "accel_mag"] = np.nan
    out["preprocess_version"] = PREPROCESS_VERSION
    return out


def window_subject(frame: pd.DataFrame, *, label_column: str | None) -> list[dict]:
    frame = frame.sort_values("t_sec").reset_index(drop=True)
    windows = []
    for start in range(0, len(frame) - WINDOW_SECONDS + 1, WINDOW_SECONDS):
        chunk = frame.iloc[start : start + WINDOW_SECONDS]
        if len(chunk) < WINDOW_SECONDS:
            continue
        label = ""
        if label_column and label_column in chunk:
            present = chunk[label_column].astype(str)
            present = present[present.isin(["Relax", "PhysicalStress", "EmotionalStress", "CognitiveStress"])]
            if len(present):
                values, counts = np.unique(present, return_counts=True)
                if counts.max() / len(chunk) >= 0.5:
                    label = str(values[int(np.argmax(counts))])
        windows.append(
            {
                "subject": chunk["subject"].iloc[0],
                "source_id": chunk["source_id"].iloc[0],
                "dataset": chunk["dataset"].iloc[0],
                "t_start": int(chunk["t_sec"].iloc[0]),
                "hr": chunk["hr"].to_numpy(dtype=float),
                "spo2": chunk["spo2"].to_numpy(dtype=float),
                "temp": chunk["temp"].to_numpy(dtype=float),
                "eda": chunk["eda"].to_numpy(dtype=float),
                "accel_mag": chunk["accel_mag"].to_numpy(dtype=float),
                "label": label,
            }
        )
    return windows
