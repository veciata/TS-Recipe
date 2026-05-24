import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sync_service.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSync;
  final bool localToServer;
  final bool serverToLocal;

  const SyncState({
    required this.status,
    this.lastSync,
    this.localToServer = false,
    this.serverToLocal = false,
  });

  factory SyncState.idle() => const SyncState(status: SyncStatus.idle);

  factory SyncState.syncing() => const SyncState(status: SyncStatus.syncing);

  factory SyncState.success({
    required DateTime lastSync,
    required bool localToServer,
    required bool serverToLocal,
  }) =>
      SyncState(
        status: SyncStatus.success,
        lastSync: lastSync,
        localToServer: localToServer,
        serverToLocal: serverToLocal,
      );

  factory SyncState.error() => const SyncState(status: SyncStatus.error);
}

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncService _syncService;

  SyncNotifier(this._syncService) : super(SyncState.idle());

  Future<void> initiateSync() async {
    if (state.status == SyncStatus.syncing) return;

    state = SyncState.syncing();
    try {
      final result = await _syncService.fullSync();
      final now = DateTime.now();
      state = SyncState.success(
        lastSync: now,
        localToServer: result['localToServer'] ?? false,
        serverToLocal: result['serverToLocal'] ?? false,
      );
    } catch (_) {
      state = SyncState.error();
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

final syncStateProvider =
    StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return SyncNotifier(syncService);
});
