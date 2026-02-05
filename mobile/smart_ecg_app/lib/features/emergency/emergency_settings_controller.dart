import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'emergency_settings.dart';
import 'emergency_settings_repository.dart';

final emergencySettingsProvider =
    StateNotifierProvider<EmergencySettingsController, EmergencySettings>(
  (_) => EmergencySettingsController(),
);

class EmergencySettingsController extends StateNotifier<EmergencySettings> {
  EmergencySettingsController()
      : super(const EmergencySettings(
          autoSmsEnabled: true,
          autoCallEnabled: true,
          includeLocationInSms: true,
          smsTemplate: 'This is an automatic emergency message from Smart ECG.',
          primaryCallContactId: null,
        )) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(
      autoSmsEnabled: await EmergencyPreferences.getAutoSms() ?? state.autoSmsEnabled,
      autoCallEnabled: await EmergencyPreferences.getAutoCall() ?? state.autoCallEnabled,
      includeLocationInSms: await EmergencyPreferences.getIncludeLocation() ?? state.includeLocationInSms,
      smsTemplate: await EmergencyPreferences.getTemplate() ?? state.smsTemplate,
      primaryCallContactId: await EmergencyPreferences.getPrimaryCallContactId() ?? state.primaryCallContactId,
    );
  }

  void setAutoSms(bool v) async {
    state = state.copyWith(autoSmsEnabled: v);
    await EmergencyPreferences.setAutoSms(v);
  }

  void setAutoCall(bool v) async {
    state = state.copyWith(autoCallEnabled: v);
    await EmergencyPreferences.setAutoCall(v);
  }

  void setIncludeLocation(bool v) async {
    state = state.copyWith(includeLocationInSms: v);
    await EmergencyPreferences.setIncludeLocation(v);
  }

  void setTemplate(String v) async {
    state = state.copyWith(smsTemplate: v);
    await EmergencyPreferences.setTemplate(v);
  }

  void setPrimaryCallContact(int? id) async {
    state = state.copyWith(primaryCallContactId: id);
    await EmergencyPreferences.setPrimaryCallContactId(id);
  }
}
