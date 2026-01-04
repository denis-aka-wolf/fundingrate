import 'dart:convert';
import 'dart:io';

abstract class RolesLocalDataSource {
  Future<Map<String, String>> getRoles();
  Future<void> saveRoles(Map<String, String> roles);
}

class RolesLocalDataSourceImpl implements RolesLocalDataSource {
  late final File _rolesFile;
  static const String _rolesFileName = 'roles.json';
  static const String _settingsDir = 'settings';

  RolesLocalDataSourceImpl() {
    final dir = Directory(_settingsDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    _rolesFile = File('$_settingsDir/$_rolesFileName');
  }

  @override
  Future<Map<String, String>> getRoles() async {
    if (await _rolesFile.exists()) {
      final content = await _rolesFile.readAsString();
      if (content.isNotEmpty) {
        try {
          return Map<String, String>.from(jsonDecode(content));
        } catch (e) {
          // If content is malformed, return empty map to be repopulated
          return {};
        }
      }
    }
    return {};
  }

  @override
  Future<void> saveRoles(Map<String, String> roles) async {
    await _rolesFile.writeAsString(jsonEncode(roles));
  }
}
