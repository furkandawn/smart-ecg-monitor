import 'package:another_telephony/telephony.dart';
import 'package:geolocator/geolocator.dart';

import '../emergency_settings.dart';
import '../../../core/location/location_service.dart';
import '../../../data/database/app_database.dart';

class SmsService {
  static final _t = Telephony.instance;

  static Future<void> send(
    EmergencySettings s,
    List<EmergencyContact> contacts,
    Position? prefetchedLocation,
  ) async {
    if (!s.autoSmsEnabled) return;

    String message = s.smsTemplate;

    if (s.includeLocationInSms && prefetchedLocation != null) {
      final link = LocationService.formatMapsLink(prefetchedLocation);
      message += '\n\nMy location:\n$link';
    }

    for (final c in contacts) {
      await _t.sendSms(
        to: c.phone,
        message: message,
        isMultipart: message.length > 160,
      );
    }
  }
}
