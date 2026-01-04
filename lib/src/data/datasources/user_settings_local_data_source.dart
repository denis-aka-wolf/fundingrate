import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../../domain/entities/user_settings.dart';

abstract class UserSettingsLocalDataSource {
  Future<UserSettings?> getSettings(String userId);
  Future<void> saveSettings(UserSettings settings);
  Future<List<String>> getAllUserIds();
  Future<void> deleteSettings(String userId);
}

class UserSettingsLocalDataSourceImpl implements UserSettingsLocalDataSource {
  final Directory settingsDirectory;

  UserSettingsLocalDataSourceImpl(this.settingsDirectory);

  File _getSettingsFile(String userId) {
    return File(path.join(settingsDirectory.path, '$userId.json'));
  }

  @override
  Future<UserSettings?> getSettings(String userId) async {
    final file = _getSettingsFile(userId);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return UserSettings.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    final file = _getSettingsFile(settings.userId);
    await file.writeAsString(jsonEncode(settings.toJson()));
  }

  @override
  Future<List<String>> getAllUserIds() async {
    if (!await settingsDirectory.exists()) {
      return [];
    }
    final files = await settingsDirectory.list().toList();
    return files
        .where((file) => file is File && path.extension(file.path) == '.json')
        .map((file) => path.basenameWithoutExtension(file.path))
        .where((fileName) => fileName != 'config' && fileName != 'roles')
        .toList();
  }

  @override
  Future<void> deleteSettings(String userId) async {
    final file = _getSettingsFile(userId);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
