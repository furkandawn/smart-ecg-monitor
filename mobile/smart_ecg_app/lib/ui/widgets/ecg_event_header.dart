import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/localization/i18n.dart';

class EcgEventHeader extends ConsumerWidget {
  final DateTime timestamp;
  final int? bpm;

  const EcgEventHeader({
    super.key,
    required this.timestamp,
    required this.bpm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final timeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Timestamp Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.tr('timestamp'), 
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                timeStr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // BPM Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                i18n.tr('bpm'), 
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                '${bpm ?? '--'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}