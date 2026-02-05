import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'service/alarm_service.dart';
import '../../core/location/location_service.dart';
import 'emergency_settings_controller.dart';
import 'emergency_workflow.dart';

class EmergencyCountdownState {
  final bool pending;
  final int secondsLeft;

  const EmergencyCountdownState(this.pending, this.secondsLeft);
  const EmergencyCountdownState.idle() : this(false, 0);
}

final emergencyCountdownProvider =
    NotifierProvider<EmergencyCountdownController,
        EmergencyCountdownState>(
  EmergencyCountdownController.new,
);

class EmergencyCountdownController extends Notifier<EmergencyCountdownState> {
  Timer? _timer;
  int _token = 0;

  Future<Position?>? _prefetchedLocation;

  Future<Position?>? get prefetchedLocation => _prefetchedLocation;

  @override
  EmergencyCountdownState build() {
    ref.onDispose(initState);
    return const EmergencyCountdownState.idle();
  }

  void start(int seconds) async {
    EmergencyAlarmController.instance.startAlarm();
    EmergencyAlarmController.instance.bringAppToFront();
    initState();
    final token = ++_token;

    final settings = ref.read(emergencySettingsProvider);

    if (settings.includeLocationInSms) {
      _prefetchedLocation = () async {
        return LocationService.getCurrentPosition();
      }();
    } else {
      _prefetchedLocation = null;
    }

    state = EmergencyCountdownState(true, seconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_token != token) {
        t.cancel();
        return;
      }

      if (state.secondsLeft <= 1) {
        t.cancel();
        ref.read(emergencyWorkflowProvider).execute();
        EmergencyAlarmController.instance.stopAlarm();
        state = const EmergencyCountdownState.idle();
      } else {
        state = EmergencyCountdownState(
          true,
          state.secondsLeft - 1,
        );
      }
    });
  }

  void cancelExecution() {
    initState();
    EmergencyAlarmController.instance.stopAlarm();
    state = const EmergencyCountdownState.idle();
  }

  void initState() {
    _timer?.cancel();
    _timer = null;
    _token++;
    _prefetchedLocation = null;
  }
}
