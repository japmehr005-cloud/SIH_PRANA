# Aarogya Datasets

`DATASETS.md` is the authoritative description of the current prototype research datasets.

[PROJECT.md](PROJECT.md) remains the product source of truth. This file does not change the three-mode architecture, medical positioning, or offline-first requirements.

The demonstration CSV files under `assets/demo/` are synthetic replay data for the application pipeline. They are not the research datasets described here and must stay labeled as simulation.

---

## Current dataset status

Available:

- [x] Non-EEG Dataset for Assessment of Neurological Status
- [x] Wearable Device Dataset — Empatica E4
- [x] SisFall (IMU fall versus activities of daily living)

Still required:

- [ ] Additional data/validation for survival-mode physiological deterioration
- [ ] Disaster simulation scenarios
- [ ] Communication failure/store-and-forward test data

Do not train fall detection on Non-EEG or Empatica E4. They do not contain fall labels. SisFall is the fall dataset.

---

## 1. Non-EEG Dataset for Assessment of Neurological Status

Source: PhysioNet — A Non-EEG Dataset for Assessment of Neurological Status

Published: July 19, 2017

Version: 1.0.0

Size: approximately 3.7 MB uncompressed

The dataset contains non-EEG physiological signals collected from 20 healthy subjects using non-invasive wrist-worn biosensors.

Signals:

- Electrodermal Activity (EDA)
- Temperature
- Acceleration
- Heart Rate (HR)
- Arterial oxygen level (SpO2)

The data is provided in WFDB format with two records per subject:

1. Accelerometer + temperature + EDA
2. SpO2 + heart rate

Each subject has an annotation file identifying transition states.

`subjectinfo.csv` contains subject information.

Experimental states include:

1. First Relaxation
2. Physical Stress
3. Second Relaxation
4. Mini-emotional Stress
5. Cognitive Stress
6. Third Relaxation
7. Emotional Stress
8. Fourth Relaxation

### Allowed Aarogya uses

- Personal physiological baseline experiments
- HR deviation/anomaly detection
- SpO2 signal processing and anomaly experiments
- Temperature deviation experiments
- Activity/stress context
- Multimodal physiological feature extraction
- Sensor-fusion experiments

### Limitation

This dataset contains healthy participants under controlled experimental conditions.

Do not describe it as a dataset for:

- disease diagnosis
- medical emergencies
- dehydration
- respiratory distress
- disaster survivors
- clinical deterioration

Aarogya should learn deviations from an individual's observed baseline rather than rely only on universal fixed thresholds.

### Citations

Birjandtalab, Javad, Diana Cogan, Maziyar Baran Pouyan, and Mehrdad Nourani, "A Non-EEG Biosignals Dataset for Assessment and Visualization of Neurological Status," 2016 IEEE International Workshop on Signal Processing Systems (SiPS), Dallas, TX, 2016, pp. 110-114. doi: 10.1109/SiPS.2016.27.

Standard PhysioNet citation required by the current dataset release:

Pollard, T., Moody, B. E., Lehman, L., Gow, B., Fernandes, C., Xie, C., Johnson, A., Mark, R. G., & Heldt, T. (2026). PhysioNet as a global platform for biomedical research. Nature Health. https://doi.org/10.1038/s44360-026-00096-z.

---

## 2. Wearable Device Dataset — Empatica E4

The second dataset is an Empatica E4 wearable dataset containing physiological recordings from 36 healthy volunteers.

Participants:

- V1: 18 volunteers
- V2: 18 volunteers

Participants were males and females aged 18–30 years.

Device: Empatica E4 wristband.

Signals and sampling rates:

- PPG/BVP: 64 Hz
- 3-axis accelerometer: 32 Hz
- Skin temperature: 4 Hz
- EDA: 4 Hz
- IBI: beat-to-beat interval
- HR: derived from BVP

Experimental categories:

### Stress

Stress-induction protocols include cognitive and emotional challenges, rest periods, and self-reported stress levels.

### Aerobic Exercise

