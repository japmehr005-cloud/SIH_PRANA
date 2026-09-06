import 'dart:convert';
import 'dart:math' as math;

import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:flutter/services.dart';

final class GeographicMath {
  const GeographicMath();

  static const _earthRadiusMeters = 6371000.0;

  double haversineMeters(GeoPoint from, GeoPoint to) {
    final lat1 = _rad(from.latitude);
    final lat2 = _rad(to.latitude);
    final dLat = _rad(to.latitude - from.latitude);
    final dLon = _rad(to.longitude - from.longitude);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    return 2 * _earthRadiusMeters * math.asin(math.sqrt(a));
  }

  double initialBearingDegrees(GeoPoint from, GeoPoint to) {
    final lat1 = _rad(from.latitude);
    final lat2 = _rad(to.latitude);
    final dLon = _rad(to.longitude - from.longitude);
    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    return (_deg(math.atan2(y, x)) + 360) % 360;
  }

  bool contains(HazardArea area, GeoPoint point) {
    var inside = false;
    final ring = area.ring;
    for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final xi = ring[i].longitude;
      final yi = ring[i].latitude;
      final xj = ring[j].longitude;
      final yj = ring[j].latitude;
      final intersect =
          ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude <
              (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);
      if (intersect) {
        inside = !inside;
      }
    }
    return inside;
  }

  double _rad(double degrees) => degrees * math.pi / 180;
  double _deg(double radians) => radians * 180 / math.pi;
}

final class SaferLocationEngine {
  SaferLocationEngine({
    GeographicCatalog? catalog,
    RegionCatalogSet? regions,
    this.math = const GeographicMath(),
  }) : regions = regions ??
            RegionCatalogSet(catalog == null ? const [] : [catalog]);

  final RegionCatalogSet regions;
  final GeographicMath math;

  GeographicCatalog? get catalog =>
      regions.catalogs.isEmpty ? null : regions.catalogs.first;

  SaferLocationGuidance? guide(
    DeviceLocation current, {
    String? selectedRegionId,
    String? selectedPlaceId,
  }) {
    final here = GeoPoint(
      latitude: current.latitude,
      longitude: current.longitude,
    );
    if (here.latitude.isNaN || here.longitude.isNaN) {
      return null;
    }

    GeographicCatalog? resolved;
    if (selectedRegionId != null) {
      resolved = regions.byId(selectedRegionId);
      if (resolved != null && !resolved.bounds.contains(here)) {
        return null;
      }
    }
    resolved ??= regions.containing(here);
    if (resolved == null || resolved.saferPlaces.isEmpty) {
      return null;
    }
    final catalog = resolved;

    final candidates = <(SaferPlace, double)>[];
    for (final place in catalog.saferPlaces) {
      final distance = math.haversineMeters(here, place.location);
      if (!_usableDistance(distance, catalog.maxGuidanceMeters)) {
        continue;
      }
      if (!catalog.bounds.contains(place.location)) {
        continue;
      }
      candidates.add((place, distance));
    }
    if (candidates.isEmpty) {
      return null;
    }

    var chosen = candidates.first;
    if (selectedPlaceId != null) {
      for (final candidate in candidates) {
        if (candidate.$1.id == selectedPlaceId) {
          chosen = candidate;
          break;
        }
      }
    } else {
      candidates.sort((a, b) => _compareCandidates(catalog, a, b));
      chosen = candidates.first;
    }

    if (!_usableDistance(chosen.$2, catalog.maxGuidanceMeters)) {
      return null;
    }

    HazardArea? hazard;
    for (final area in catalog.hazardAreas) {
      if (math.contains(area, here)) {
        hazard = area;
        break;
      }
    }

    return SaferLocationGuidance(
      current: current,
      place: chosen.$1,
      distanceMeters: chosen.$2,
      bearingDegrees: math.initialBearingDegrees(here, chosen.$1.location),
      insideHazard: hazard != null,
      hazardLabel: hazard?.label,
      sourceNote: catalog.sourceNote,
      isDemonstrationDataset: catalog.isDemonstration,
      catalogId: catalog.id,
      recommendationReasons: _reasons(catalog, chosen, candidates),
    );
  }

  int _compareCandidates(
    GeographicCatalog catalog,
    (SaferPlace, double) a,
    (SaferPlace, double) b,
  ) {
    final aOutside = !_placeInsideResolvedHazard(catalog, a.$1);
    final bOutside = !_placeInsideResolvedHazard(catalog, b.$1);
    if (aOutside != bOutside) {
      return aOutside ? -1 : 1;
    }
    final aOpen = a.$1.type == 'open_space';
    final bOpen = b.$1.type == 'open_space';
    if (aOpen != bOpen) {
      return aOpen ? -1 : 1;
    }
    return a.$2.compareTo(b.$2);
  }

  bool _placeInsideResolvedHazard(GeographicCatalog catalog, SaferPlace place) {
    for (final area in catalog.hazardAreas) {
      if (math.contains(area, place.location)) {
        return true;
      }
    }
    return false;
  }

