/// Optional remote sync. Local demo does not require an implementation.
abstract interface class SyncRepository {
  Future<void> pushAll();
  Future<void> pullIntoMemory();
}
