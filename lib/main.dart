import 'package:aarogya/app/aarogya_app.dart';
import 'package:aarogya/app/platform_dependencies.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PhysioContextModel? contextModel;
  try {
    contextModel = await PhysioContextModel.loadFromAssets();
  } catch (_) {
    contextModel = null;
  }
  final dependencies = await createPlatformDependencies(
    contextModel: contextModel,
  );
  await dependencies.runtime.start();
  if (dependencies.coordinator != null) {
    await dependencies.coordinator!.bind(dependencies.accounts.current);
  }
  runApp(
    ProviderScope(
      overrides: [dependenciesProvider.overrideWithValue(dependencies)],
      child: const AarogyaApp(),
    ),
  );
}
