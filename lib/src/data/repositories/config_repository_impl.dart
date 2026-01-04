import 'package:fundingrate/src/data/datasources/config_local_data_source.dart';
import 'package:fundingrate/src/domain/repositories/config_repository.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigLocalDataSource localDataSource;
  late Map<String, dynamic> _config;

  static final Map<String, dynamic> _defaultConfig = {
    "SAVE_BYBIT_RESPONSE": false,
    "CONSOLE_OUTPUT": true,
    "CHECK_INTERVAL_MINUTES": 5,
  };

  ConfigRepositoryImpl({required this.localDataSource});

  Future<void> init() async {
    _config = await localDataSource.getConfig();
    var updated = false;
    _defaultConfig.forEach((key, value) {
      if (!_config.containsKey(key)) {
        _config[key] = value;
        updated = true;
      }
    });
    if (updated) {
      await localDataSource.saveConfig(_config);
    }
  }

  @override
  Future<Map<String, dynamic>> getConfig() async {
    return await localDataSource.getConfig();
  }

  @override
  Future<void> saveConfig(Map<String, dynamic> config) async {
    await localDataSource.saveConfig(config);
  }

  @override
  Future<dynamic> get(String key) async {
    return _config[key];
  }

  @override
  Future<Map<String, dynamic>> getAll() async {
    return Map.unmodifiable(_config);
  }

  @override
  Future<bool> set(String key, dynamic value) async {
    if (_config.containsKey(key)) {
      dynamic parsedValue;
      if (value is bool) {
        parsedValue = value;
      } else if (value is String) {
        if (value.toLowerCase() == 'true') {
          parsedValue = true;
        } else if (value.toLowerCase() == 'false') {
          parsedValue = false;
        } else if (int.tryParse(value) != null) {
          parsedValue = int.parse(value);
        }
      } else if (value is int) {
        parsedValue = value;
      }

      if (key == 'CHECK_INTERVAL_MINUTES' &&
          (parsedValue is! int || parsedValue <= 0)) {
        return false;
      }
      if ((key == 'SAVE_BYBIT_RESPONSE' || key == 'CONSOLE_OUTPUT') &&
          parsedValue is! bool) {
        return false;
      }

      _config[key] = parsedValue;
      await localDataSource.saveConfig(_config);
      return true;
    }
    return false;
  }
}
