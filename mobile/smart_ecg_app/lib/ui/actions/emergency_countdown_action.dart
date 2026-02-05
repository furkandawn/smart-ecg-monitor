import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/emergency/emergency_countdown_controller.dart';
import '../../core/localization/i18n.dart';

class EmergencyCountdownOverlay extends ConsumerWidget {
  const EmergencyCountdownOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(emergencyCountdownProvider);
    final i18n = I18n.of(context, ref);

    if (!state.pending) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.85),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 96,
              ),
              const SizedBox(height: 24),
              Text(
                i18n.tr('emergency_detected'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '${state.secondsLeft}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                i18n.tr('sending_soon'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.cancel),
                label: Text(
                  i18n.tr('cancel'),
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  ref
                      .read(
                          emergencyCountdownProvider.notifier)
                      .cancelExecution();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
