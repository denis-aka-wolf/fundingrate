import 'package:teledart/model.dart' as tele;
import '../../../generated/l10n.dart';
import '../../core/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../commands/bot_command.dart';
import '../commands/command_registry.dart';

void registerStatusHandler(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'status',
      description: 'Check bot status',
      handler: (tele.TeleDartMessage message, userRole) async {
        final getUserSettings = sl<GetUserSettings>();
        final userId = message.chat.id.toString();
        final settings = await getUserSettings(userId);
        await S.load(
          settings?.languageCode ?? message.from?.languageCode ?? 'en',
        );
        try {
          await message.reply(S.current.botStatus);
        } catch (e) {
          await message.reply('Bot is running.');
        }
      },
    ),
  );
}