import 'dart:io';
import 'package:fundingrate/src/data/datasources/bybit_remote_data_source.dart';
import 'package:fundingrate/src/data/datasources/user_settings_local_data_source.dart';
import 'package:fundingrate/src/data/repositories/bybit_repository_impl.dart';
import 'package:fundingrate/src/data/repositories/user_settings_repository_impl.dart';
import 'package:fundingrate/src/domain/usecases/check_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/get_all_user_ids.dart';
import 'package:fundingrate/src/domain/usecases/get_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/get_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/save_user_settings.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:http/http.dart' as http;

void main(List<String> arguments) {
  // Data layer
  final client = http.Client();
  final bybitRemoteDataSource = BybitRemoteDataSourceImpl(client);
  final userSettingsLocalDataSource =
      UserSettingsLocalDataSourceImpl(Directory('settings'));
  final bybitRepository =
      BybitRepositoryImpl(remoteDataSource: bybitRemoteDataSource);
  final userSettingsRepository = UserSettingsRepositoryImpl(
      localDataSource: userSettingsLocalDataSource);

  // Domain layer
  final getFundingRates = GetFundingRates(bybitRepository);
  final getUserSettings = GetUserSettings(userSettingsRepository);
  final saveUserSettings = SaveUserSettings(userSettingsRepository);
  final getAllUserIds = GetAllUserIds(userSettingsRepository);
  final checkFundingRates = CheckFundingRates();

  // Presentation layer
  final bot = FundingRateBot(
    getFundingRates: getFundingRates,
    getUserSettings: getUserSettings,
    saveUserSettings: saveUserSettings,
    getAllUserIds: getAllUserIds,
    checkFundingRates: checkFundingRates,
  );

  bot.start();
}
