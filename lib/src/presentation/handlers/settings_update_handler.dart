import 'package:teledart/model.dart' as tele;
import '../../../generated/l10n.dart';
import '../../core/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../../domain/usecases/save_user_settings.dart';
import '../commands/bot_command.dart';
import '../commands/command_registry.dart';

void registerSettingsUpdateCommands(CommandRegistry registry) {
  _registerUpdateCommand<double>(
    registry: registry,
    command: 'set_funding_rate_threshold',
    description: 'Set funding rate notification threshold',
    parser: double.parse,
    updater: (settings, value) => UserSettings(
      userId: settings.userId,
      fundingRateThreshold: value,
      minutesBeforeExpiration: settings.minutesBeforeExpiration,
      lastUpdated: DateTime.now(),
      languageCode: settings.languageCode,
    ),
    successMessage: S.current.fundingRateThresholdUpdated,
    usageMessage: S.current.fundingRateThresholdUsage,
  );

  _registerUpdateCommand<int>(
    registry: registry,
    command: 'set_minutes_before_expiration',
    description: 'Set minutes before expiration for notifications',
    parser: int.parse,
    updater: (settings, value) => UserSettings(
      userId: settings.userId,
      fundingRateThreshold: settings.fundingRateThreshold,
      minutesBeforeExpiration: value,
      lastUpdated: DateTime.now(),
      languageCode: settings.languageCode,
    ),
    successMessage: S.current.minutesBeforeExpirationUpdated,
    usageMessage: S.current.minutesBeforeExpirationUsage,
  );
}

void _registerUpdateCommand<T>({
  required CommandRegistry registry,
  required String command,
  required String description,
  required T Function(String) parser,
  required UserSettings Function(UserSettings, T) updater,
  required String successMessage,
  required String usageMessage,
}) {
  registry.register(
    BotCommand(
      command: command,
      description: description,
      handler: (tele.TeleDartMessage message, userRole) async {
        final getUserSettings = sl<GetUserSettings>();
        final saveUserSettings = sl<SaveUserSettings>();
        final userId = message.chat.id.toString();
        final settings = await getUserSettings(userId);
        final text = message.text;

        if (settings != null && text != null) {
          final parts = text.split(' ');
          if (parts.length == 2) {
            try {
              final value = parser(parts[1]);
              final newSettings = updater(settings, value);
              await saveUserSettings(newSettings);
              await S.load(newSettings.languageCode);
              await message.reply(successMessage);
            } catch (e) {
              await S.load(settings.languageCode);
              await message.reply(usageMessage);
            }
          } else {
            await S.load(settings.languageCode);
            await message.reply(usageMessage);
          }
        }
      },
    ),
  );
}