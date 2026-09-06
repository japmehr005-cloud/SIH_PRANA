from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

NONEEG_RAW = (
    ROOT
    / "Non-EEG Dataset for Assessment of Neurological Status"
    / "non-eeg-dataset-for-assessment-of-neurological-status-1.0.0"
)

E4_RAW = (
    ROOT
    / "wearable-device-dataset-from-induced-stress-and-structured-exercise-sessions-1.0.1"
    / "wearable-device-dataset-from-induced-stress-and-structured-exercise-sessions-1.0.1"
)

DATA = ROOT / "data"
PROCESSED = DATA / "processed"
FEATURES = DATA / "features"
SPLITS = DATA / "splits"
ARTIFACTS = ROOT / "artifacts"
ASSET_MODELS = ROOT / "assets" / "models"

WINDOW_SECONDS = 30
FEATURE_VERSION = "physio-features-v1"
PREPROCESS_VERSION = "physio-preprocess-v1"
MODEL_NAME = "physio-context"
MODEL_VERSION = "physio-context-v1"
DATASET_ID = "physionet-noneeg-neurological-status-1.0.0"

ALLOWED_NONEEG_LABELS = (
    "Relax",
    "PhysicalStress",
    "EmotionalStress",
    "CognitiveStress",
)
