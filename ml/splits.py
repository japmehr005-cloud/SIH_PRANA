"""Subject-level splits. Windows from one person never cross train/val/test."""

from __future__ import annotations

import json

from ml.paths import SPLITS

# Fixed Non-EEG subject IDs. 20 subjects, held-out users only.
NONEEG_SPLIT = {
    "train": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    "val": [13, 14, 15, 16],
    "test": [17, 18, 19, 20],
}


def assert_disjoint(split: dict[str, list[int]]) -> None:
    train = set(split["train"])
    val = set(split["val"])
    test = set(split["test"])
    if train & val or train & test or val & test:
        raise ValueError("subject leakage across splits")


def write_noneeg_split() -> dict[str, list[int]]:
    assert_disjoint(NONEEG_SPLIT)
    SPLITS.mkdir(parents=True, exist_ok=True)
    path = SPLITS / "noneeg_subjects.json"
    payload = {
        "dataset": "physionet-noneeg-neurological-status-1.0.0",
        "split_unit": "subject",
        "note": "Windows from the same subject stay in one split.",
        **NONEEG_SPLIT,
    }
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    return NONEEG_SPLIT
