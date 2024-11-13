class NotificationPreferences {
  Map<String, bool> preferences = {
    '문자': false,
    '이메일': false,
    '푸쉬알림': false,
  };

  void updatePreference(String key, bool value) {
    preferences[key] = value;
  }
}
