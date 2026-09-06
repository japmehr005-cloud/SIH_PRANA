import 'dart:io';

import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/features/location/domain/safer_location_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final kathmandu = parseGeographicCatalog(
    File('assets/geo/kathmandu_demo.geojson').readAsStringSync(),
  );
  final delhi = parseGeographicCatalog(
    File('assets/geo/delhi_demo.geojson').readAsStringSync(),
  );
  const math = GeographicMath();
  final kathmanduEngine = SaferLocationEngine(catalog: kathmandu, math: math);
  final regions = RegionCatalogSet([kathmandu, delhi]);
  final regionalEngine = SaferLocationEngine(regions: regions, math: math);
  final now = DateTime.utc(2026, 9, 6, 14);

  test('kathmandu demo catalog is a demonstration dataset', () {
    expect(kathmandu.isDemonstration, isTrue);
    expect(kathmandu.id, 'kathmandu');
    expect(kathmandu.saferPlaces, isNotEmpty);
    expect(kathmandu.hazardAreas, isNotEmpty);
    expect(kathmandu.sourceNote.toLowerCase(), contains('demonstration'));
    expect(kathmandu.maxGuidanceMeters, 15000);
  });

  test('demo coordinates sit inside the hazard and pick a safer place', () {
    final here = DeviceLocation(
      latitude: 27.717,
      longitude: 85.324,
      capturedAt: now,
      source: LocationSource.demonstration,
    );
    final point = GeoPoint(latitude: here.latitude, longitude: here.longitude);
    expect(math.contains(kathmandu.hazardAreas.first, point), isTrue);
    final guidance = kathmanduEngine.guide(here);
    expect(guidance, isNotNull);
    expect(guidance!.insideHazard, isTrue);
    expect(guidance.isDemonstrationDataset, isTrue);
    expect(guidance.distanceMeters, greaterThan(0));
    expect(guidance.distanceMeters, lessThan(15000));
    expect(guidance.bearingDegrees, inInclusiveRange(0, 360));
    expect(guidance.place.label, isNotEmpty);
    expect(guidance.catalogId, 'kathmandu');
  });

  test('haversine is symmetric and bearing follows a known pair', () {
    const from = GeoPoint(latitude: 27.717, longitude: 85.324);
    const to = GeoPoint(latitude: 27.7215, longitude: 85.344);
    final there = math.haversineMeters(from, to);
    final back = math.haversineMeters(to, from);
    expect((there - back).abs(), lessThan(0.01));
    expect(there, greaterThan(1000));
    final bearing = math.initialBearingDegrees(from, to);
    expect(bearing, greaterThan(0));
    expect(bearing, lessThan(90));
  });

  test('Delhi GPS with Kathmandu-only catalog does not pick Tudikhel', () {
    final delhiGps = DeviceLocation(
      latitude: 28.6,
      longitude: 77.2,
      capturedAt: now,
      source: LocationSource.gps,
    );
    final guidance = kathmanduEngine.guide(delhiGps);
    expect(guidance, isNull);
    final distance = math.haversineMeters(
      const GeoPoint(latitude: 28.6, longitude: 77.2),
      kathmandu.saferPlaces.first.location,
    );
    expect(distance, greaterThan(700000));
  });

  test('Delhi GPS with regional catalogs stays inside Delhi', () {
    final delhiGps = DeviceLocation(
      latitude: 28.6139,
      longitude: 77.2090,
      capturedAt: now,
      source: LocationSource.gps,
    );
    final guidance = regionalEngine.guide(delhiGps);
    expect(guidance, isNotNull);
    expect(guidance!.catalogId, 'delhi');
    expect(guidance.place.id, isNot('tudikhel'));
    expect(guidance.distanceMeters, lessThan(15000));
  });

  test('guidance is null when every candidate exceeds max distance', () {
    final isolated = GeographicCatalog(
      id: 'isolated',
      label: 'Isolated',
      bounds: const GeoBounds(
        minLatitude: 27.6,
        maxLatitude: 27.8,
        minLongitude: 85.2,
        maxLongitude: 85.4,
      ),
      maxGuidanceMeters: 50,
      sourceNote: 'Demonstration',
      status: 'demonstration',
      hazardAreas: const [],
      saferPlaces: const [
        SaferPlace(
          id: 'far-park',
          label: 'Far park',
          location: GeoPoint(latitude: 27.7015, longitude: 85.3160),
        ),
      ],
    );
    final engine = SaferLocationEngine(catalog: isolated, math: math);
    final guidance = engine.guide(
      DeviceLocation(
        latitude: 27.717,
        longitude: 85.324,
        capturedAt: now,
        source: LocationSource.demonstration,
      ),
    );
    expect(guidance, isNull);
  });

  test('flood ranking prefers an open space outside the hazard', () {
    final catalog = GeographicCatalog(
      id: 'flood-rank',
      label: 'Flood rank',
      bounds: const GeoBounds(
        minLatitude: 27.6,
        maxLatitude: 27.8,
        minLongitude: 85.2,
        maxLongitude: 85.4,
      ),
      maxGuidanceMeters: 15000,
      sourceNote: 'Demonstration',
      status: 'demonstration',
      hazardAreas: const [
        HazardArea(
          id: 'flood',
          label: 'Flood',
          ring: [
            GeoPoint(latitude: 27.714, longitude: 85.320),
            GeoPoint(latitude: 27.714, longitude: 85.333),
            GeoPoint(latitude: 27.725, longitude: 85.333),
            GeoPoint(latitude: 27.725, longitude: 85.320),
            GeoPoint(latitude: 27.714, longitude: 85.320),
          ],
        ),
      ],
      saferPlaces: const [
        SaferPlace(
          id: 'inside-park',
          label: 'Inside park',
          location: GeoPoint(latitude: 27.718, longitude: 85.325),
          type: 'open_space',
        ),
        SaferPlace(
          id: 'outside-park',
          label: 'Outside park',
          location: GeoPoint(latitude: 27.7015, longitude: 85.3160),
          type: 'open_space',
        ),
      ],
    );
    final engine = SaferLocationEngine(catalog: catalog, math: math);
    final guidance = engine.guide(
      DeviceLocation(
        latitude: 27.717,
        longitude: 85.324,
        capturedAt: now,
        source: LocationSource.demonstration,
      ),
    );
    expect(guidance, isNotNull);
    expect(guidance!.place.id, 'outside-park');
    expect(
      guidance.recommendationReasons,
      contains(SaferLocationReason.outsideHazard),
    );
    expect(
      guidance.recommendationReasons,
      contains(SaferLocationReason.openSpace),
    );
    expect(guidance.place.id, isNot('inside-park'));
  });

  test('selected place is used when it stays inside the region limit', () {
    final here = DeviceLocation(
      latitude: 27.717,
      longitude: 85.324,
      capturedAt: now,
      source: LocationSource.demonstration,
    );
    final nearest = kathmanduEngine.guide(here);
    final chosen = kathmanduEngine.guide(
      here,
      selectedPlaceId: 'shankha-park',
    );
    expect(chosen, isNotNull);
    expect(chosen!.place.id, 'shankha-park');
    expect(chosen.distanceMeters, lessThanOrEqualTo(15000));
    expect(chosen.place.id, isNot(nearest!.place.id));
  });
}
