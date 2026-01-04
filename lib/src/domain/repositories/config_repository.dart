abstract class ConfigRepository {
  Future<Map<String, dynamic>> getConfig();
  Future<void> saveConfig(Map<String, dynamic> config);
  Future<dynamic> get(String key);
  Future<Map<String, dynamic>> getAll();
  Future<bool> set(String key, dynamic value);
}
