# Aarogya Agent Coordination

Read [PROJECT.md](PROJECT.md) and the applicable files in [.cursor/rules](.cursor/rules) before making product or architectural decisions.

Specialist definitions live in [.cursor/agents](.cursor/agents). This file defines ownership boundaries so work is not duplicated.

## Source of Truth

- Product direction, modes, demo narrative, and medical positioning: `PROJECT.md`
- Research and training datasets: `DATASETS.md`
- SIH browser demo target: `docs/WEB_DEMO.md`
- Always-on engineering constraints: `.cursor/rules/00-aarogya-core.mdc`
- UI: `.cursor/rules/01-ui-design.mdc`
- Localization: `.cursor/rules/02-i18n.mdc`
- Architecture: `.cursor/rules/03-architecture.mdc`
- On-device intelligence: `.cursor/rules/04-ai-edge.mdc`
- Emergency safety: `.cursor/rules/05-emergency-safety.mdc`
- Verification: `.cursor/rules/06-testing.mdc`
- Dataset hygiene: `.cursor/rules/07-datasets.mdc`

## Specialist Ownership

| Specialist | Owns | Does not own |
|---|---|---|
| product-architect | Architecture, domain boundaries, state machine, feature plans, repository contracts | Visual polish, model training, pixel-level UI |
| ui-engineer | Design system, screens, navigation, EN/HI strings in widgets, loading/empty/error/offline states | Domain rules, inference, packet transport |
| edge-ai-engineer | Baseline, preprocessing, fall detection, deterioration, risk engine, model metadata | Disaster guidance copy, store-and-forward, widget layout |
| disaster-systems-engineer | Disaster Mode, offline guidance, local communication, emergency packets, store-and-forward | Baseline math, visual design system |
| qa-safety-reviewer | Independent review of safety, offline behavior, AI integrity, localization, demo pipeline | Silently changing product scope |

## Handoff Rules

1. Cross-cutting features start with the product architect. Other specialists consume the resulting contracts.
2. UI consumes application state and domain outputs. It does not invent risk rules, packet states, or mode transitions.
3. Edge AI returns structured assessments. It does not mutate UI or emergency state directly.
4. Disaster systems own packet lifecycle and transport. They do not reimplement inference.
5. QA reviews after a meaningful slice. Findings are reported; scope is not rewritten during review.

## Shared Contracts

These interfaces are the integration points. Do not create a second parallel implementation.

- `SensorSource`
- `InferenceEngine`
- `EmergencyStateMachine`
- `CommunicationTransport`
- `ConnectivityService`
- `LocationService`
- `HealthRepository`
- `EmergencyRepository`

Simulation and production adapters must implement the same contracts.

## Demo Integrity

A demo control may inject a sensor or warning sequence.

It must not set the final UI result.

Required path:

Sensor or event input → preprocessing → inference → risk engine → state machine → UI / emergency packet
