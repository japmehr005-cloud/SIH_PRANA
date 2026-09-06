import 'dart:convert';

import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/identity/user_profile.dart';
import 'package:aarogya/domain/location/location_preference.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/features/persistence/data/record_codecs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocalRecordStore {
  LocalRecordStore({required this._preferences, this._scope = 'local'});

  final SharedPreferences _preferences;
  String _scope;

  String get scope => _scope;

  Future<void> setScope(String scope) async {
    _scope = scope;
  }

  Future<UserProfile?> profile() async {
    final raw = _preferences.getString(_key('profile'));
    if (raw == null) {
      return null;
    }
    return decodeProfile(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) {
    return _preferences.setString(
      _key('profile'),
      jsonEncode(encodeProfile(profile)),
    );
  }

  Future<List<SensorSample>> observations() async {
    final raw = _preferences.getString(_key('observations'));
    if (raw == null) {
      return const [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list)
        decodeSample(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<void> saveObservations(List<SensorSample> samples) {
    final trimmed = samples.length <= 120
        ? samples
        : samples.sublist(samples.length - 120);
    return _preferences.setString(
      _key('observations'),
      jsonEncode([for (final sample in trimmed) encodeSample(sample)]),
    );
  }

  Future<PersonalBaseline?> baseline() async {
    final raw = _preferences.getString(_key('baseline'));
    if (raw == null) {
      return null;
    }
    return decodeBaseline(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveBaseline(PersonalBaseline? baseline) async {
    if (baseline == null) {
      await _preferences.remove(_key('baseline'));
      return;
    }
    await _preferences.setString(
      _key('baseline'),
      jsonEncode(encodeBaseline(baseline)),
    );
  }

  Future<EmergencySnapshot?> snapshot() async {
    final raw = _preferences.getString(_key('snapshot'));
    if (raw == null) {
      return null;
    }
    return decodeSnapshot(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveSnapshot(EmergencySnapshot? snapshot) async {
    if (snapshot == null) {
      await _preferences.remove(_key('snapshot'));
      return;
    }
    await _preferences.setString(
      _key('snapshot'),
      jsonEncode(encodeSnapshot(snapshot)),
    );
  }

  Future<List<EmergencyPacket>> packets() async {
    final raw = _preferences.getString(_key('packets'));
    if (raw == null) {
      return const [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list)
        decodePacket(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<void> savePackets(List<EmergencyPacket> packets) {
    return _preferences.setString(
      _key('packets'),
      jsonEncode([for (final packet in packets) encodePacket(packet)]),
    );
  }

  Future<void> markOutboxPending() {
    return _preferences.setBool(_key('outbox'), true);
  }

  Future<void> clearOutbox() {
    return _preferences.remove(_key('outbox'));
  }

  bool get outboxPending => _preferences.getBool(_key('outbox')) ?? false;

  Future<RiskAssessment?> assessment() async {
    final raw = _preferences.getString(_key('assessment'));
    if (raw == null) {
      return null;
    }
    return decodeAssessment(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveAssessment(RiskAssessment? assessment) async {
    if (assessment == null) {
      await _preferences.remove(_key('assessment'));
      return;
    }
    await _preferences.setString(
      _key('assessment'),
      jsonEncode(encodeAssessment(assessment)),
    );
  }

  Future<LocationPreference?> locationPreference() async {
    final raw = _preferences.getString(_key('locationPreference'));
    if (raw == null) {
      return null;
    }
    return LocationPreference.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<void> saveLocationPreference(LocationPreference preference) {
    return _preferences.setString(
      _key('locationPreference'),
      jsonEncode(preference.toJson()),
    );
  }

  Future<String?> demonstrationCondition() async {
    return _preferences.getString(_key('demonstrationCondition'));
  }

  Future<void> saveDemonstrationCondition(String? id) async {
    if (id == null) {
      await _preferences.remove(_key('demonstrationCondition'));
      return;
    }
    await _preferences.setString(_key('demonstrationCondition'), id);
  }

  Future<void> clearScopedRecords() async {
    await _preferences.remove(_key('profile'));
    await _preferences.remove(_key('observations'));
    await _preferences.remove(_key('baseline'));
    await _preferences.remove(_key('snapshot'));
    await _preferences.remove(_key('packets'));
    await _preferences.remove(_key('outbox'));
    await _preferences.remove(_key('assessment'));
    await _preferences.remove(_key('demonstrationCondition'));
  }

  String _key(String name) => 'aarogya.$_scope.$name';
}
