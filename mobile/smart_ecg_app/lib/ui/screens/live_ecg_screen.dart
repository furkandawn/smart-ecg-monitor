import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../../features/ble/ble_controller.dart';
import '../../features/ble/ble_state.dart';
import '../../features/ecg/ecg_processor.dart';
import '../../features/integration/ecg_stream_controller.dart';

// Import new widgets
import '../widgets/live_ecg_chart.dart';
import '../widgets/live_ecg_status_bar.dart';
import '../widgets/live_ecg_controls.dart';

class LiveEcgScreen extends ConsumerStatefulWidget {
  const LiveEcgScreen({super.key});

  @override
  ConsumerState<LiveEcgScreen> createState() => _LiveEcgScreenState();
}

class _LiveEcgScreenState extends ConsumerState<LiveEcgScreen> {
  double _gain = 1.0;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context, ref);
    final ecgState = ref.watch(ecgProcessorProvider);
    final bleState = ref.watch(bleControllerProvider);
    final streamController = ref.read(ecgStreamControllerProvider);

    // Determine if streaming is possible
    final bool canStream = bleState.hasValue &&
        (bleState.value is BleConnected || bleState.value is BleStreaming);

    // Extract BPM safely
    final int? bpm = bleState.hasValue ? bleState.value!.bpm : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.tr('live_ecg')),
      ),
      body: Column(
        children: [
          // 1. ECG Chart Area
          Expanded(
            child: LiveEcgChart(
              samples: ecgState.samples,
              gain: _gain,
            ),
          ),

          // 2. Status Bar (BPM & Status Text)
          LiveEcgStatusBar(
            bpm: bpm,
            isLive: ecgState.liveEnabled,
          ),

          // 3. Control Panel (Gain & Toggle)
          LiveEcgControls(
            gain: _gain,
            isLive: ecgState.liveEnabled,
            canStream: canStream,
            onGainChanged: (newGain) => setState(() => _gain = newGain),
            onToggleStream: (shouldStream) async {
              if (shouldStream) {
                await streamController.start();
              } else {
                await streamController.stop();
              }
            },
          ),
        ],
      ),
    );
  }
}