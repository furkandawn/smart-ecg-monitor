import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ble/ble_controller.dart';
import '../ecg/ecg_event_model.dart';
import '../ecg/ecg_event_repository.dart';
import '../ecg/ecg_snapshot_decoder.dart';
import '../emergency/emergency_countdown_controller.dart';

final emergencyBleListenerProvider = Provider<void>((ref) {
  final ble = ref.read(bleControllerProvider.notifier);
  final repo = ref.read(ecgEventRepositoryProvider);
  final countdown = ref.read(emergencyCountdownProvider.notifier);

  final StreamSubscription sub =
      ble.emergencyPackets.listen((pkt) async {
    final samples = decodeEcgSnapshot(pkt.snapshot);

    await repo.insertEvent(
      EcgEventModel(
        timestamp: DateTime.now(),
        type: EcgEventType.emergency,
        bpm: pkt.bpm,
        snapshot: samples,
      ),
    );

    countdown.start(10);
  });

  ref.onDispose(sub.cancel);
});
