import 'dart:async';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final backgroundServiceProvider = StateNotifierProvider<BackgroundServiceNotifier, bool>((ref) {
  return BackgroundServiceNotifier();
});

class BackgroundServiceNotifier extends StateNotifier<bool> {
  BackgroundServiceNotifier() : super(false);

  bool _isStarting = false;

  Future<void> _initialize() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Smart ECG",
      notificationText: "Running in background",
      notificationImportance: AndroidNotificationImportance.high,
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'), 
      enableWifiLock: true,
      shouldRequestBatteryOptimizationsOff: false,
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
  }

  Future<void> startService() async {
    if (state == true || _isStarting) {
      debugPrint("ℹ️ Service start ignored: Already running or starting...");
      return;
    }

    _isStarting = true;

    await _initialize();
    try {
      bool success = await FlutterBackground.enableBackgroundExecution();
      if (success) {
        debugPrint("✅ BACKGROUND EXECUTION ENABLED");
        state = true;
      }
    } catch (e) {
      debugPrint("❌ Error starting background service: $e");
    }
  }

  Future<void> stopService() async {
    try {
      await FlutterBackground.disableBackgroundExecution();
      debugPrint("🛑 BACKGROUND EXECUTION DISABLED");
      state = false;
    } catch (e) {
      debugPrint("Error stopping service: $e");
    }
  }
}