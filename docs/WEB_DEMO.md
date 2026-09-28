# PRANA SIH Web Demo

## Architecture decision

**Selected: Flutter Web**, not a separate React/Next.js frontend.

### Why

1. The domain layer, state machine, inference engines, repositories, and demo replay pipeline are already pure Dart.
2. The UI, localization, and routing are already Flutter widgets.
3. In-memory adapters already exist and are what the passing tests use.
4. Rewriting into Next.js would duplicate domain logic and risk a fake demo that bypasses the real pipeline.
5. Flutter Web builds a static `build/web` directory that Vercel can host.

The long-term product remains a mobile-first companion. Android code stays. The browser app is the SIH presentation target.

## Reuse vs platform work

| Area | Status |
|---|---|
| Emergency state machine | Reused |
| Baseline, fall, and risk engines | Reused |
| Sensor, inference, communication, connectivity, location contracts | Reused |
| CSV replay and demo datasets | Reused |
| English/Hindi ARB localization | Reused |
| Emergency packets and store-and-forward | Reused |
| Drift/SQLite disk persistence | Mobile/desktop only |
| Web local snapshot | SharedPreferences / localStorage, scoped by account |
| Accounts and remote sync | Optional Supabase Auth + Postgres + RLS |
| BLE, native GPS, Android emulator | Not required for SIH |
| Browser adapters | Same contracts as future mobile adapters |
| Desktop-responsive chrome | Web presentation layer |

## Browser adapters

The browser uses the same domain pipeline as the rest of the app:

- CSV replay plus optional browser DeviceMotion / Web Bluetooth heart rate, merged through `SensorSource`
- `InMemoryConnectivityService` (demo connectivity adapter)
- Nearby demonstration relay (`NearbyRelayTransport`) on SharedPreferences / localStorage, not Bluetooth
- `CompositeLocationService`: browser Geolocation is applied only when the fix is inside a bundled demonstration region (Kathmandu or Delhi). Otherwise the chosen demonstration area is kept.
- Bundled Kathmandu and Delhi GeoJSON for safer-location math; OSM tiles when the network can load them. Guidance is never drawn as a street route.
- In-memory health and emergency repositories wrapped by `LocalRecordStore`
- Optional `SyncService` when signed in **and** the app connectivity adapter is online

These implement the same contracts as future mobile adapters. Inference stays in `LocalInferenceEngine`. A refresh no longer wipes a signed-in user's baseline or emergency packet.

## Local and Vercel URLs

Hash routes:

- Home: `/#/`
- Health: `/#/health`
- Assistant: `/#/assistant`
- Disaster: `/#/disaster`
- Demo: `/#/demo`
- Survival / Rescue: `/#/rescue`
- Devices: `/#/devices`
- Settings: `/#/settings`
- Account: `/#/account`
- Sign in: `/#/login`
- Register: `/#/register`

A page reload of `/demo` without the hash still serves `index.html` because of the Vercel rewrite.

## Accounts and persistence

The deployed browser demo uses a **local account registry** (SharedPreferences / localStorage). Supabase is not required.

1. A cold open without a session shows `#/login`.
2. Register, sign in, or continue as a demonstration user. Passwords are hashed on the device. Any password is not accepted.
3. Home, Demo, Rescue, Account, and Settings require a session.
4. Each account stores only that user's observations, baseline, assessment, snapshot, and packets.
5. Rescue shows that user's emergency record, not a global inbox.
6. Refresh restores the session and that user's records.
7. Language switch does not reset auth or emergency state.
8. Demo reset clears the current session's health and emergency records. It does not delete the account.

`AccountRepository` / `HealthRepository` / `EmergencyRepository` / `SyncRepository` stay the integration points. Today's web adapters are local. Supabase files remain for a later cloud sync slice.

See [supabase/README.md](../supabase/README.md) if you later add a project. Only the publishable/anon key is ever shipped.

Vercel build (`tool/vercel_build.sh`) forwards these **optional** build-time variables:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Leave both unset for the offline/local-account demo. If you add them later, set them as Vercel project environment variables for Production and Preview. Never add a service-role key.

## Remaining limitations

- Drift/SQLite disk persistence remains on mobile/desktop IO builds.
- Nearby sharing is a same-origin browser demonstration relay, not BLE mesh.
- No live NDMA/NRA disaster APIs, official flood layers, or turn-by-turn street routing.
- Web Bluetooth heart-rate access needs a supporting browser and a user gesture. DeviceMotion depends on the device.
- Connectivity is a demo adapter. The Need help beat marks the **app** as limited so sync does not call the network even if the laptop is online.
- Flutter Web is the presentation target. An Android APK remains a future mobile artifact.
- PRANA Assistant is a first-class `/#/assistant` page. It compiles the current session, classifies the question, and composes EN/HI answers from trusted catalogs. It is not a cloud or on-device language model, and it is not a Continue-stage card.

