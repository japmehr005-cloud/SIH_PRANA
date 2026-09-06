enum LocationLock { demonstration, gps }

final class LocationPreference {
  const LocationPreference({
    this.regionId = DemonstrationRegionIds.kathmandu,
    this.lock = LocationLock.demonstration,
    this.selectedPlaceId,
  });

  final String regionId;
  final LocationLock lock;
  final String? selectedPlaceId;

  LocationPreference copyWith({
    String? regionId,
    LocationLock? lock,
    String? selectedPlaceId,
    bool clearPlace = false,
  }) {
    return LocationPreference(
      regionId: regionId ?? this.regionId,
      lock: lock ?? this.lock,
      selectedPlaceId: clearPlace ? null : selectedPlaceId ?? this.selectedPlaceId,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'regionId': regionId,
      'lock': lock.name,
      'selectedPlaceId': selectedPlaceId,
    };
  }

  factory LocationPreference.fromJson(Map<String, dynamic> json) {
    final lockName = json['lock'] as String? ?? LocationLock.demonstration.name;
    return LocationPreference(
      regionId: json['regionId'] as String? ?? DemonstrationRegionIds.kathmandu,
      lock: LocationLock.values.firstWhere(
        (value) => value.name == lockName,
        orElse: () => LocationLock.demonstration,
      ),
      selectedPlaceId: json['selectedPlaceId'] as String?,
    );
  }
}

abstract final class DemonstrationRegionIds {
  static const kathmandu = 'kathmandu';
  static const delhi = 'delhi';
}

abstract final class DemonstrationRegionCenters {
  static const kathmanduLatitude = 27.717;
  static const kathmanduLongitude = 85.324;
  static const delhiLatitude = 28.6139;
  static const delhiLongitude = 77.2090;
}
