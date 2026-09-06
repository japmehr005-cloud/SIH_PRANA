# PRANA

## 1. Project Overview

PRANA is a privacy-preserving Personal Health and Disaster Companion designed to support users before, during, and after emergencies.

The application combines personalized on-device health intelligence with disaster-specific safety assistance and survivor monitoring.

PRANA is designed around three adaptive modes:

1. Normal Mode
2. Disaster Mode
3. Survival Mode

The primary demonstration scenario is a sudden Nepal-style flash flood in which conventional communication infrastructure may become unavailable or unreliable.

The Nepal flood scenario is the primary validation and demonstration case. The underlying architecture should remain applicable to floods, fires, heat waves, cyclones, pollution events, and other emergencies.

PRANA must feel like a professional public-service application rather than a generic fitness application, AI dashboard, or prototype generated from templates.

---

## 2. Core Product Concept

PRANA follows the lifecycle:

NORMAL → DISASTER → SURVIVAL

### Normal Mode

PRANA functions as a general health companion.

It learns the user's personal health baseline and monitors meaningful changes in physiological and behavioral patterns.

### Disaster Mode

When an emergency is detected or an official warning is received, PRANA changes into a disaster assistance system.

It provides:

- Disaster-specific warnings
- Safety instructions
- Offline guidance
- Local emergency information
- Device-to-device warning propagation where supported
- Offline operation when internet connectivity is unavailable

### Survival Mode

When a user becomes stranded or remains in a dangerous environment, PRANA prioritizes survival and rescue assistance.

It monitors:

- Physiological state
- Movement
- Falls
- Prolonged immobility
- Health deterioration
- Location
- Battery state
- Connectivity state

It can create an emergency event packet, store it locally when disconnected, and forward it when a communication path becomes available.

---

## 3. Core USPs

### USP 1: Personalized Health Intelligence

PRANA learns what is normal for the individual.

Instead of depending entirely on universal thresholds, the system maintains a personal baseline using available health and activity data.

Example:

Normal resting HR:
62–72 BPM

Current HR:
108 BPM

The system considers the deviation from the user's baseline along with activity, environment, and other available signals.

The system must describe this as an elevated risk or abnormal deviation rather than diagnosing a medical condition.

---

### USP 2: Decentralized Disaster Intelligence

During a disaster, Aarogya becomes an offline-first local warning and safety system.

The system should support two sources of emergency activation:

#### Official warning

An emergency warning is received from an authorized source.

Example:

Flood warning → Aarogya activates Flood Mode.

#### Local emergency detection

When official communication is unavailable, the system may use supported local signals and device-to-device information to identify or propagate a possible emergency.

The system must not claim that a smartphone can reliably detect every disaster.

Supported scenarios should be explicitly defined and tested.

Aarogya should support local communication concepts such as:

Device A → Device B → Device C → Connected/Rescue Device

This should use an abstraction layer so BLE, Wi-Fi Direct, or another communication mechanism can be implemented or simulated independently.

---

### USP 3: Survivor Health and Rescue Intelligence

After a disaster, Aarogya continues to operate locally when the user is stranded.

The system monitors the user's condition and can detect:

- Possible falls
- Prolonged immobility
- Abnormal physiological changes
- Physical deterioration
- Possible distress events

When a critical event occurs, Aarogya creates a compact emergency packet.

Example:

EVENT: Possible Fall
TIME: 14:08
LOCATION: 27.xxxx, 85.xxxx
HR: 116 BPM
SpO₂: 93%
MOVEMENT: None
BATTERY: 32%
CONNECTIVITY: Offline

If communication is unavailable, the event must be stored locally.

When connectivity becomes available:

Stored event → queued → transmitted → delivery confirmed

The UI must never claim that an emergency message was delivered when it has only been stored locally.

---

## 4. Primary Demonstration Narrative

The main SIH demonstration should follow one continuous scenario.

### Scenario

A person is located in a flood-affected region similar to the Nepal flash flood scenario.

The user has:

- Smartphone
- Smartwatch or wearable
- Limited battery
- Intermittent or no internet connectivity

#### Stage 1: Before the emergency

Aarogya operates in Normal Mode.

The system has learned the user's baseline.

Example:

HR: 62–72 BPM
SpO₂: 96–99%
Activity: Moderate

Status:

NORMAL

