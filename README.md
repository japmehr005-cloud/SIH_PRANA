# PRANA

**Personal Health & Emergency Assistance**

PRANA is an offline-first companion for personal health monitoring and disaster assistance. It is designed around three modes:

1. **Normal** — personal baseline and local health monitoring
2. **Disaster** — local warning and safety guidance after an official or supported activation
3. **Survival** — stranded-user monitoring, emergency information, and store-and-forward

The primary demonstration scenario is a Nepal-style flash flood. The architecture is intended to remain usable for other supported emergencies.

PRANA is a risk detection and emergency assistance system. It is not a medical diagnostic product.

Product definition: [PROJECT.md](PROJECT.md). Research datasets: [DATASETS.md](DATASETS.md). Web demo notes: [docs/WEB_DEMO.md](docs/WEB_DEMO.md).

## Core capabilities

- Personal health baseline from recent resting readings
- On-device physiological assessment (current readings vs usual pattern)
- Fall / movement assessment
- Location and safer-place guidance from bundled geographic data
- Emergency information packets stored on the device
- Multi-user local accounts (each user’s baseline, readings, and packets stay isolated)
- Offline persistence on the current device
- Rescue workflow for the signed-in user’s emergency record
- PRANA Assistant — explains the current session; it does not invent a new health state

## What is real, demonstration, hardware-dependent, or not implemented

### Real / implemented

- Emergency state machine (Normal → Disaster → Survival → emergency event)
- On-device baseline, physiological assessment, and fall-sequence engines
- Trained on-device models shipped as JSON plus metadata (`assets/models/`)
- Local accounts, password hashing, and per-user record isolation
- Refresh persistence of the signed-in user’s health and emergency records
- Safer-location distance and direction from bundled Kathmandu / Delhi GeoJSON
- English and Hindi UI
- PRANA Assistant grounded in current session state (not a cloud language model)
- Flutter Web production build for the SIH presentation

### Demonstration

- CSV condition profiles (Resting, Physical activity, High load, Fall / impact)
- Official flood warning activation from the Continue demonstration
- App connectivity adapter (Connected / Limited / Offline)
- Nearby PRANA user relay on the same browser origin (not Bluetooth or mesh)
- Bundled demonstration regions and OSM map tiles when a network can load them
- Continue presenter (`/#/demo`) driving the live Health and Rescue surfaces

### Hardware-dependent

- Browser DeviceMotion
- Web Bluetooth heart-rate accessories (not Apple Watch or Fitbit pairing)
- Native GPS when the browser grants it **and** the fix is inside a bundled region

### Not implemented

- Live NDMA / NRA or other official disaster APIs
- Official flood layers or turn-by-turn street routing
- Cloud ML inference
- Native BLE mesh
- Required cloud authentication (Supabase is optional and unused unless configured)
- A shipping Android APK as the SIH target (Android sources remain in the repo)

## Offline demo

Core demonstration paths do **not** require Supabase, live disaster APIs, cloud inference, or private API keys.

The browser demo uses a local account registry and local persistence. Supabase files remain in `supabase/` for a later optional sync slice. Only a publishable URL and anon key would ever be compiled in, via `--dart-define`. The service-role key must never be committed or shipped.

## Requirements

- Flutter 3.47 or later (this repo was verified with the Flutter SDK on PATH)
- A desktop browser for the SIH demonstration

The Android SDK is not required for the web demo.

## Run locally

```bash
flutter pub get
flutter gen-l10n
flutter test
flutter run -d chrome
```

Flutter Web uses hash routes. After launch:

| Screen | URL |
|---|---|
| Home | `/#/` |
| Health | `/#/health` |
| Assistant | `/#/assistant` |
| Disaster | `/#/disaster` |
| Continue demonstration | `/#/demo` |
| Survival | `/#/rescue` |
| Devices | `/#/devices` |
| Account | `/#/account` |
| Settings | `/#/settings` |

```bash
flutter run -d web-server --web-port 8080
```

then open `http://localhost:8080/#/`.

## Tests

```bash
flutter analyze
flutter test
```

## Production web build

```bash
flutter build web --release --no-web-resources-cdn
```

Static output is `build/web` (not committed). Serve that folder for a local production walk.

## Architecture (high level)

```
Sensor or demonstration input
  → preprocessing
  → on-device inference
  → risk engine
  → emergency state machine
  → UI / emergency packet / Assistant explanation
```

Shared contracts include `SensorSource`, `InferenceEngine`, `EmergencyStateMachine`, `CommunicationTransport`, `ConnectivityService`, `LocationService`, `HealthRepository`, and `EmergencyRepository`.

The Dart package name remains `aarogya`. The public product name is PRANA.

## Datasets and models

The app ships small labeled demonstration CSVs in `assets/demo/` and model JSON plus metadata in `assets/models/`.

Research recordings (Non-EEG, Empatica E4, SisFall) are **not** part of the git payload. Obtain them from the sources listed in [DATASETS.md](DATASETS.md) if you need to retrain. Training scripts live in `ml/`. Subject splits used by tests live in `data/splits/`.

## Deployment (Vercel)

The production site is a static Flutter Web build. Vercel clones this repository, runs [tool/vercel_build.sh](tool/vercel_build.sh), and serves `build/web`.

[vercel.json](vercel.json) sets:

- Framework: Other (`null`)
- Install: skip npm (this is not a Node app)
- Build: `bash tool/vercel_build.sh`
- Output: `build/web`
- SPA rewrite to `index.html` so a refresh of `/login` still boots the app
- Hash routes (`/#/login`, `/#/assistant`, …) never need the rewrite; the browser keeps the fragment

The build script installs Flutter **3.47.2** on the Linux builder when Flutter is not already on `PATH`, then runs the same release command used locally:

```bash
flutter build web --release --no-web-resources-cdn
```

### Import the GitHub repository

1. In Vercel, **Add New… → Project** and import `japmehr005-cloud/SIH_PRANA`.
2. Confirm the root directory is the repository root.
3. Leave Framework as Other. `vercel.json` supplies the build and output settings.
4. Do **not** add a service-role key or any private credential.
5. Deploy. The first build clones Flutter and may take several minutes.

Production and preview deployments use the same offline/local-account demo. Supabase is not required.

### Optional environment variables

Set these in the Vercel project only if you want optional cloud sync. They are **build-time** dart-defines (not browser secrets beyond the public anon key). Leave both empty for the offline demo.

| Name | Required | Purpose |
|---|---|---|
| `SUPABASE_URL` | No | Publishable Supabase project URL |
| `SUPABASE_ANON_KEY` | No | Publishable / anon key only |

Never set a Supabase service-role key, database password, or private API key on Vercel.

Copy [.env.example](.env.example) for local placeholders. Never commit a service-role key, password, or private certificate.

## Medical positioning

Use risk and assistance language only. Do not claim a diagnosis or that the system will save a life.
