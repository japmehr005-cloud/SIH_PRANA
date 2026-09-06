"""Load Empatica E4 session CSVs. Protocol folder is context, not a medical label."""

from __future__ import annotations

from pathlib import Path

import numpy as np
import pandas as pd

from ml.paths import E4_RAW

CONSTRAINED = {
    ("STRESS", "S02"): "duplicated_signals",
    ("STRESS", "f07"): "ppg_temp_covered",
    ("STRESS", "f14_a"): "bluetooth_split",
    ("STRESS", "f14_b"): "bluetooth_split",
    ("AEROBIC", "S03"): "ended_early",
    ("AEROBIC", "S07"): "ended_early",
    ("AEROBIC", "S11_a"): "bluetooth_split",
    ("AEROBIC", "S11_b"): "bluetooth_split",
    ("AEROBIC", "S12"): "missing_protocol",
    ("ANAEROBIC", "S01"): "empty_ibi",
    ("ANAEROBIC", "S06"): "ended_early",
    ("ANAEROBIC", "S16_a"): "bluetooth_split",
    ("ANAEROBIC", "S16_b"): "bluetooth_split",
}


def _read_e4_scalar(path: Path) -> tuple[pd.Timestamp | None, float, np.ndarray]:
    if not path.exists():
        return None, np.nan, np.array([])
    raw = path.read_text(encoding="utf-8", errors="replace").splitlines()
    if len(raw) < 3:
        return None, np.nan, np.array([])
    start = pd.to_datetime(raw[0].strip(), utc=True, errors="coerce")
    rate = float(raw[1].split(",")[0])
    values = np.array([float(line.split(",")[0]) for line in raw[2:] if line.strip()], dtype=float)
    return start, rate, values


def _read_e4_acc(path: Path) -> tuple[pd.Timestamp | None, float, np.ndarray]:
    if not path.exists():
        return None, np.nan, np.zeros((0, 3))
    raw = path.read_text(encoding="utf-8", errors="replace").splitlines()
    if len(raw) < 3:
        return None, np.nan, np.zeros((0, 3))
    start = pd.to_datetime(raw[0].split(",")[0].strip(), utc=True, errors="coerce")
    rate = float(raw[1].split(",")[0])
    rows = []
    for line in raw[2:]:
        parts = [part.strip() for part in line.split(",") if part.strip()]
        if len(parts) >= 3:
            rows.append([float(parts[0]), float(parts[1]), float(parts[2])])
    return start, rate, np.array(rows, dtype=float)


def _to_1hz(values: np.ndarray, rate: float, seconds: int) -> np.ndarray:
    if values.size == 0 or not np.isfinite(rate) or rate <= 0:
        return np.full(seconds, np.nan)
    grouped = []
    step = max(int(round(rate)), 1)
    for second in range(seconds):
        chunk = values[second * step : (second + 1) * step]
        grouped.append(np.nanmean(chunk) if len(chunk) else np.nan)
    return np.array(grouped, dtype=float)


def session_dirs() -> list[tuple[str, Path]]:
    root = E4_RAW / "Wearable_Dataset"
    found = []
    for protocol in ("STRESS", "AEROBIC", "ANAEROBIC"):
        folder = root / protocol
        if not folder.exists():
            continue
        for session in sorted(path for path in folder.iterdir() if path.is_dir()):
            found.append((protocol, session))
    return found


def load_session(protocol: str, session_dir: Path) -> pd.DataFrame:
    session_id = session_dir.name
    flag = CONSTRAINED.get((protocol, session_id))
    _temp_start, temp_rate, temp = _read_e4_scalar(session_dir / "TEMP.csv")
    _eda_start, eda_rate, eda = _read_e4_scalar(session_dir / "EDA.csv")
    _hr_start, hr_rate, hr = _read_e4_scalar(session_dir / "HR.csv")
    _acc_start, acc_rate, acc = _read_e4_acc(session_dir / "ACC.csv")

    seconds = 0
    if hr_rate and hr.size:
        seconds = max(seconds, int(hr.size / max(hr_rate, 1)))
    if temp_rate and temp.size:
        seconds = max(seconds, int(temp.size / max(temp_rate, 1)))
    if seconds <= 0:
        return pd.DataFrame()

    accel_mag = np.array([])
    if acc.size:
        accel_mag = np.sqrt((acc**2).sum(axis=1))

    hr_1 = _to_1hz(hr, hr_rate, seconds)
    temp_1 = _to_1hz(temp, temp_rate, seconds)
    eda_1 = _to_1hz(eda, eda_rate, seconds)
    acc_1 = _to_1hz(accel_mag, acc_rate, seconds)

    if flag == "ppg_temp_covered":
        hr_1 = np.full(seconds, np.nan)
        temp_1 = np.full(seconds, np.nan)

    rows = []
    for second in range(seconds):
        rows.append(
            {
                "subject": session_id.split("_")[0],
                "session_id": session_id,
                "t_sec": second,
                "hr": _finite_or_nan(hr_1[second] if second < len(hr_1) else np.nan),
                "spo2": np.nan,
                "temp": _finite_or_nan(temp_1[second] if second < len(temp_1) else np.nan),
                "eda": _finite_or_nan(eda_1[second] if second < len(eda_1) else np.nan),
                "accel_mag": _finite_or_nan(acc_1[second] if second < len(acc_1) else np.nan),
                "protocol_context": protocol,
                "constraint_flag": flag or "",
                "dataset": "wearable_e4",
                "source_id": f"dataset:e4:{protocol}:{session_id}",
            }
        )
    return pd.DataFrame(rows)


def load_all_sessions(*, include_constrained: bool = False) -> pd.DataFrame:
    frames = []
    for protocol, session_dir in session_dirs():
        flag = CONSTRAINED.get((protocol, session_dir.name))
        if flag and not include_constrained:
            continue
        frame = load_session(protocol, session_dir)
        if not frame.empty:
            frames.append(frame)
    if not frames:
        return pd.DataFrame()
    return pd.concat(frames, ignore_index=True)


def _finite_or_nan(value: float) -> float:
    number = float(value)
    if not np.isfinite(number):
        return np.nan
    return number
