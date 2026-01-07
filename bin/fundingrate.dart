import 'package:fundingrate/generated/l10n.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:fundingrate/src/core/service_locator.dart' as sl;

void main(List<String> arguments) async {
  // Initialize service locator
  await sl.init();

  // Load default locale
  await S.load('en');

  // Get bot instance from service locator
  final bot = sl.sl<FundingRateBot>();

  // Start the bot
  bot.start();
}
