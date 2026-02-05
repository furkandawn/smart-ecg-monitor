import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

import 'emergency_contacts_controller.dart';
import 'emergency_settings_controller.dart';
import 'emergency_countdown_controller.dart';
import 'service/call_service.dart';
import 'service/sms_service.dart';

final emergencyWorkflowProvider =
    Provider<EmergencyWorkflow>((ref) {
  return EmergencyWorkflow(ref);
});

class EmergencyWorkflow {
  final Ref ref;
  EmergencyWorkflow(this.ref);

  Future<void> execute() async {
    final settings = ref.read(emergencySettingsProvider);
    final contacts = ref.read(emergencyContactsProvider);
    final countdown = ref.read(emergencyCountdownProvider.notifier);

    if (contacts.isEmpty) return;

    final Position? location =
        countdown.prefetchedLocation == null
            ? null
            : await countdown.prefetchedLocation;

    try {
      await SmsService.send(settings, contacts, location);
    } catch (e) {
      debugPrint("SMS Failed: $e");
    }
    try {
      CallService.call(settings, contacts);
    } catch (e) {
      debugPrint("CALL Failed: $e");
    }
  }
}
