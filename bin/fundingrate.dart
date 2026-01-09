import 'dart:async';

import 'package:fundingrate/generated/l10n.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:fundingrate/src/core/service_locator.dart' as sl;
import 'package:logger/logger.dart';

void main(List<String> arguments) async {
  // Use a local logger for startup diagnostics
  final logger = Logger();

  try {
    logger.i('Application starting...');

    // Initialize service locator
    await sl.init();
    logger.i('Service locator initialized successfully.');

    // Load default locale
    await S.load('en');
    logger.i('Default locale loaded.');

    // Get bot instance from service locator
    final bot = sl.sl<FundingRateBot>();
    logger.i('Bot instance created.');

    // Start the bot
    bot.start();
    logger.i('Bot start command issued. The bot is now running.');

    // Keep the main isolate alive
    await Completer().future;
  } catch (e, s) {
    logger.f('FATAL: Application failed to start.', error: e, stackTrace: s);
  }
}
