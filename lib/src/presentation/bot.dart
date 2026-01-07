import 'package:dartz/dartz.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';
import 'dart:async';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:logger/logger.dart';

import '../../generated/l10n.dart';
import '../core/error/failures.dart';
import '../core/service_locator.dart';
import '../data/datasources/user_settings_local_data_source.dart';
import '../domain/usecases/get_user_settings.dart';
import '../domain/usecases/save_user_settings.dart';
import '../domain/usecases/get_all_user_ids.dart';
import '../domain/usecases/get_funding_rates.dart';
import '../domain/usecases/check_funding_rates.dart';
import '../domain/usecases/config_and_roles_usecases.dart';
import '../domain/entities/user_settings.dart';
import '../domain/entities/user.dart';

import 'package:fundingrate/src/presentation/commands/bot_command.dart';
import 'package:fundingrate/src/presentation/commands/command_registry.dart';
import 'package:fundingrate/src/presentation/keyboards/keyboard_provider.dart';

class FundingRateBot {
  final GetUserSettings getUserSettings;
  final SaveUserSettings saveUserSettings;
  final GetAllUserIds getAllUserIds;
  final GetFundingRates getFundingRates;
  final CheckFundingRates checkFundingRates;
  final int checkIntervalMinutes;
  final GetRole getRole;
  final IKeyboardProvider keyboardProvider;
  final CommandRegistry commandRegistry;

  late TeleDart teledart;
  final TeleDart? _injectedTeleDart;

  FundingRateBot({
    required this.getUserSettings,
    required this.saveUserSettings,
    required this.getAllUserIds,
    required this.getFundingRates,
    required this.checkFundingRates,
    required this.checkIntervalMinutes,
    required this.getRole,
    required this.keyboardProvider,
    required this.commandRegistry,
    TeleDart? teledart,
  }) : _injectedTeleDart = teledart;

  Future<void> start() async {
    sl<Logger>().i('Starting bot...');
    if (_injectedTeleDart != null) {
      teledart = _injectedTeleDart!;
    } else {
      final env = sl<DotEnv>();
      final botToken = env['TELEGRAM_BOT_TOKEN']!;
      final username = (await Telegram(botToken).getMe()).username;
      teledart = TeleDart(botToken, Event(username!));
    }

    if (_injectedTeleDart == null) {
      teledart.start();
    }

    sl<Logger>().i('Registering command handlers...');
    _registerCommandHandlers();

    sl<Logger>().i('Bot started!');

    _startFundingRateChecker();
  }

  void _registerCommandHandlers() {
    sl<Logger>().i('Registering command handlers...');

    // Handle text messages/commands
    teledart.onMessage().listen((message) async {
      if (message.text == null || !message.text!.startsWith('/')) return;
      final userRole = await getRole(message.from!.id) ?? UserRole.user;

      try {
        final botCommand = commandRegistry.findByCommand(message.text!);
        if (botCommand != null) {
          if (botCommand.canExecute(userRole)) {
            await botCommand.handler?.call(message, userRole);
          } else {
            await message.reply(S.current.accessDenied);
          }
        }
      } catch (e) {
        sl<Logger>().w('Command not found for message: ${message.text}');
      }
    });

    // Handle callback queries from inline keyboards
    teledart.onCallbackQuery().listen((query) async {
      if (query.data == null) return;
      final userRole = await getRole(query.from.id) ?? UserRole.user;

      try {
        final botCommand = commandRegistry.findByCallbackData(query.data!);
        if (botCommand != null) {
          if (botCommand.canExecute(userRole)) {
            await botCommand.callbackHandler?.call(query, userRole);
          } else {
            await teledart.answerCallbackQuery(query.id,
                text: S.current.accessDenied);
          }
        }
      } catch (e) {
        sl<Logger>().w('Command not found for callback data: ${query.data}');
      }
      await teledart.answerCallbackQuery(query.id);
    });
  }

  void _startFundingRateChecker() {
    _checkRates();
  }

  void _checkRates() async {
    sl<Logger>().i('Starting funding rate check...');
    try {
      final userIds = await getAllUserIds();
      final ratesResult = await getFundingRates();

      ratesResult.fold(
        (failure) {
          sl<Logger>().e('Failed to get funding rates: ${failure.message}');
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
                      sl<Logger>().w(
                          'User $userId blocked the bot or chat not found. Removing user settings.');
                      final localDataSource = UserSettingsLocalDataSourceImpl();
                      await localDataSource.deleteSettings(userId);
                    } else {
                      sl<Logger>().e(
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
      sl<Logger>().e('Error during funding rate check', error: e, stackTrace: s);
    } finally {
      Future.delayed(Duration(minutes: checkIntervalMinutes), _checkRates);
    }
  }

}
