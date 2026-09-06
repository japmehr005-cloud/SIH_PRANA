"""Load PhysioNet Non-EEG WFDB records without modifying raw files."""

from __future__ import annotations

import numpy as np
import pandas as pd
import wfdb

from ml.paths import ALLOWED_NONEEG_LABELS, NONEEG_RAW


def list_subjects() -> list[int]:
    info = pd.read_csv(NONEEG_RAW / "subjectinfo.csv")
    return [int(value) for value in info["subject"].tolist()]


def _label_series(record_name: str, n_samples: int, fs: float) -> np.ndarray:
    annotation = wfdb.rdann(str(NONEEG_RAW / record_name), "atr")
    labels = np.full(n_samples, "", dtype=object)
    current = ""
    events = sorted(zip(annotation.sample.tolist(), annotation.aux_note))
    event_index = 0
    for sample_i in range(n_samples):
        while event_index < len(events) and events[event_index][0] <= sample_i:
            raw = str(events[event_index][1] or "").strip().strip("\x00")
            if raw in ALLOWED_NONEEG_LABELS:
                current = raw
            event_index += 1
        labels[sample_i] = current
    return labels


def load_subject(subject: int) -> pd.DataFrame:
    acc_name = f"Subject{subject}_AccTempEDA"
    hr_name = f"Subject{subject}_SpO2HR"
    acc = wfdb.rdrecord(str(NONEEG_RAW / acc_name))
    hr = wfdb.rdrecord(str(NONEEG_RAW / hr_name))

    acc_names = list(acc.sig_name)
    ax = acc.p_signal[:, acc_names.index("ax")].astype(float)
    ay = acc.p_signal[:, acc_names.index("ay")].astype(float)
    az = acc.p_signal[:, acc_names.index("az")].astype(float)
    temp = acc.p_signal[:, acc_names.index("temp")].astype(float)
    eda = acc.p_signal[:, acc_names.index("EDA")].astype(float)
    accel_mag = np.sqrt(ax**2 + ay**2 + az**2)
    labels_8hz = _label_series(acc_name, acc.sig_len, float(acc.fs))

    hr_names = list(hr.sig_name)
    spo2 = hr.p_signal[:, hr_names.index("SpO2")].astype(float)
    heart = hr.p_signal[:, hr_names.index("hr")].astype(float)

    seconds = min(int(acc.sig_len // acc.fs), int(hr.sig_len // hr.fs), hr.sig_len)
    rows = []
    for second in range(seconds):
        start = int(second * acc.fs)
        end = int((second + 1) * acc.fs)
        window_labels = labels_8hz[start:end]
        label = ""
        if len(window_labels):
            values, counts = np.unique(window_labels[window_labels != ""], return_counts=True)
            if len(values):
                label = str(values[int(np.argmax(counts))])
        rows.append(
            {
                "subject": subject,
                "t_sec": second,
                "hr": _finite_or_nan(heart[second] if second < len(heart) else np.nan),
                "spo2": _finite_or_nan(spo2[second] if second < len(spo2) else np.nan),
                "temp": _finite_or_nan(np.nanmean(temp[start:end])),
                "eda": _finite_or_nan(np.nanmean(eda[start:end])),
                "accel_mag": _finite_or_nan(np.nanmean(accel_mag[start:end])),
                "label": label,
                "dataset": "noneeg",
                "source_id": f"dataset:noneeg:Subject{subject}",
            }
        )
    return pd.DataFrame(rows)


def load_all_subjects() -> pd.DataFrame:
    frames = [load_subject(subject) for subject in list_subjects()]
    return pd.concat(frames, ignore_index=True)


def _finite_or_nan(value: float) -> float:
    number = float(value)
    if not np.isfinite(number):
        return np.nan
    return number
