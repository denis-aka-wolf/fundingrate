import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/user_settings_repository.dart';
import '../datasources/user_settings_local_data_source.dart';

class UserSettingsRepositoryImpl implements UserSettingsRepository {
  final UserSettingsLocalDataSource localDataSource;

  UserSettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<UserSettings?> getSettings(String userId) {
    return localDataSource.getSettings(userId);
  }

  @override
  Future<void> saveSettings(UserSettings settings) {
    return localDataSource.saveSettings(settings);
  }

  @override
  Future<List<String>> getAllUserIds() {
    return localDataSource.getAllUserIds();
  }
}