import 'package:flutter/material.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:async';
import 'package:dotenv/dotenv.dart';

import '../../generated/l10n.dart';
import '../domain/usecases/get_user_settings.dart';
import '../domain/usecases/save_user_settings.dart';
import '../domain/usecases/get_all_user_ids.dart';
import '../domain/usecases/get_funding_rates.dart';
import '../domain/usecases/check_funding_rates.dart';
import '../domain/entities/user_settings.dart';

class FundingRateBot {
  final GetUserSettings getUserSettings;
  final SaveUserSettings saveUserSettings;
  final GetAllUserIds getAllUserIds;
  final GetFundingRates getFundingRates;
  final CheckFundingRates checkFundingRates;

  late TeleDart teledart;
  final TeleDart? _injectedTeleDart;

  FundingRateBot({
    required this.getUserSettings,
    required this.saveUserSettings,
    required this.getAllUserIds,
    required this.getFundingRates,
    required this.checkFundingRates,
    TeleDart? teledart,
  }) : _injectedTeleDart = teledart;

  Future<void> start() async {
    if (_injectedTeleDart != null) {
      teledart = _injectedTeleDart!;
    } else {
      final env = DotEnv(includePlatformEnvironment: true)..load();
      final botToken = env['TELEGRAM_BOT_TOKEN']!;
      final username = (await Telegram(botToken).getMe()).username;
      teledart = TeleDart(botToken, Event(username!));
    }

    // In a real scenario, teledart.start() is called.
    // In tests, we manually control the streams.
    if (_injectedTeleDart == null) {
      teledart.start();
    }

    _registerCommandHandlers();

    print('Bot started!');

    _startFundingRateChecker();
  }

  void _registerCommandHandlers() {
    teledart.onCommand('start').listen((message) async {
      final userId = message.chat.id.toString();
      var settings = await getUserSettings(userId);
      final lang = message.from?.languageCode ?? 'en';

      if (settings == null) {
        settings = UserSettings(
          userId: userId,
          fundingRateThreshold: 0.01,
          minutesBeforeExpiration: 30,
          checkIntervalMinutes: 10,
          lastUpdated: DateTime.now(),
          languageCode: lang,
        );
        await saveUserSettings(settings);
        await S.load(Locale(settings.languageCode));
        await message.reply(S.current.welcomeMessage);
      } else {
        await S.load(Locale(settings.languageCode));
        await message.reply(S.current.welcomeBackMessage);
      }
    });

    teledart.onCommand('settings').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);

      if (settings != null) {
        await S.load(Locale(settings.languageCode));
        await message.reply(settings.toString());
      } else {
        await S.load(Locale(message.from?.languageCode ?? 'en'));
        await message.reply(S.current.settingsNotFound);
      }
    });

    teledart.onCommand('status').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      await S.load(Locale(settings?.languageCode ?? message.from?.languageCode ?? 'en'));
      await message.reply(S.current.botStatus);
    });

    teledart.onCommand('lang').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      final text = message.text;

      if (settings != null && text != null) {
        final parts = text.split(' ');
        if (parts.length == 2) {
          final lang = parts[1];
          if (S.delegate.supportedLocales.any((l) => l.languageCode == lang)) {
            final newSettings = UserSettings(
              userId: settings.userId,
              fundingRateThreshold: settings.fundingRateThreshold,
              minutesBeforeExpiration: settings.minutesBeforeExpiration,
              checkIntervalMinutes: settings.checkIntervalMinutes,
              lastUpdated: DateTime.now(),
              languageCode: lang,
            );
            await saveUserSettings(newSettings);
            await S.load(Locale(lang));
            await message.reply(S.current.languageChanged(lang));
          } else {
            await S.load(Locale(settings.languageCode));
            await message.reply(S.current.unsupportedLanguage);
          }
        } else {
          await S.load(Locale(settings.languageCode));
          await message.reply(S.current.langUsage);
        }
      }
    });
  }

  void _startFundingRateChecker() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final userIds = await getAllUserIds();
      final rates = await getFundingRates();

      for (final userId in userIds) {
        final settings = await getUserSettings(userId);
        if (settings != null) {
          await S.load(Locale(settings.languageCode));
          final notifications = checkFundingRates(
            rates: rates,
            settings: settings,
          );

          for (final notification in notifications) {
            await teledart.sendMessage(
              userId,
              S.current.fundingRateAlert(
                notification.symbol,
                notification.fundingRate.toString(),
              ),
            );
          }
        }
      }
    });
  }
}