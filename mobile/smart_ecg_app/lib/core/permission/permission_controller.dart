import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionProvider = StateNotifierProvider<PermissionNotifier, Map<Permission, PermissionStatus>>((ref) {
  return PermissionNotifier();
});

class PermissionNotifier extends StateNotifier<Map<Permission, PermissionStatus>> {
  PermissionNotifier() : super({}) {
    checkPermissions();
  }

  List<Permission> get _requiredPermissions => [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
        Permission.locationAlways, 
        Permission.sms,
        Permission.phone,
        Permission.notification,
        if (Platform.isAndroid) ...[
          Permission.systemAlertWindow, 
          Permission.ignoreBatteryOptimizations, 
        ]
      ];

  /// Checks status of all permissions in parallel
  Future<void> checkPermissions() async {
    final futures = _requiredPermissions.map((perm) async {
      return MapEntry(perm, await perm.status);
    });
    
    final entries = await Future.wait(futures);
    state = Map.fromEntries(entries);
  }

  /// Request a single permission
  Future<void> requestPermission(Permission perm) async {
    await requestPermissions([perm]);
  }

  /// Request multiple permissions at once
  Future<void> requestPermissions(List<Permission> perms) async {
    // 1. Handle Location Upgrade Logic
    if (perms.contains(Permission.locationAlways)) {
      final inUseStatus = await Permission.locationWhenInUse.status;
      if (!inUseStatus.isGranted) {
        final result = await Permission.locationWhenInUse.request();
        if (!result.isGranted) {
          await checkPermissions();
          return;
        }
      }

      await Permission.locationAlways.request();
      await checkPermissions();
      return;
    }

    // 2. Separate direct-settings permissions from standard ones
    final standardPerms = <Permission>[];

    for (final perm in perms) {
      if (_isDirectSettingsPermission(perm)) {
         if (!(await perm.status.isGranted)) {
           await openAppSettings();
         }
      } else {
        standardPerms.add(perm);
      }
    }

    // 3. Request standard permissions in batch
    if (standardPerms.isNotEmpty) {
      await standardPerms.request();
    }

      await checkPermissions();
  }

  void refresh() => checkPermissions();

  bool _isDirectSettingsPermission(Permission p) {
    return p == Permission.systemAlertWindow; 
  }
}