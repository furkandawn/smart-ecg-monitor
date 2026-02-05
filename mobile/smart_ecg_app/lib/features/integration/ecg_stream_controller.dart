import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ble/ble_controller.dart';
import '../ecg/ecg_processor.dart';

final ecgStreamControllerProvider = Provider<EcgStreamController>((ref) {
  return EcgStreamController(ref);
});

class EcgStreamController {
  final Ref ref;
  StreamSubscription<int>? _streamSub;

  EcgStreamController(this.ref);

  Future<void> start() async {
    final ble = ref.read(bleControllerProvider.notifier);
    final ecg = ref.read(ecgProcessorProvider.notifier);

    ecg.setLiveEnabled(true);

    await _streamSub?.cancel();

    _streamSub = ble.ecgSamples.listen((sample) {
      ecg.addDataPoint(sample);
    });

    await ble.startEcgStream();
  }

  Future<void> stop() async {
    final ble = ref.read(bleControllerProvider.notifier);
    final ecg = ref.read(ecgProcessorProvider.notifier);

    ecg.setLiveEnabled(false);

    await _streamSub?.cancel();
    _streamSub = null;

    await ble.stopEcgStream();
  }
}