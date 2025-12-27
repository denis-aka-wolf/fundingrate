import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:async';
import 'package:dotenv/dotenv.dart';

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

  late final TeleDart teledart;

  FundingRateBot({
    required this.getUserSettings,
    required this.saveUserSettings,
    required this.getAllUserIds,
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
        settings = UserSettings(
          userId: userId,
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