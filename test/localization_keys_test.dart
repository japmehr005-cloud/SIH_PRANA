import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every English user-facing key has a Hindi translation', () {
    final english = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final hindi = jsonDecode(
      File('lib/l10n/app_hi.arb').readAsStringSync(),
    ) as Map<String, dynamic>;

    final englishKeys = english.keys
        .where((key) => !key.startsWith('@'))
        .toSet();
    final hindiKeys = hindi.keys.where((key) => !key.startsWith('@')).toSet();

    expect(hindiKeys, englishKeys);
    for (final key in englishKeys) {
      expect(hindi[key], isA<String>());
      expect((hindi[key] as String).trim(), isNotEmpty);
    }
  });
}
