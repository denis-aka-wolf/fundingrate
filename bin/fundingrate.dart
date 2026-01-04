import 'dart:io';
import 'package:fundingrate/src/data/datasources/bybit_remote_data_source.dart';
import 'package:fundingrate/src/data/datasources/config_local_data_source.dart';
import 'package:fundingrate/src/data/datasources/roles_local_data_source.dart';
import 'package:fundingrate/src/data/datasources/user_settings_local_data_source.dart';
import 'package:fundingrate/src/data/repositories/bybit_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/config_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/roles_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/user_settings_repository_impl.dart';
import 'package:fundingrate/src/domain/usecases/check_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/config_and_roles_usecases.dart';
import 'package:fundingrate/src/domain/usecases/get_all_user_ids.dart';
import 'package:fundingrate/src/domain/usecases/get_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/get_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/save_user_settings.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:dio/dio.dart';
import 'package:fundingrate/generated/l10n.dart';
import 'package:dotenv/dotenv.dart';

void main(List<String> arguments) async {
  // Load environment variables
  final env = DotEnv(includePlatformEnvironment: true)..load();

  // Load default locale
  await S.load('en');

  // Data layer
  final dio = Dio();
  final bybitRemoteDataSource = BybitRemoteDataSourceImpl(dio);
  final userSettingsLocalDataSource = UserSettingsLocalDataSourceImpl(
    Directory('settings'),
  );
  final configLocalDataSource = ConfigLocalDataSourceImpl();
  final rolesLocalDataSource = RolesLocalDataSourceImpl();

  final bybitRepository = BybitRepositoryImpl(
    remoteDataSource: bybitRemoteDataSource,
  );
  final userSettingsRepository = UserSettingsRepositoryImpl(
    localDataSource: userSettingsLocalDataSource,
  );
  final configRepository = ConfigRepositoryImpl(
    localDataSource: configLocalDataSource,
  );
  await configRepository.init();
  final rolesRepository = RolesRepositoryImpl(
    localDataSource: rolesLocalDataSource,
    env: env,
  );
  await rolesRepository.init();

  // Domain layer
  final getFundingRates = GetFundingRates(bybitRepository);
  final getUserSettings = GetUserSettings(userSettingsRepository);
  final saveUserSettings = SaveUserSettings(userSettingsRepository);
  final getAllUserIds = GetAllUserIds(userSettingsRepository);
  final checkFundingRates = CheckFundingRates();
  final getConfig = GetConfig(configRepository);
  final setConfig = SetConfig(configRepository);
  final getRole = GetRole(rolesRepository);
  final addRole = AddRole(rolesRepository);
  final removeRole = RemoveRole(rolesRepository);
  final getAdminIds = GetAdminIds(rolesRepository);
  final getModeratorIds = GetModeratorIds(rolesRepository);

  // Presentation layer
  final config = await getConfig();
  final checkInterval = config['CHECK_INTERVAL_MINUTES'] as int? ?? 10;
  final bot = FundingRateBot(
    getFundingRates: getFundingRates,
    getUserSettings: getUserSettings,
    saveUserSettings: saveUserSettings,
    getAllUserIds: getAllUserIds,
    checkFundingRates: checkFundingRates,
    checkIntervalMinutes: checkInterval,
    getConfig: getConfig,
    setConfig: setConfig,
    getRole: getRole,
    addRole: addRole,
    removeRole: removeRole,
    getAdminIds: getAdminIds,
    getModeratorIds: getModeratorIds,
  );

  bot.start();
}
