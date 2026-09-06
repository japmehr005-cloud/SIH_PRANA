/// How a [SensorSample] entered the pipeline.
///
/// Demo CSV replay uses [simulation]. Research-window CSVs use [dataset].
/// [device] is this phone/browser's motion sensors. [wearable] is a paired
/// Bluetooth heart-rate monitor when the browser actually connects.
enum SensorSourceKind { simulation, dataset, wearable, device }

extension SensorSourceKindX on SensorSourceKind {
  static SensorSourceKind? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return SensorSourceKind.values.asNameMap()[raw];
  }
}
