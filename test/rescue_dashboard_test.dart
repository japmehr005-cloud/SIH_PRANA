import 'package:aarogya/app/aarogya_app.dart';
import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/sample_factory.dart';

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  EditableText.debugDeterministicCursor = true;

  testWidgets('rescue shows empty state then the stored emergency packet', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final clock = ControllableClock();
    final deps = createInMemoryDependencies(
      clock: clock,
      ids: SequentialIdGenerator(),
    );
    await deps.runtime.start();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dependenciesProvider.overrideWithValue(deps)],
        child: const AarogyaApp(),
      ),
    );
    await _pumpFrames(tester);

    final en = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(en.rescue));
    await _pumpFrames(tester);
    expect(find.text(en.rescueEmptyHint), findsOneWidget);

    final runtime = deps.runtime;
    for (final item in restingSeries(start: clock.now())) {
      await runtime.ingest(item);
    }
    await runtime.activateOfficialFlood();
    await runtime.confirmDisaster();
    await runtime.enterSurvival();
    final start = clock.now();
    await runtime.ingest(
      sample(
        at: start,
        hr: 80,
        spo2: 97,
        accel: 1.4,
        movement: MovementState.low,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 200)),
        hr: 84,
        spo2: 97,
        accel: 28.4,
        movement: MovementState.irregular,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 400)),
        hr: 86,
        spo2: 96,
        accel: 6.2,
        orientation: 0.9,
        movement: MovementState.none,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 600)),
        hr: 86,
        spo2: 96,
        accel: 1.0,
        movement: MovementState.none,
      ),
    );
    await runtime.ingest(
      sample(
        at: start.add(const Duration(milliseconds: 800)),
        hr: 86,
        spo2: 96,
        accel: 0.9,
        movement: MovementState.none,
      ),
    );
    expect(runtime.state.fallStatus, FallStatus.awaitingConfirmation);
    await runtime.setConnectivity(ConnectivityStatus.offline);
    clock.advance(const Duration(seconds: 21));
    await runtime.escalateUnconfirmedFall();
    await _pumpFrames(tester);

    expect(find.text(en.packetPendingDelivery), findsWidgets);
    expect(find.text(en.eventTypePossibleFall), findsOneWidget);
    expect(find.text('physiological_deterioration'), findsNothing);
    expect(find.text('possible_fall'), findsNothing);
    expect(find.text('evt-1'), findsNothing);
    expect(find.text(en.eventId), findsNothing);
    final technical = find.text(en.technicalInformation);
    await tester.ensureVisible(technical);
    await _pumpFrames(tester);
    await tester.tap(technical);
    await _pumpFrames(tester);
    expect(find.text(en.eventId), findsOneWidget);
    expect(find.text('evt-1'), findsOneWidget);
    expect(find.text(en.deliveryConfirmed), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
