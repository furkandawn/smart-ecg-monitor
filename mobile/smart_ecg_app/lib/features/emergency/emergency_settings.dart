const Object _default = Object();

class EmergencySettings {
  final bool autoSmsEnabled;
  final bool autoCallEnabled;
  final bool includeLocationInSms;
  final String smsTemplate;
  final Object? primaryCallContactId;

  const EmergencySettings({
    required this.autoSmsEnabled,
    required this.autoCallEnabled,
    required this.includeLocationInSms,
    required this.smsTemplate,
    required this.primaryCallContactId,
  });

  EmergencySettings copyWith({
    bool? autoSmsEnabled,
    bool? autoCallEnabled,
    bool? includeLocationInSms,
    String? smsTemplate,
    Object? primaryCallContactId = _default,
  }) {
    return EmergencySettings(
      autoSmsEnabled: autoSmsEnabled ?? this.autoSmsEnabled,
      autoCallEnabled: autoCallEnabled ?? this.autoCallEnabled,
      includeLocationInSms: includeLocationInSms ?? this.includeLocationInSms,
      smsTemplate: smsTemplate ?? this.smsTemplate,
      primaryCallContactId: primaryCallContactId == _default ? this.primaryCallContactId : primaryCallContactId as int?,
    );
  }
}
