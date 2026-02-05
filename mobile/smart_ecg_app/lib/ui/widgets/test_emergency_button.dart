import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';

class TestEmergencyButton extends ConsumerWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const TestEmergencyButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: const Icon(Icons.warning),
      label: Text(
        i18n.tr('test_emergency_btn'),
        style: const TextStyle(fontSize: 16),
      ),
      onPressed: isEnabled ? onPressed : null,
    );
  }
}