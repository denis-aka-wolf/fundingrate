import 'dart:convert';
import 'dart:io';

abstract class ConfigLocalDataSource {
  Future<Map<String, dynamic>> getConfig();
  Future<void> saveConfig(Map<String, dynamic> config);
}

class ConfigLocalDataSourceImpl implements ConfigLocalDataSource {
  late final File _configFile;
  static const String _configFileName = 'config.json';
  static const String _settingsDir = 'settings';

  ConfigLocalDataSourceImpl() {
    final dir = Directory(_settingsDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    _configFile = File('$_settingsDir/$_configFileName');
  }

  @override
  Future<Map<String, dynamic>> getConfig() async {
    if (await _configFile.exists()) {
      final content = await _configFile.readAsString();
      if (content.isNotEmpty) {
        try {
          return jsonDecode(content);
        } catch (e) {
          // If content is malformed, return empty map to be repopulated
          return {};
        }
      }
    }
    return {};
  }

  @override
  Future<void> saveConfig(Map<String, dynamic> config) async {
    await _configFile.writeAsString(jsonEncode(config));
  }
}