## Honesty report

Measured on 7 Sep 2026 after `flutter analyze` (clean), `flutter test` (93 passed), `flutter build web --release --no-web-resources-cdn`, and a production-build browser walk at `http://127.0.0.1:4180`.

1. **Functional**
   - Wide chrome (1400×900) left rail: **Home · Health · Assistant · Rescue · Account · Settings**. Assistant is `/#/assistant`, not a Continue stage.
   - Login → **Continue as demonstration user** → Home overview (situation **Normal**, **Ask PRANA Assistant**, **Open Health**, **Continue demonstration**). Health (`/#/health`) showed Your health, connected device, baseline, health assessment, and a compact **Ask PRANA Assistant** link. No large Assistant card on the health stage or Continue step 1.
   - **Resting** through the real pipeline: baseline history **13**, heart rate **65 / 66 BPM**, SpO2 **99 / 98%**. **High load** then **118 / 66 BPM**, **93 / 98%** SpO2, elevated-load context **100%**.
   - Assistant suggested **Why did my status change?** submitted immediately and answered from session facts: readings differ from the usual baseline, recent heart rate higher than the usual resting pattern, rest-and-recheck, **118 BPM vs usual rest 66 BPM**, blood oxygen **93% vs usual 98%**, elevated-load context, demonstration-data note. No diagnosis and no engine names.
   - **Where should I go?** used the location engine: **Tudikhel / Ratna Park, approximately 1895 metres southwest**. A second grounded place (**Shankha Park, 1576 metres east**) also appeared from the same catalog. No invented coordinates.
   - Continue step 2 entered **DISASTER ACTIVE** with the official flood warning. Returning to `/#/assistant` without resetting the demo changed the status strip to **Emergency / Disaster active** and reordered chips to **What should I do? / Where should I go? / What if I need help?** first.
   - **What should I do?** used the disaster catalog and live guidance: situation requires attention, Disaster active, official flood warning, move toward a suitable safer location, avoid moving water, avoid flooded electrical areas, **Tudikhel / Ratna Park**, **1895 m SW**. No street-route claim.
   - **Fall / impact** on Health entered a possible-fall check with **I am safe / I need help**. Assistant showed the same actions. **I need help** created the emergency packet through the existing runtime. Rescue then showed **My emergency information**, **Delivered**, **Emergency event transmitted.**, location **27.717, 85.324**, Tudikhel **1895 m SW**. Event id stayed off the public brief.
   - Sign-out and sign-in as the same demonstration user restored the session, health records, emergency phase, and recent Assistant turns from the local account store.
   - User A / User B Assistant isolation is covered by `assistant_controller_test` and `assistant_store_test` (per-user SharedPreferences keys). A second live registration from Playwright did not reach the Flutter email controller, so that browser account-switch was not completed on this walk.
   - Free-text routing (**What is my normal heart rate?**, unrecognized questions) is covered by widget and domain tests. Playwright could not focus the Flutter Web canvas field; the field is visible as **Ask about this session**.
   - Settings → Technical information: **On-device assistant** — uses session state, disaster guidance, and location guidance on this device; does not call a cloud language model.
2. **Demonstration-only:** CSV condition profiles, flood warning, connectivity adapter, bundled Kathmandu/Delhi GeoJSON, same-origin nearby sharing, OSM raster tiles, `fall-seq-v1` for sparse demo CSV including `fall.csv`. The assistant only restates those session facts.
3. **Hardware:** DeviceMotion and Web Bluetooth HR when the browser exposes them. Native mesh is not in this web build.
4. **Unavailable:** live disaster APIs, official flood layers, turn-by-turn routing, Apple Watch/Fitbit pairing, cloud or on-device LLM answers.
5. **Limitations found in testing**
   - Flutter Web needs the semantics placeholder enabled before assistive snapshots work. This walk used a fresh production build on **4180** so an older `main.dart.js` was not served.
   - Suggested questions are pinned above the conversation so they stay tappable. The text field still has a wide merged **Send** semantics box on Flutter Web.
   - **Use device location** still depends on the browser Geolocation prompt. Out-of-region GPS is rejected in tests; this walk did not grant a live GPS fix.
   - SisFall `fall-window-v1` measured scores remain: sensitivity 0.333, specificity 0.828, precision 0.562, F1 0.417 in `assets/models/fall_window.meta.json`.
