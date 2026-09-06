import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fall-window metadata records measured subject-split scores', () {
    final meta =
        jsonDecode(
              File('assets/models/fall_window.meta.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    expect(meta['version'], 'fall-window-v1');
    expect(meta['dataset'], 'sisfall');
    expect(meta['split'], contains('GroupKFold'));
    expect(meta['n_subjects'], greaterThanOrEqualTo(4));
    expect(meta['sensitivity'], isA<num>());
    expect(meta['specificity'], isA<num>());
    expect(meta['f1'], isA<num>());
    expect((meta['f1'] as num) > 0, isTrue);
    expect((meta['f1'] as num) < 1, isTrue);
  });
}