---

#### Stage 2: Sudden flood

A flood warning is received or the supported emergency detection system identifies a possible flood situation.

Aarogya switches to:

FLOOD MODE

The application displays:

- Current emergency status
- Offline safety instructions
- User location
- Suitable safer areas where reliable offline geographic data is available
- Connectivity status
- Battery status

Flood guidance should prioritize moving toward an appropriate safer location.

Do not equate altitude alone with safety.

---

#### Stage 3: Connectivity failure

The internet becomes unavailable.

Critical Aarogya functionality continues locally.

The application must still be able to:

- Display stored emergency information
- Run local inference
- Monitor available sensors
- Display disaster instructions
- Record emergency events
- Queue emergency messages

---

#### Stage 4: Local warning propagation

If implemented in the prototype, nearby devices exchange emergency information locally.

Example:

Device A
↓
Device B
↓
Device C
↓
Connected rescue node

The prototype should clearly distinguish between simulated communication and a production communication implementation.

---

#### Stage 5: User becomes stranded

Aarogya enters:

SURVIVAL MODE

The interface becomes more focused and removes unnecessary information.

Priority information:

- Current risk
- Current vital readings
- Last known movement
- Fall status
- Location
- Battery
- Connectivity
- Emergency status

---

#### Stage 6: Physiological deterioration

A simulated sensor stream is fed into the actual inference pipeline.

Example:

Initial:

HR: 72
SpO₂: 98%
Movement: Normal
Risk: LOW

Later:

HR: 103
SpO₂: 95%
Movement: High
Risk: MODERATE

Later:

HR: 116
SpO₂: 93%
Movement: Irregular
Risk: HIGH

Aarogya should provide an explainable warning such as:

"Your current readings differ significantly from your usual baseline."

The system should display the factors contributing to the risk where technically supported.

---

#### Stage 7: Fall

A simulated accelerometer/gyroscope sequence represents:

Normal movement
→ sudden acceleration
→ impact
→ orientation change
→ little/no movement

Aarogya displays:

POSSIBLE FALL DETECTED

The user receives a configurable response period.

If there is no response:

CRITICAL EVENT

---

#### Stage 8: Emergency packet

The emergency packet is generated locally.

Example:

SURVIVOR ALERT

Risk: CRITICAL
Fall: Detected
Movement: None
HR: 116 BPM
SpO₂: 93%
Location: Available
Battery: 32%
Connectivity: Offline

Status:

EMERGENCY EVENT STORED LOCALLY

---

#### Stage 9: Communication restored

When a communication path becomes available:

Stored event
→ Queue
→ Transmission
→ Rescue dashboard
→ Delivery confirmation

The rescue dashboard displays the survivor's latest relevant emergency information.

This is the final demonstration point.

---

## 5. Product Modes

### Normal Mode

Purpose:

General health monitoring and personal baseline learning.

Main features:

- Health dashboard
- Personal baseline
- Health trends
- Activity
- Sleep
- HR
- SpO₂
- Temperature where available
- Risk indicators
- Personal recommendations

The UI should remain calm and uncluttered.

---

### Disaster Mode

Purpose:

Protect the user during an active disaster.

Main features:

- Disaster identification
- Disaster type
- Emergency instructions
- Offline map
- Safer-location guidance
- Local warning information
- Device-to-device warning propagation
- Connectivity status
- Battery conservation
- Emergency contact access

The interface should become more prominent and action-oriented without becoming visually chaotic.

---

### Survival Mode

Purpose:

Support a person who is stranded after or during a disaster.

Main features:

- Continuous health monitoring
- Fall detection
- Immobility detection
- Physiological deterioration detection
- Emergency event creation
- Location capture
- Local emergency storage
- Store-and-forward communication
- Battery-aware operation

The UI should prioritize critical information over normal health statistics.

---

## 6. AI Architecture

Aarogya should use AI for risk detection and anomaly detection rather than disease diagnosis.

Initial AI components:

### Personal Baseline Model

Determines the user's normal range and identifies deviations.

Inputs may include:

- HR
- SpO₂
- Temperature
- Activity
- Sleep
- Historical readings

---

### Fall Detection Model

Uses:

- Accelerometer
- Gyroscope
- Movement history

Potential detection sequence:

Acceleration spike
→ impact
→ orientation change
→ inactivity

