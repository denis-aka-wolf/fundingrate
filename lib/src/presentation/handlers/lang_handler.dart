import 'package:teledart/model.dart' as tele;
import '../../../generated/l10n.dart';
import '../../core/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../../domain/usecases/save_user_settings.dart';
import '../commands/bot_command.dart';
import '../commands/command_registry.dart';

void registerLangCommand(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'lang',
      description: 'Change language. Usage: /lang <en|ru>',
      handler: (tele.TeleDartMessage message, userRole) async {
        final getUserSettings = sl<GetUserSettings>();
        final saveUserSettings = sl<SaveUserSettings>();
        final userId = message.chat.id.toString();
        var settings = await getUserSettings(userId);
        final text = message.text;

        if (text != null) {
          final parts = text.split(' ');
          if (parts.length == 2) {
            final lang = parts[1];
            if (settings == null) {
              settings = UserSettings(
                userId: userId,
                fundingRateThreshold: 0.01,
                minutesBeforeExpiration: 30,
                lastUpdated: DateTime.now(),
                languageCode: 'en',
              );
              await saveUserSettings(settings);
            }

            if (['en', 'ru'].contains(lang)) {
              final newSettings = UserSettings(
                userId: settings.userId,
                fundingRateThreshold: settings.fundingRateThreshold,
                minutesBeforeExpiration: settings.minutesBeforeExpiration,
                lastUpdated: DateTime.now(),
                languageCode: lang,
              );
              await saveUserSettings(newSettings);
              await S.load(lang);
              await message.reply(S.current.languageChanged(lang));
            } else {
              await S.load(settings.languageCode);
              await message.reply(S.current.unsupportedLanguage);
            }
          } else {
            await S.load(settings?.languageCode ?? 'en');
            await message.reply(S.current.langUsage);
          }
        } else {
          await S.load(settings?.languageCode ?? 'en');
          await message.reply(S.current.langUsage);
        }
      },
    ),
  );
}