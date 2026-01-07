import 'package:teledart/model.dart' as tele;
import '../../../generated/l10n.dart';
import '../../core/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../commands/bot_command.dart';
import '../commands/command_registry.dart';

void registerSettingsCommand(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'settings',
      description: 'Show your current settings',
      handler: (tele.TeleDartMessage message, userRole) async {
        final getUserSettings = sl<GetUserSettings>();
        final userId = message.chat.id.toString();
        final settings = await getUserSettings(userId);
        if (settings != null) {
          await message.reply(settings.toString());
        } else {
          await S.load(message.from?.languageCode ?? 'en');
          await message.reply(S.current.settingsNotFound);
        }
      },
    ),
  );
}