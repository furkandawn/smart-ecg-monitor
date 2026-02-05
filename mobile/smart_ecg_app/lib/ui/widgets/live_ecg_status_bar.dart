import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';

class LiveEcgStatusBar extends ConsumerWidget {
  final int? bpm;
  final bool isLive;

  const LiveEcgStatusBar({
    super.key,
    required this.bpm,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade900,
      child: Row(
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 8),
          Text(
            bpm != null 
                ? '$bpm ${i18n.tr('bpm')}' 
                : '-- ${i18n.tr('bpm')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            isLive ? i18n.tr('live_status') : i18n.tr('paused_status'),
            style: TextStyle(
              color: isLive ? Colors.greenAccent : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}