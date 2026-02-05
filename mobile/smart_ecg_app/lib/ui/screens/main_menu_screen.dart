import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../features/ble/ble_controller.dart';
import '../../features/ble/ble_saved_device.dart';
import '../../features/ble/ble_ui_helper.dart';

import '../../core/localization/i18n.dart';
import '../../core/background/background_service.dart';

import 'live_ecg_screen.dart';
import 'emergency_contacts_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

import '../widgets/bluetooth_status_icon.dart';
import '../widgets/menu_button.dart';
import '../widgets/connect_button.dart';
import '../widgets/confirm_dialog.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final bleAsync = ref.watch(bleControllerProvider);

    return bleAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text(e.toString())),
      ),
      data: (state) {
        final String connectionLabel = state.label(ref);
        final Color connectionColor = state.color;
        final bool isConnected = state.isConnected;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            const MethodChannel('flutter/platform').invokeMethod('SystemNavigator.pop');
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(i18n.tr('app_title')),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: BleStatusIcon(),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    connectionLabel,
                    style: TextStyle(
                      color: connectionColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ConnectButton(isConnected: isConnected),

                  const SizedBox(height: 28),

                  MenuButton(
                    label: i18n.tr('live_ecg'), // "Live ECG"
                    icon: Icons.monitor_heart,
                    enabled: isConnected,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LiveEcgScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  MenuButton(
                    label: i18n.tr('emergency_contacts'), // "Contacts"
                    icon: Icons.contacts,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EmergencyContactsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  MenuButton(
                    label: i18n.tr('ecg_history'), // "History"
                    icon: Icons.history,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),

                  MenuButton(
                    label: i18n.tr('settings'), // "Settings"
                    icon: Icons.settings,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  const Expanded(child: SizedBox()),

                  MenuButton(
                    label: i18n.tr('clear_last_device'),
                    icon: Icons.delete_forever,
                    enabled : BleStorage.cached != null,
                    onPressed: () async {
                      final device = BleStorage.cached;
                      if (device == null) return;
                      final bool confirmed = await ConfirmDialog.show(
                        context,
                        title: i18n.tr('disable_auto_conn_title'),
                        content: '${i18n.tr('disable_auto_conn_body')}\n${(device.name)}',
                        cancelText: i18n.tr('no'),
                        confirmText: i18n.tr('yes'),
                        isDestructive: true,
                      );
                      if (confirmed) {
                        await BleStorage.clearLastDevice();
                        ref.invalidate(bleControllerProvider);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  MenuButton(
                    label: i18n.tr('background_stop_service'),
                    icon: Icons.cancel,
                    onPressed: () async {
                      final bool confirmed = await ConfirmDialog.show(
                        context,
                        title: i18n.tr('background_stop_service_title'),
                        content: i18n.tr('background_stop_service_body'),
                        cancelText: i18n.tr('cancel'),
                        confirmText: i18n.tr('exit_app'),
                        isDestructive: true,
                      );
                      if (confirmed) {
                        ref.read(backgroundServiceProvider.notifier).stopService();
                        SystemNavigator.pop();
                      } else {
                        return;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}