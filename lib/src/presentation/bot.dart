import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:async';
import 'package:dotenv/dotenv.dart';

import '../domain/usecases/get_user_settings.dart';
import '../domain/usecases/save_user_settings.dart';
import '../domain/usecases/get_all_user_ids.dart';
import '../domain/usecases/get_trading_pairs.dart';
import '../domain/usecases/get_funding_rates.dart';
import '../domain/usecases/check_funding_rates.dart';
import '../domain/entities/user_settings.dart';

class FundingRateBot {
  final GetUserSettings getUserSettings;
  final SaveUserSettings saveUserSettings;
  final GetAllUserIds getAllUserIds;
  final GetTradingPairs getTradingPairs;
  final GetFundingRates getFundingRates;
  final CheckFundingRates checkFundingRates;

  late final TeleDart teledart;

  FundingRateBot({
    required this.getUserSettings,
    required this.saveUserSettings,
    required this.getAllUserIds,
    required this.getTradingPairs,
    required this.getFundingRates,
    required this.checkFundingRates,
  });

  Future<void> start() async {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final botToken = env['TELEGRAM_BOT_TOKEN']!;
    final username = (await Telegram(botToken).getMe()).username;
    teledart = TeleDart(botToken, Event(username!));

    teledart.start();

    _registerCommandHandlers();

    print('Bot started!');

    _startFundingRateChecker();
  }

  void _registerCommandHandlers() {
    teledart.onCommand('start').listen((message) async {
      final userId = message.chat.id.toString();
      var settings = await getUserSettings(userId);

      if (settings == null) {
        final allPairs = await getTradingPairs();
        settings = UserSettings(
          userId: userId,
          pairs: allPairs.map((p) => p.symbol).toList(),
          fundingRateThreshold: 0.01,
          minutesBeforeExpiration: 30,
          checkIntervalMinutes: 10,
          lastUpdated: DateTime.now(),
        );
        await saveUserSettings(settings);
        await message.reply(
            'Welcome! I will notify you about funding rates. By default, all pairs are monitored. You can change this with the /settings command.');
      } else {
        await message.reply('Welcome back! You are already set up.');
      }
    });

    teledart.onCommand('settings').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);

      if (settings != null) {
        await message.reply(settings.toString());
      } else {
        await message.reply(
            'Settings not found. Please use the /start command to begin.');
      }
    });

    teledart.onCommand('add_pair').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      final text = message.text;

      if (settings != null && text != null) {
        final parts = text.split(' ');
        if (parts.length == 2) {
          final pair = parts[1].toUpperCase();
          if (!settings.pairs.contains(pair)) {
            settings.pairs.add(pair);
            await saveUserSettings(settings);
            await message.reply('$pair added to your list.');
          } else {
            await message.reply('$pair is already in your list.');
          }
        } else {
          await message.reply('Usage: /add_pair <SYMBOL>');
        }
      }
    });

    teledart.onCommand('remove_pair').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      final text = message.text;

      if (settings != null && text != null) {
        final parts = text.split(' ');
        if (parts.length == 2) {
          final pair = parts[1].toUpperCase();
          if (settings.pairs.contains(pair)) {
            settings.pairs.remove(pair);
            await saveUserSettings(settings);
            await message.reply('$pair removed from your list.');
          } else {
            await message.reply('$pair is not in your list.');
          }
        } else {
          await message.reply('Usage: /remove_pair <SYMBOL>');
        }
      }
    });

    teledart.onCommand('reset_pairs').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);

      if (settings != null) {
        final allPairs = await getTradingPairs();
        settings.pairs.clear();
        settings.pairs.addAll(allPairs.map((p) => p.symbol));
        await saveUserSettings(settings);
        await message.reply('Your pair list has been reset to the default.');
      } else {
        await message.reply(
            'Settings not found. Please use the /start command to begin.');
      }
    });

    teledart.onCommand('status').listen((message) async {
      await message.reply('I am alive and running!');
    });
  }

  void _startFundingRateChecker() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final userIds = await getAllUserIds();
      final rates = await getFundingRates();

      for (final userId in userIds) {
        final settings = await getUserSettings(userId);
        if (settings != null) {
          final notifications = checkFundingRates(
            rates: rates,
            settings: settings,
          );

          for (final notification in notifications) {
            await teledart.sendMessage(
              userId,
              'Funding Rate Alert for ${notification.symbol}: ${notification.fundingRate}',
            );
          }
        }
      }
    });
  }
}