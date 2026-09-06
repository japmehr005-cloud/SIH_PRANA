import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';

Future<AarogyaDependencies> createPlatformDependencies({
  PhysioContextModel? contextModel,
}) async {
  return createInMemoryDependencies(contextModel: contextModel);
}
