import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_controller.dart';
import '../../ui/screens/permission_request_screen.dart';

class PermissionGuard extends ConsumerStatefulWidget {
  final Widget child;
  const PermissionGuard({super.key, required this.child});

  @override
  ConsumerState<PermissionGuard> createState() => _PermissionGuardState();
}

class _PermissionGuardState extends ConsumerState<PermissionGuard> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(permissionProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusMap = ref.watch(permissionProvider);
    
    // Check if any REQUIRED permission is missing
    final hasMissingPermissions = statusMap.entries.any((entry) {
      // 'Limited' is often acceptable (e.g., iOS restricted photos/location)
      return !entry.value.isGranted && !entry.value.isLimited; 
    });

    if (hasMissingPermissions) {
      return const PermissionRequestScreen();
    }

    return widget.child;
  }
}