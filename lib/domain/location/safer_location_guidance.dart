import 'package:aarogya/domain/contracts/location_service.dart';

final class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

final class GeoBounds {
  const GeoBounds({
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
  });

  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;

  bool contains(GeoPoint point) {
    return point.latitude >= minLatitude &&
        point.latitude <= maxLatitude &&
        point.longitude >= minLongitude &&
        point.longitude <= maxLongitude;
  }
}

final class SaferPlace {
  const SaferPlace({
    required this.id,
    required this.label,
    required this.location,
    this.type,
    this.status,
  });

  final String id;
  final String label;
  final GeoPoint location;
  final String? type;
  final String? status;
}

final class HazardArea {
  const HazardArea({
    required this.id,
    required this.label,
    required this.ring,
  });

  final String id;
  final String label;
  final List<GeoPoint> ring;
}

final class GeographicCatalog {
  const GeographicCatalog({
    required this.id,
    required this.label,
    required this.bounds,
    required this.maxGuidanceMeters,
    required this.sourceNote,
    required this.status,
    required this.hazardAreas,
    required this.saferPlaces,
  });

  final String id;
  final String label;
  final GeoBounds bounds;
  final double maxGuidanceMeters;
  final String sourceNote;
  final String status;
  final List<HazardArea> hazardAreas;
  final List<SaferPlace> saferPlaces;

  bool get isDemonstration => status != 'official';

  GeoPoint get demonstrationCenter => GeoPoint(
    latitude: (bounds.minLatitude + bounds.maxLatitude) / 2,
    longitude: (bounds.minLongitude + bounds.maxLongitude) / 2,
  );
}

final class RegionCatalogSet {
  const RegionCatalogSet(this.catalogs);

  final List<GeographicCatalog> catalogs;

  GeographicCatalog? byId(String id) {
    for (final catalog in catalogs) {
      if (catalog.id == id) {
        return catalog;
      }
    }
    return null;
  }

  GeographicCatalog? containing(GeoPoint point) {
    for (final catalog in catalogs) {
      if (catalog.bounds.contains(point)) {
        return catalog;
      }
    }
    return null;
  }
}

abstract final class SaferLocationReason {
  static const outsideHazard = 'outside_hazard';
  static const openSpace = 'open_space';
  static const nearestInRegion = 'nearest_in_region';
  static const underGuidanceLimit = 'under_guidance_limit';
}

final class SaferLocationGuidance {
  const SaferLocationGuidance({
    required this.current,
    required this.place,
    required this.distanceMeters,
    required this.bearingDegrees,
    required this.insideHazard,
    required this.hazardLabel,
    required this.sourceNote,
    required this.isDemonstrationDataset,
    required this.catalogId,
    this.recommendationReasons = const [],
  });

  final DeviceLocation current;
  final SaferPlace place;
  final double distanceMeters;
  final double bearingDegrees;
  final bool insideHazard;
  final String? hazardLabel;
  final String sourceNote;
  final bool isDemonstrationDataset;
  final String catalogId;
  final List<String> recommendationReasons;

  String get compassLabel {
    const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((bearingDegrees + 22.5) % 360 / 45).floor();
    return labels[index];
  }
}
