import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
import 'package:fundingrate/src/data/datasources/bybit_remote_data_source.dart';
import 'package:fundingrate/src/data/datasources/config_local_data_source.dart';
import 'package:fundingrate/src/data/datasources/roles_local_data_source.dart';
import 'package:fundingrate/src/data/datasources/user_settings_local_data_source.dart';
import 'package:fundingrate/src/data/repositories/bybit_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/config_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/roles_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/user_settings_repository_impl.dart';
import 'package:fundingrate/src/domain/repositories/bybit_repository.dart';
import 'package:fundingrate/src/domain/repositories/config_repository.dart';
import 'package:fundingrate/src/domain/repositories/roles_repository.dart';
import 'package:fundingrate/src/domain/repositories/user_settings_repository.dart';
import 'package:fundingrate/src/domain/usecases/check_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/config_and_roles_usecases.dart';
import 'package:fundingrate/src/domain/usecases/get_all_user_ids.dart';
import 'package:fundingrate/src/domain/usecases/get_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/get_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/save_user_settings.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:fundingrate/src/presentation/commands/command_registry.dart';
import 'package:fundingrate/src/presentation/handlers/lang_handler.dart';
import 'package:fundingrate/src/presentation/handlers/role_handlers.dart';
import 'package:fundingrate/src/presentation/handlers/settings_handler.dart';
import 'package:fundingrate/src/presentation/handlers/settings_update_handler.dart';
import 'package:fundingrate/src/presentation/handlers/start_handler.dart';
import 'package:fundingrate/src/presentation/handlers/status_handler.dart';
import 'package:fundingrate/src/presentation/keyboards/keyboard_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final sl = GetIt.instance;

final logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> init() async {
  // External
  sl.registerSingleton<DotEnv>(DotEnv(includePlatformEnvironment: true)..load());
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<Logger>(logger);

  // Data sources
  sl.registerLazySingleton<BybitRemoteDataSource>(
      () => BybitRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<UserSettingsLocalDataSource>(
      () => UserSettingsLocalDataSourceImpl());
  sl.registerLazySingleton<ConfigLocalDataSource>(
      () => ConfigLocalDataSourceImpl());
  sl.registerLazySingleton<RolesLocalDataSource>(
      () => RolesLocalDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<BybitRepository>(
      () => BybitRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<UserSettingsRepository>(
      () => UserSettingsRepositoryImpl(localDataSource: sl()));

  // We need to register ConfigRepository and RolesRepository as singletons that are created asynchronously
  // because they have an `init()` method.
  final configRepository = ConfigRepositoryImpl(localDataSource: sl());
  await configRepository.init();
  sl.registerSingleton<ConfigRepository>(configRepository);

  final rolesRepository = RolesRepositoryImpl(localDataSource: sl(), env: sl());
  await rolesRepository.init();
  sl.registerSingleton<RolesRepository>(rolesRepository);
  
  // Use cases
  sl.registerLazySingleton(() => GetFundingRates(sl()));
  sl.registerLazySingleton(() => GetUserSettings(sl()));
  sl.registerLazySingleton(() => SaveUserSettings(sl()));
  sl.registerLazySingleton(() => GetAllUserIds(sl()));
  sl.registerLazySingleton(() => CheckFundingRates());
  sl.registerLazySingleton(() => GetConfig(sl()));
  sl.registerLazySingleton(() => SetConfig(sl()));
  sl.registerLazySingleton(() => GetRole(sl()));
  sl.registerLazySingleton(() => AddRole(sl()));
  sl.registerLazySingleton(() => RemoveRole(sl()));
  sl.registerLazySingleton(() => GetAdminIds(sl()));
  sl.registerLazySingleton(() => GetModeratorIds(sl()));

  // Presentation
  // The bot needs the config to be ready for the checkInterval.
  final config = await sl<GetConfig>()();
  final checkInterval = config['CHECK_INTERVAL_MINUTES'] as int? ?? 10;
  
  // Presentation
  // Command Registry
  sl.registerLazySingleton<CommandRegistry>(() => CommandRegistry());

  // Keyboards
  sl.registerLazySingleton<IKeyboardProvider>(
      () => KeyboardProvider(commandRegistry: sl()));

  // Command Handlers
  registerStartCommand(sl());
  registerRoleCommands(sl());
  registerLangCommand(sl());
  registerSettingsCommand(sl());
  registerStatusHandler(sl());
  registerSettingsUpdateCommands(sl());

  sl.registerLazySingleton(
    () => FundingRateBot(
      getFundingRates: sl(),
      getUserSettings: sl(),
      saveUserSettings: sl(),
      getAllUserIds: sl(),
      checkFundingRates: sl(),
      checkIntervalMinutes: checkInterval,
      getRole: sl(),
      keyboardProvider: sl(),
      commandRegistry: sl(),
    ),
  );
}