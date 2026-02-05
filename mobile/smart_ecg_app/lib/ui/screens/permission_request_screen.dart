import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/localization/i18n.dart';
import '../../core/permission/permission_controller.dart';
import '../widgets/permission_request_item.dart';
import 'language_screen.dart';

class PermissionRequestScreen extends ConsumerWidget {
  const PermissionRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final statusMap = ref.watch(permissionProvider);
    final notifier = ref.read(permissionProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguageScreen()),
              );
            },
            icon: const Icon(Icons.language, color: Colors.white),
            label: Text(
              i18n.tr('language'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.security, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                i18n.tr('permissions_required'),
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                i18n.tr('permissions_intro'),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: ListView(
                  children: [
                    PermissionRequestItem(
                      title: i18n.tr('permission_bluetooth'),
                      subtitle: i18n.tr('permission_bluetooth_desc'),
                      status: statusMap[Permission.bluetoothConnect],
                      onFix: () => notifier.requestPermissions([
                        Permission.bluetoothScan, 
                        Permission.bluetoothConnect
                      ]),
                      allowLabel: i18n.tr('allow'),
                    ),

                    PermissionRequestItem(
                      title: i18n.tr('permission_location_always'),
                      subtitle: i18n.tr('permission_location_always_desc'),
                      status: statusMap[Permission.locationAlways] ?? statusMap[Permission.locationWhenInUse],
                      onFix: () => notifier.requestPermission(Permission.locationAlways),
                      allowLabel: i18n.tr('allow'),
                    ),

                    // 🔥 FIXED: SMS & Call Group
                    PermissionRequestItem(
                      title: i18n.tr('permission_sms_calls'),
                      subtitle: i18n.tr('permission_sms_calls_desc'),
                      // Only green if BOTH are granted
                      status: (statusMap[Permission.sms]?.isGranted == true && 
                               statusMap[Permission.phone]?.isGranted == true) 
                               ? PermissionStatus.granted 
                               : PermissionStatus.denied,
                      // Request BOTH
                      onFix: () => notifier.requestPermissions([
                        Permission.sms, 
                        Permission.phone
                      ]),
                      allowLabel: i18n.tr('allow'),
                    ),

                    PermissionRequestItem(
                      title: i18n.tr('permission_notifications'),
                      subtitle: i18n.tr('permission_notifications_desc'),
                      status: statusMap[Permission.notification],
                      onFix: () => notifier.requestPermission(Permission.notification),
                      allowLabel: i18n.tr('allow'),
                    ),

                    if (Platform.isAndroid) ...[
                      PermissionRequestItem(
                        title: i18n.tr('permission_lock_screen'),
                        subtitle: i18n.tr('permission_lock_screen_desc'),
                        status: statusMap[Permission.systemAlertWindow],
                        onFix: () => notifier.requestPermission(Permission.systemAlertWindow),
                        allowLabel: i18n.tr('allow'),
                      ),
                      PermissionRequestItem(
                        title: i18n.tr('permission_battery'),
                        subtitle: i18n.tr('permission_battery_desc'),
                        status: statusMap[Permission.ignoreBatteryOptimizations],
                        onFix: () => notifier.requestPermission(Permission.ignoreBatteryOptimizations),
                        allowLabel: i18n.tr('allow'),
                      ),
                    ],
                  ],
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () => openAppSettings(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(i18n.tr('open_android_settings')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}