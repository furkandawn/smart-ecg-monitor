import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ble/ble_controller.dart';
import '../../features/ble/ble_ui_helper.dart';

class BleStatusIcon extends ConsumerWidget {
  const BleStatusIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleAsync = ref.watch(bleControllerProvider);

    return bleAsync.when(
      loading: () => const SizedBox(
        width: 24, 
        height: 24, 
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, _) => const Icon(Icons.bluetooth_disabled, color: Colors.red),

      data: (state) {
        return Tooltip(
          message: state.label(ref),
          child: Icon(
            state.icon,
            color: state.color,
            size: 28,
          ),
        );
      },
    );
  }
}