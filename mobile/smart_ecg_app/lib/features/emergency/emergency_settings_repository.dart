import 'package:shared_preferences/shared_preferences.dart';

class EmergencyPreferences {
  static const _autoSms = 'em_auto_sms';
  static const _autoCall = 'em_auto_call';
  static const _includeLocation = 'em_include_location';
  static const _template = 'em_sms_template';
  static const _primaryId = 'em_primary_call_id';

  static Future<SharedPreferences> _p() => SharedPreferences.getInstance();

  // Getters
  static Future<bool?> getAutoSms() async => (await _p()).getBool(_autoSms);
  static Future<bool?> getAutoCall() async => (await _p()).getBool(_autoCall);
  static Future<bool?> getIncludeLocation() async => (await _p()).getBool(_includeLocation);
  static Future<String?> getTemplate() async => (await _p()).getString(_template);
  static Future<int?> getPrimaryCallContactId() async => (await _p()).getInt(_primaryId);

  // Setters
  static Future<void> setAutoSms(bool v) async => (await _p()).setBool(_autoSms, v);
  static Future<void> setAutoCall(bool v) async => (await _p()).setBool(_autoCall, v);
  static Future<void> setIncludeLocation(bool v) async => (await _p()).setBool(_includeLocation, v);
  static Future<void> setTemplate(String v) async => (await _p()).setString(_template, v);

  static Future<void> setPrimaryCallContactId(int? id) async {
    final p = await _p();
    if (id == null) {
      await p.remove(_primaryId);
    } else {
      await p.setInt(_primaryId, id);
    }
  }
}