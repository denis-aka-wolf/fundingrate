import '../../core/data/json_local_data_source.dart';
import '../../domain/entities/user_settings.dart';

abstract class UserSettingsLocalDataSource {
  Future<UserSettings?> getSettings(String userId);
  Future<void> saveSettings(UserSettings settings);
  Future<List<String>> getAllUserIds();
  Future<void> deleteSettings(String userId);
}

class UserSettingsLocalDataSourceImpl implements UserSettingsLocalDataSource {
  late final JsonLocalDataSource<UserSettings> _dataSource;
  static const String _usersDir = 'settings/users';

  UserSettingsLocalDataSourceImpl() {
    _dataSource = JsonLocalDataSourceImpl<UserSettings>(
      directoryPath: _usersDir,
      fromJson: UserSettings.fromJson,
      toJson: (userSettings) => userSettings.toJson(),
    );
  }

  @override
  Future<UserSettings?> getSettings(String userId) {
    return _dataSource.get(userId);
  }

  @override
  Future<void> saveSettings(UserSettings settings) {
    return _dataSource.save(settings.userId, settings);
  }

  @override
  Future<List<String>> getAllUserIds() {
    return _dataSource.getAllIds();
  }

  @override
  Future<void> deleteSettings(String userId) {
    return _dataSource.delete(userId);
  }
}
