import 'dart:async';

import 'package:logger/logger.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/model.dart';
import 'package:dartz/dartz.dart';

import '../../../generated/l10n.dart';
import '../../core/error/failures.dart';
import '../../core/service_locator.dart';
import '../../domain/usecases/check_funding_rates.dart';
import '../../domain/usecases/get_all_user_ids.dart';
import '../../domain/usecases/get_funding_rates.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../../data/datasources/user_settings_local_data_source.dart';

class FundingRateCheckService {
  final GetFundingRates getFundingRates;
  final GetUserSettings getUserSettings;
  final GetAllUserIds getAllUserIds;
  final CheckFundingRates checkFundingRates;
  final int checkIntervalMinutes;
  final TeleDart teledart;
  final Logger logger;

  FundingRateCheckService({
    required this.getFundingRates,
    required this.getUserSettings,
    required this.getAllUserIds,
    required this.checkFundingRates,
    required this.checkIntervalMinutes,
    required this.teledart,
    required this.logger,
  });

  void start() {
    _checkRates();
  }

  void _checkRates() async {
    logger.i('Starting funding rate check...');
    try {
      final userIds = await getAllUserIds();
      final ratesResult = await getFundingRates();

      ratesResult.fold(
        (failure) {
          logger.e('Failed to get funding rates: ${failure.message}');
        },
        (rates) {
          for (final userId in userIds) {
            () async {
              final settings = await getUserSettings(userId);
              if (settings != null) {
                await S.load(settings.languageCode);
                final notifications = checkFundingRates(
                  rates: rates,
                  settings: settings,
                );

                for (final notification in notifications) {
                  try {
                    await teledart.sendMessage(
                      userId,
                      S.current.fundingRateAlert(
                        notification.symbol,
                        notification.fundingRate.toString(),
                      ),
                    );
                  } on TeleDartException catch (e) {
                    final error = e.toString();
                    if (error.contains('chat not found') ||
                        error.contains('bot was blocked by the user')) {
                      logger.w(
                          'User $userId blocked the bot or chat not found. Removing user settings.');
                      final localDataSource = sl<UserSettingsLocalDataSource>();
                      await localDataSource.deleteSettings(userId);
                    } else {
                      logger.e(
                        'Error sending message to user $userId',
                        error: e,
                      );
                    }
                  }
                }
              }
            }();
          }
        },
      );
    } catch (e, s) {
      logger.e('Error during funding rate check', error: e, stackTrace: s);
    } finally {
      Future.delayed(Duration(minutes: checkIntervalMinutes), _checkRates);
    }
  }
}