Output:

Possible fall

---

### Physiological Deterioration Model

Combines available physiological and behavioral information.

Potential inputs:

- HR
- SpO₂
- Temperature
- Activity
- Sleep/rest
- Personal baseline

Output:

LOW
MODERATE
HIGH
CRITICAL

---

### Disaster Context Engine

Combines:

Physiological state
+
Activity
+
Environmental conditions
+
Disaster context
+
Personal baseline

The same physiological reading may have different significance depending on the user's situation.

Example:

High HR during exercise may be expected.

High HR while stationary during extreme environmental conditions may require a higher risk score.

---

## 7. Edge AI Requirements

Critical inference should operate locally.

Preferred model deployment options:

- ONNX Runtime Mobile
- TensorFlow Lite
- Other suitable mobile inference runtimes

The final choice should be based on:

- Model size
- Inference latency
- Memory usage
- Device compatibility
- Ease of mobile integration

Every model must define:

- Input schema
- Preprocessing
- Output schema
- Risk interpretation
- Missing-data behavior
- Model version
- Test cases
- Performance measurements

Do not invent clinical accuracy numbers.

If synthetic or replayed sensor data is used for the prototype, it must be clearly identified as simulation data.

Research and training datasets are specified in DATASETS.md. Those datasets support baseline, context, and sensor-fusion experiments. They are not clinical validation datasets and do not complete Disaster Mode or Survival Mode coverage.

---

## 8. Data Architecture

The system should follow an offline-first data model.

Local device:

Sensor Data
↓
Preprocessing
↓
Local Storage
↓
Edge Inference
↓
Risk Engine
↓
Local UI / Emergency Event

Optional cloud synchronization should happen only when permitted and available.

Critical functionality must not depend on a cloud server.

Sensitive health information should remain local by default.

---

## 9. Emergency Communication Architecture

Emergency communication should be abstracted behind a communication interface.

Possible transports:

- Internet
- Cellular
- BLE
- Wi-Fi Direct
- Local device-to-device transport
- Future disaster communication mechanisms

The application must track message state explicitly.

Recommended states:

CREATED
STORED
QUEUED
TRANSMITTING
SENT
DELIVERY_CONFIRMED
FAILED

Never represent an unconfirmed transmission as successful.

---

## 10. Privacy

Privacy is a core product requirement.

Principles:

- Local processing by default
- Minimum necessary data transmission
- User-controlled sharing
- Explicit location permission
- Explicit health/sensor permissions
- No unnecessary cloud storage
- No sensitive data in application logs
- No secrets in source code

The application should clearly communicate when information leaves the device.

---

## 11. Language Support

Aarogya must support:

1. English
2. Hindi

Hindi must use proper Devanagari.

Example:

English:
"Possible fall detected"

Hindi:
"संभावित गिरने की घटना का पता चला"

All user-facing strings must use localization keys.

No hard-coded user-facing strings should exist in business logic or UI components.

Language switching must not reset the user's state or active emergency.

---

## 12. Visual Design

Aarogya should look like a professional Indian public-service application.

The reference point is the clarity and restraint of established government digital services, including the general visual discipline of Aarogya Setu.

Aarogya must NOT copy:

- Aarogya Setu logo
- Government logos
- Trademarked branding
- Exact screens
- Proprietary assets
- Proprietary illustrations

The visual identity must be original.

### Design characteristics

- Light neutral background
- Restrained green/teal primary color
- Controlled warning colors
- Strong typography hierarchy
- Clear section headings
- Consistent spacing
- Accessible contrast
- Subtle borders and elevation
- Large readable status values
- Clear emergency states
- Minimal decorative elements

Avoid:

- Emojis
- Excessive gradients
- Glassmorphism
- Neon colors
- Excessive shadows
- Decorative blobs
- Huge rounded cards
- Gamification
- Excessive animations
- Generic AI dashboard aesthetics
- Stock-image-heavy screens
- Fake-looking placeholder content

The application should look deliberately designed and suitable for a public-service environment.

---

## 13. UX Principles

Every screen must have a clear purpose.

Users should always understand:

1. What is happening?
2. What is my current risk?
3. What should I do?
4. Is the system connected?
5. Is my emergency information being transmitted?

Emergency information must be prioritized over secondary information.

The application should never overwhelm the user with unnecessary statistics during an emergency.

