import '../entities/user_settings.dart';

abstract class UserSettingsRepository {
  Future<UserSettings?> getSettings(String userId);
  Future<void> saveSettings(UserSettings settings);
  Future<List<String>> getAllUserIds();
}