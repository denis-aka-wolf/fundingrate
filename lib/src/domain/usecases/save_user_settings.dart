import '../entities/user_settings.dart';
import '../repositories/user_settings_repository.dart';

class SaveUserSettings {
  final UserSettingsRepository repository;

  SaveUserSettings(this.repository);

  Future<void> call(UserSettings settings) {
    return repository.saveSettings(settings);
  }
}