  List<String> _reasons(
    GeographicCatalog catalog,
    (SaferPlace, double) chosen,
    List<(SaferPlace, double)> candidates,
  ) {
    final reasons = <String>[];
    if (!_placeInsideResolvedHazard(catalog, chosen.$1)) {
      reasons.add(SaferLocationReason.outsideHazard);
    }
    if (chosen.$1.type == 'open_space') {
      reasons.add(SaferLocationReason.openSpace);
    }
    var nearest = candidates.first;
    for (final candidate in candidates) {
      if (candidate.$2 < nearest.$2) {
        nearest = candidate;
      }
    }
    if (chosen.$1.id == nearest.$1.id) {
      reasons.add(SaferLocationReason.nearestInRegion);
    }
    if (chosen.$2 <= catalog.maxGuidanceMeters) {
      reasons.add(SaferLocationReason.underGuidanceLimit);
    }
    return List.unmodifiable(reasons);
  }

  bool _usableDistance(double distance, double maxMeters) {
    return distance.isFinite && !distance.isNaN && distance <= maxMeters;
  }
}

Future<GeographicCatalog> loadKathmanduCatalog({
  AssetBundle? bundle,
}) async {
  final raw = await (bundle ?? rootBundle).loadString(
    'assets/geo/kathmandu_demo.geojson',
  );
  return parseGeographicCatalog(raw);
}

Future<GeographicCatalog> loadDelhiCatalog({
  AssetBundle? bundle,
}) async {
  final raw = await (bundle ?? rootBundle).loadString(
    'assets/geo/delhi_demo.geojson',
  );
  return parseGeographicCatalog(raw);
}

Future<RegionCatalogSet> loadDemonstrationRegions({
  AssetBundle? bundle,
}) async {
  return RegionCatalogSet([
    await loadKathmanduCatalog(bundle: bundle),
    await loadDelhiCatalog(bundle: bundle),
  ]);
}

GeographicCatalog parseGeographicCatalog(String raw) {
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final metadata = json['metadata'] as Map<String, dynamic>? ?? const {};
  final features = json['features'] as List<dynamic>? ?? const [];
  final hazards = <HazardArea>[];
  final places = <SaferPlace>[];
  for (final feature in features) {
    final map = Map<String, dynamic>.from(feature as Map);
    final properties = Map<String, dynamic>.from(
      map['properties'] as Map? ?? const {},
    );
    final geometry = Map<String, dynamic>.from(map['geometry'] as Map);
    final kind = properties['kind'] as String? ?? '';
    final name = properties['name'] as String? ?? 'Unnamed';
    final id = properties['id'] as String? ?? name;
    if (kind == 'hazard' && geometry['type'] == 'Polygon') {
      final rings = geometry['coordinates'] as List<dynamic>;
      final outer = rings.first as List<dynamic>;
      hazards.add(
        HazardArea(
          id: id,
          label: name,
          ring: [
            for (final pair in outer)
              GeoPoint(
                latitude: (pair[1] as num).toDouble(),
                longitude: (pair[0] as num).toDouble(),
              ),
          ],
        ),
      );
    }
    if (kind == 'safer' && geometry['type'] == 'Point') {
      final pair = geometry['coordinates'] as List<dynamic>;
      places.add(
        SaferPlace(
          id: id,
          label: name,
          location: GeoPoint(
            latitude: (pair[1] as num).toDouble(),
            longitude: (pair[0] as num).toDouble(),
          ),
          type: properties['type'] as String?,
          status: properties['status'] as String?,
        ),
      );
    }
  }

  final bbox = metadata['bbox'] as Map<String, dynamic>?;
  final bounds = bbox == null
      ? _boundsFromFeatures(hazards, places)
      : GeoBounds(
          minLatitude: (bbox['minLatitude'] as num).toDouble(),
          maxLatitude: (bbox['maxLatitude'] as num).toDouble(),
          minLongitude: (bbox['minLongitude'] as num).toDouble(),
          maxLongitude: (bbox['maxLongitude'] as num).toDouble(),
        );

  return GeographicCatalog(
    id: metadata['id'] as String? ?? 'local',
    label: metadata['label'] as String? ?? 'Demonstration area',
    bounds: bounds,
    maxGuidanceMeters: (metadata['maxGuidanceMeters'] as num?)?.toDouble() ??
        15000,
    sourceNote:
        metadata['source'] as String? ??
        'Demonstration geographic dataset. Not a live official flood feed.',
    status: metadata['status'] as String? ?? 'demonstration',
    hazardAreas: hazards,
    saferPlaces: places,
  );
}

GeoBounds _boundsFromFeatures(
  List<HazardArea> hazards,
  List<SaferPlace> places,
) {
  final points = <GeoPoint>[
    for (final place in places) place.location,
    for (final area in hazards) ...area.ring,
  ];
  if (points.isEmpty) {
    return const GeoBounds(
      minLatitude: 0,
      maxLatitude: 0,
      minLongitude: 0,
      maxLongitude: 0,
    );
  }
  var minLat = points.first.latitude;
  var maxLat = points.first.latitude;
  var minLon = points.first.longitude;
  var maxLon = points.first.longitude;
  for (final point in points) {
    minLat = math.min(minLat, point.latitude);
    maxLat = math.max(maxLat, point.latitude);
    minLon = math.min(minLon, point.longitude);
    maxLon = math.max(maxLon, point.longitude);
  }
  const pad = 0.05;
  return GeoBounds(
    minLatitude: minLat - pad,
    maxLatitude: maxLat + pad,
    minLongitude: minLon - pad,
    maxLongitude: maxLon + pad,
  );
}
