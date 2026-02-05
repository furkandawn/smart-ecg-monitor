import 'package:flutter/foundation.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:package_info_plus/package_info_plus.dart';


class EmergencyAlarmController {
  static final instance = EmergencyAlarmController();
  final _player = AudioPlayer();
    
  Future<void> _startVibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        pattern: [0, 1000, 500, 1000],
        repeat: 0,
        amplitude: 255
        );
    } else {
      debugPrint("VIBRATION ERROR");
    }
  }

  // Note: AudioPlayers uses 'AssetSource' which automatically looks in 'assets/'
  Future<void> _startPlayer() async {
    try {
      await _player.play(AssetSource('sound/emergency.mp3'));
    } catch (e) {
      debugPrint("Error playing alarm sound: $e");
    }
  }

  Future<void> startAlarm() async {
    debugPrint("🚨 STARTING ALARM");

    await VolumeController.instance.setVolume(0.2);
    await _player.setVolume(1);
    await _player.setReleaseMode(ReleaseMode.loop);

    Future.wait([
      _startVibration(),
      _startPlayer(),
    ]);
  }

  Future<void> stopAlarm() async {
    debugPrint("🚨 STOPPING ALARM");
    await _player.stop();
    await Vibration.cancel();
  }

  Future<void> bringAppToFront() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String packageName = packageInfo.packageName;
      
      final String className = '$packageName.MainActivity';

      debugPrint("🚀 Bringing $packageName / $className to front...");

      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.LAUNCHER',
        
        package: packageName, 
        componentName: className, 
        
        flags: <int>[
          Flag.FLAG_ACTIVITY_NEW_TASK,
          Flag.FLAG_ACTIVITY_REORDER_TO_FRONT,
          Flag.FLAG_ACTIVITY_SINGLE_TOP,
          Flag.FLAG_ACTIVITY_CLEAR_TOP,
        ],
      );

      await intent.launch();
      
    } catch (e) {
      debugPrint("❌ Failed to bring app to front: $e");
    }
  }
}