---

## 14. Safety and Medical Positioning

Aarogya is not a medical diagnostic system.

Use:

"Elevated health risk detected."

"Your current readings differ significantly from your usual baseline."

"Possible fall detected."

"Emergency event recorded."

Avoid unsupported statements such as:

"You are having a heart attack."

"You are definitely dehydrated."

"You have a medical condition."

"This system will save your life."

The system should be presented as a risk detection, safety assistance, and emergency support system.

---

## 15. Technical Stack

Initial preferred stack:

### Mobile Application

Flutter
Dart

### SIH demonstration target

Flutter Web, hosted as a static site (for example on Vercel).

The browser demo reuses the same Dart domain, inference, and emergency pipeline.

The long-term product remains a mobile-first companion.

See docs/WEB_DEMO.md.

### State Management

Riverpod or another predictable state-management system.

### Navigation

GoRouter or equivalent.

### Local Database

SQLite with Drift or an equivalent structured local database.

### Edge AI

PyTorch for model development.

ONNX Runtime Mobile or TensorFlow Lite for mobile deployment.

### Data Processing

Python
NumPy
Pandas
Scikit-learn

### Wearable Communication

Bluetooth Low Energy.

### Sensors

Where available:

- Heart rate
- SpO₂
- Temperature
- Accelerometer
- Gyroscope
- Activity
- Sleep

### Location

Native device GPS/location APIs.

### Offline Maps

Use an appropriate offline-capable mapping solution.

### Backend

Optional.

The backend must never be required for critical local functionality.

---

## 16. Development Architecture

Separate the application into:

Presentation
↓
Application / State
↓
Domain
↓
Data
↓
Sensors / Communication
↓
Local Storage / Edge AI

Recommended conceptual modules:

- auth
- onboarding
- health
- baseline
- sensors
- edge_ai
- disaster
- survival
- emergency
- communication
- location
- maps
- localization
- settings
- rescue_dashboard

The exact folder structure can change if the implementation benefits from another organization, but responsibilities must remain separated.

---

## 17. Demo Simulation System

The prototype must support deterministic sensor replay.

Example demonstration replay files:

normal.csv
flood_exertion.csv
health_deterioration.csv
fall.csv

These files are synthetic application replay inputs. They are not the PhysioNet or Empatica E4 research datasets. See DATASETS.md for the current prototype research datasets and their limitations.

The simulator should feed the same interfaces used by real sensors.

Correct:

Sensor Simulator
→ Sensor Interface
→ Preprocessing
→ AI
→ Risk Engine
→ State Machine
→ UI

Incorrect:

Demo Button
→ Directly change UI state

The demo must demonstrate the actual application logic.

Simulation code must remain clearly separated from production sensor adapters.

---

## 18. Definition of Done

A feature is complete only when:

- It is connected to the correct domain logic.
- It has proper loading/error/empty/offline states.
- It supports English and Hindi where user-facing.
- It handles missing sensor data.
- It has appropriate tests.
- The application builds successfully.
- It works on the target Android device/emulator.
- It does not rely unnecessarily on network connectivity.
- It does not contain debug-only shortcuts in the production path.
- It follows the Aarogya visual system.
- It does not introduce unsupported medical claims.
- It does not create fake delivery confirmations.
- It does not expose sensitive health information in logs.

---

## 19. Primary Success Criteria

The prototype should successfully demonstrate:

### Before disaster

Personalized health baseline.

### During disaster

Emergency mode activation.

Offline disaster guidance.

Local warning propagation where implemented.

### After disaster

Survival Mode.

Health monitoring.

Fall detection.

Physiological deterioration detection.

Emergency event creation.

Offline event storage.

Communication restoration.

Emergency packet transmission.

Rescue dashboard.

The complete flow should work as one continuous scenario.

---

## 20. Product Identity

Product name:

Aarogya

Core concept:

Personal Health + Disaster Intelligence

Three-mode model:

NORMAL
→ Know the user

DISASTER
→ Guide the user

SURVIVAL
→ Monitor and locate the user

Primary narrative:

A sudden flood leaves a person stranded with unreliable connectivity. Aarogya adapts from a normal health companion into an offline disaster assistant and finally into a survivor monitoring and rescue system.

The product should always communicate one central idea:

Aarogya remains useful when normal systems become unreliable.
