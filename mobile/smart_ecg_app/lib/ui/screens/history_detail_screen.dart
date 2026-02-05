import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../../features/ecg/ecg_event_model.dart';

// Import your new isolated widgets
import '../widgets/ecg_event_header.dart';
import '../widgets/ecg_event_chart.dart';
import '../widgets/ecg_event_data_list.dart';

class EcgEventDetailScreen extends ConsumerWidget {
  final EcgEventModel event;

  const EcgEventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final samples = event.snapshot ?? const <double>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.tr('ecg_event_details')),
      ),
      body: Column(
        children: [
          // 1. Info Header (Timestamp & BPM)
          EcgEventHeader(
            timestamp: event.timestamp,
            bpm: event.bpm,
          ),

          // 2. Chart Visualization
          EcgEventChart(samples: samples),

          const Divider(height: 1),

          // 3. Raw Data Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.data_array, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${i18n.tr('raw_data_samples')} (${samples.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          // 4. Scrollable Data List
          Expanded(
            child: EcgEventDataList(samples: samples),
          ),
        ],
      ),
    );
  }
}