Structured stationary cycling with progressively increasing intensity.

### Anaerobic Exercise

Repeated high-intensity cycling sprints followed by cooldown periods.

Available files include:

- TEMP.csv
- EDA.csv
- BVP.csv
- ACC.csv
- IBI.csv
- HR.csv
- tags.csv

Additional files include:

- subject-info.csv
- Stress_level_v1.csv
- Stress_level_v2.csv
- data_constraints.txt

### Allowed Aarogya uses

- Activity/context recognition
- Stress/exertion context
- HR behavior during activity
- Temperature behavior
- EDA features
- Accelerometer features
- Multimodal sensor fusion
- Personal-baseline experiments
- Testing whether physiological deviations can be interpreted in context

### Limitation

This dataset contains healthy participants and controlled protocols.

Do not use it to claim that Aarogya clinically diagnoses:

- heart disease
- hypoxia
- dehydration
- heat stroke
- respiratory disease
- neurological disease
- medical collapse

Known data-quality limitations must be respected. Some sessions are incomplete, duplicated, split, or affected by recording issues. Always inspect `data_constraints.txt` before training.

---

## SisFall (IMU fall versus ADL)

Source: Sucerquia, López, and Vargas-Bonilla, Universidad de Antioquia. Public research dataset of accelerometer and gyroscope recordings from a wearable device during falls and activities of daily living.

Hugging Face mirror (approximately 232 MB): place extracted files under gitignored `data/raw/sisfall`.

Sampling: typically 200 Hz IMU. File names encode activity (`D` = ADL, `F` = fall) and subject (`SA` / `SE` plus number).

### Allowed Aarogya uses

- On-device window-feature fall versus ADL experiments
- Subject-level GroupKFold / leave-one-subject-out evaluation
- Exporting a JSON window model for Flutter (`fall-window-v1`)

Shipped `assets/models/fall_window.meta.json` records the measured subject-split scores (do not invent better numbers): 38 subjects, 36,040 windows, sensitivity 0.333, specificity 0.828, precision 0.562, F1 0.417. Sparse demo CSV including `fall.csv` still uses `fall-seq-v1`.

### Limitation

This is not a clinical validation set. It is not a disaster-survivor dataset. Do not report it as proof that Aarogya detects real-world falls with a claimed medical accuracy.

Do **not** use Non-EEG or Empatica E4 recordings as fall labels.

If the SisFall archive cannot be downloaded or trained, keep `fall-seq-v1` as the honest sequence detector and do not claim a trained fall model.

### Citations

Sucerquia A, López JD, Vargas-Bonilla JF. SisFall: A Fall and Movement Dataset. Sensors. 2017;17(1):198.

---

## 3. Aarogya capability mapping

| Aarogya capability | Dataset |
|---|---|
| Personal baseline | Both datasets |
| HR anomaly/deviation | Both |
| SpO2 processing | Non-EEG |
| Temperature deviation | Both |
| Accelerometer/activity context | Both |
| Stress/exertion context | Wearable E4 |
| EDA features | Both |
| Multimodal sensor fusion | Both |
| Fall detection | SisFall only (IMU fall vs ADL). Not Non-EEG. Not Empatica E4. |
| Disaster detection | NOT directly provided |
| Dehydration detection | NOT directly provided |
| Respiratory distress detection | NOT directly provided |
| Survival-mode deterioration | Requires additional data/simulation/validation |

Do not fabricate labels for capabilities that these datasets do not contain.

---

## 4. Data directory structure

Use:

```
data/
├── raw/
│   ├── noneeg/
│   ├── wearable_e4/
│   └── sisfall/
├── processed/
├── features/
├── splits/
└── synthetic/
```

Never modify the original raw datasets.

### Current repository placement

The uploaded archives are currently present at:

- `Non-EEG Dataset for Assessment of Neurological Status/non-eeg-dataset-for-assessment-of-neurological-status-1.0.0/`
- `wearable-device-dataset-from-induced-stress-and-structured-exercise-sessions-1.0.1/wearable-device-dataset-from-induced-stress-and-structured-exercise-sessions-1.0.1/`

