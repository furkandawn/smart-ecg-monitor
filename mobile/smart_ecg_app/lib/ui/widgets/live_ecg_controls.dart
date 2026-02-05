import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';

class LiveEcgControls extends ConsumerWidget {
  final double gain;
  final bool isLive;
  final bool canStream;
  final ValueChanged<double> onGainChanged;
  final ValueChanged<bool> onToggleStream;

  const LiveEcgControls({
    super.key,
    required this.gain,
    required this.isLive,
    required this.canStream,
    required this.onGainChanged,
    required this.onToggleStream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Gain Down
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              final newGain = (gain / 1.25).clamp(0.25, 8.0);
              onGainChanged(newGain);
            },
          ),

          // Gain Text
          Text(
            '${i18n.tr('gain')} ×${gain.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          // Gain Up
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final newGain = (gain * 1.25).clamp(0.25, 8.0);
              onGainChanged(newGain);
            },
          ),

          const Spacer(),

          // Live Toggle
          Switch(
            value: isLive,
            onChanged: canStream ? onToggleStream : null,
          ),
        ],
      ),
    );
  }
}