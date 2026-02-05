import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/localization/i18n.dart';
import '../../features/ecg/ecg_event_model.dart';
import '../widgets/mini_ecg_painter.dart';

class HistoryItemHandler extends ConsumerWidget {
  final EcgEventModel event;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryItemHandler({
    super.key,
    required this.event,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    
    final t = event.timestamp;
    final timeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(t);

    return Dismissible(
      // Unique key for the list item (DB ID)
      key: ValueKey(event.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: const Icon(
            Icons.warning_amber,
            color: Colors.red,
            size: 30,
          ),
          title: Text(
            i18n.tr('arrhythmia_detected'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$timeStr • BPM: ${event.bpm ?? "--"}'),
              const SizedBox(height: 8),
              
              // Mini Chart Logic
              if (event.snapshot != null && event.snapshot!.isNotEmpty)
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black12,
                  ),
                  child: CustomPaint(
                    painter: MiniEcgPainter(event.snapshot!),
                  ),
                )
              else
                Text(
                  i18n.tr('no_waveform_data'),
                  style: const TextStyle(
                    fontStyle: FontStyle.italic, 
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}