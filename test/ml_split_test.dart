import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Non-EEG subject splits are disjoint', () {
    final raw = File('data/splits/noneeg_subjects.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final train = Set<int>.from(json['train'] as List);
    final val = Set<int>.from(json['val'] as List);
    final testIds = Set<int>.from(json['test'] as List);
    expect(train.intersection(val), isEmpty);
    expect(train.intersection(testIds), isEmpty);
    expect(val.intersection(testIds), isEmpty);
    expect(train.length + val.length + testIds.length, 20);
  });
}
