import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../domain/entities/user_settings.dart';

abstract class UserSettingsLocalDataSource {
  Future<UserSettings?> getSettings(String userId);
  Future<void> saveSettings(UserSettings settings);
  Future<List<String>> getAllUserIds();
}

class UserSettingsLocalDataSourceImpl implements UserSettingsLocalDataSource {
  final Directory storageDirectory;

  UserSettingsLocalDataSourceImpl(this.storageDirectory);

  @override
  Future<UserSettings?> getSettings(String userId) async {
    final file = File(path.join(storageDirectory.path, '$userId.json'));
    if (await file.exists()) {
      final content = await file.readAsString();
      return UserSettings.fromJson(json.decode(content));
    }
    return null;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    final file = File(path.join(storageDirectory.path, '${settings.userId}.json'));
    await file.create(recursive: true);
    await file.writeAsString(json.encode(settings.toJson()));
  }

  @override
  Future<List<String>> getAllUserIds() async {
    if (await storageDirectory.exists()) {
      return storageDirectory
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.json'))
          .map((entity) => path.basenameWithoutExtension(entity.path))
          .toList();
    }
    return [];
  }
}