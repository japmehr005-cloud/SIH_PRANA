import 'dart:io';

import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String csv(DemonstrationCondition condition) {
    return File(condition.assetPath).readAsStringSync();
  }

  test('each demonstration condition changes readings through the pipeline', () async {
    SharedPreferences.setMockInitialValues({});
    final store = LocalRecordStore(
      preferences: await SharedPreferences.getInstance(),
      scope: 'demo-user',
    );
    final deps = createInMemoryDependencies();
    deps.runtime.records = store;
    await deps.runtime.start();

    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.resting,
      csv: csv(DemonstrationCondition.resting),
    );
    expect(deps.runtime.state.baseline?.isEstablished, isTrue);
    expect(
      deps.runtime.state.demonstrationCondition,
      DemonstrationCondition.resting,
    );
    final restingHr = deps.runtime.state.currentSample?.heartRateBpm;
    final restingMovement = deps.runtime.state.currentSample?.movement;
    expect(restingHr, isNotNull);

    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.physicalActivity,
      csv: csv(DemonstrationCondition.physicalActivity),
    );
    expect(
      deps.runtime.state.demonstrationCondition,
      DemonstrationCondition.physicalActivity,
    );
    expect(deps.runtime.state.currentSample?.heartRateBpm, isNot(restingHr));
    expect(
      deps.runtime.state.currentSample?.movement,
      isNot(restingMovement),
    );
    expect(deps.runtime.state.latestPacket, isNull);

    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.highLoad,
      csv: csv(DemonstrationCondition.highLoad),
    );
    expect(
      deps.runtime.state.demonstrationCondition,
      DemonstrationCondition.highLoad,
    );
    expect(deps.runtime.state.risk, isNotNull);
    expect(deps.runtime.state.latestPacket, isNull);

    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.fallImpact,
      csv: csv(DemonstrationCondition.fallImpact),
    );
    expect(
      deps.runtime.state.demonstrationCondition,
      DemonstrationCondition.fallImpact,
    );
    expect(deps.runtime.state.fallStatus, FallStatus.awaitingConfirmation);
    expect(deps.runtime.state.latestPacket, isNull);
    expect(await store.demonstrationCondition(), 'fallImpact');
  });

  test('fall condition does not create a packet until the user asks for help', () async {
    final deps = createInMemoryDependencies();
    await deps.runtime.start();
    await deps.runtime.applyDemonstrationCondition(
      DemonstrationCondition.fallImpact,
      csv: csv(DemonstrationCondition.fallImpact),
      restingCsv: csv(DemonstrationCondition.resting),
    );
    expect(deps.runtime.state.baseline?.isEstablished, isTrue);
    expect(deps.runtime.state.fallStatus, FallStatus.awaitingConfirmation);
    expect(deps.runtime.state.latestPacket, isNull);

    await deps.runtime.userNeedsHelp();
    expect(deps.runtime.state.latestPacket, isNotNull);
    expect(deps.runtime.state.latestPacket!.eventType, 'possible_fall');
  });
}