Treat those folders as raw sources. Do not rewrite them in place. Future processing output belongs under `data/processed`, `data/features`, `data/splits`, or `data/synthetic`.

---

## 5. Data processing pipeline

Build dataset-specific loaders.

For each dataset:

1. Load the raw signal.
2. Read its native sampling frequency.
3. Convert timestamps into a common time representation.
4. Align signals using timestamps.
5. Detect missing/invalid samples.
6. Apply appropriate signal filtering.
7. Segment signals into fixed windows.
8. Attach the correct experimental/context label.
9. Store processed windows separately from raw data.

Do not assume all signals have the same sampling rate.

Inspect actual files before implementing dataset-specific parsing. Never invent columns, labels, sampling frequencies, subject counts, or medical outcomes.

---

## 6. Feature extraction

Potential HR features:

- Mean HR
- Median HR
- HR standard deviation
- Short-term HR variation
- Change from personal baseline

SpO2:

- Mean SpO2
- Minimum SpO2
- Variability
- Duration of sustained deviation

Temperature:

- Mean temperature
- Temperature trend
- Rate of change
- Deviation from baseline

Accelerometer:

- Acceleration magnitude
- Mean acceleration
- Standard deviation
- Activity intensity
- Motion/no-motion duration

EDA:

- Mean EDA
- Skin conductance level
- Phasic response features
- Change from baseline

Feature engineering must be validated against the actual signals.

---

## 7. Personal baseline model

Aarogya's major differentiator is personalized health intelligence.

Do not build the main system around universal fixed thresholds alone.

Intended flow:

```
User data
↓
Initial baseline period
↓
Personal baseline profile
↓
Continuous sensor observations
↓
Context-aware comparison
↓
Deviation score
↓
Risk/anomaly score
↓
Normal / Attention / Critical
```

The baseline should account for context.

Example: elevated HR during exercise should not automatically be treated as the same anomaly as elevated HR while resting.

This is consistent with the Disaster Context Engine in PROJECT.md. These datasets can support context-aware baseline experiments. They do not by themselves validate disaster or survival outcomes.

---

## 8. Dataset splitting

Avoid subject leakage.

Do not randomly split individual windows from the same person across training and testing when evaluating generalization to unseen users.

Prefer:

- Training subjects
- Validation subjects
- Test subjects

Use subject-level splits where appropriate.

If evaluating within-subject personalization, document that separately from cross-subject generalization.

---

## 9. Disaster and Survival data

The two current wearable datasets do not contain the complete data required for Aarogya's Disaster Mode and Survival Mode.

Do not pretend that they do.

Additional data or clearly marked simulation is required for:

- Fall detection
- Prolonged immobility
- Emergency-event simulation
- Connectivity loss/recovery
- Store-and-forward communication
- Disaster-specific state transitions
- Synthetic flood/fire/heatwave scenarios

Synthetic data must be clearly marked as synthetic.

Never silently mix synthetic data with real physiological recordings.

The existing application replay files (`assets/demo/normal.csv`, `flood_exertion.csv`, `health_deterioration.csv`, `fall.csv`) are synthetic demonstration inputs. They must remain separate from raw and processed research recordings.

---

## 10. Privacy

Aarogya is offline-first.

Training datasets must remain separate from user-generated application data.

The production application should prefer:

- Local preprocessing
- Local feature extraction
- Local inference
- Local storage
- Explicit user-controlled synchronization

Do not upload raw physiological data merely because an AI feature is being used.

Do not commit personal health records or real user location history.

---

## 11. Training and mobile integration

Keep ML training separate from the Flutter mobile application.

Export validated models to a mobile-compatible format such as ONNX or TensorFlow Lite.

Store preprocessing parameters with model metadata.

Every model prediction used by the app must have a defined fallback for missing or unreliable sensor data.

Production inference must safely handle missing, noisy, or unavailable sensors.
