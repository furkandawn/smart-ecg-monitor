import 'package:another_telephony/telephony.dart';

import '../emergency_settings.dart';
import '../../../data/database/app_database.dart';

class CallService {
  static final _t = Telephony.instance;

  static Future<void> call(
      EmergencySettings s, List<EmergencyContact> contacts) async {
    if (!s.autoCallEnabled || s.primaryCallContactId == null) return;
    final c = contacts
        .where((e) => e.id == s.primaryCallContactId)
        .firstOrNull;
    if (c != null) await _t.dialPhoneNumber(c.phone);
  }
}
