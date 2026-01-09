import 'package:teledart/model.dart' as tele;
import 'package:teledart/teledart.dart';
import '../../core/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../../domain/usecases/save_user_settings.dart';
import '../../../generated/l10n.dart';
import '../commands/bot_command.dart';
import '../commands/command_registry.dart';
import '../keyboards/keyboard_provider.dart';

void registerStartCommand(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'start',
      description: 'Start using the bot',
      requiredRole: UserRole.user,
      handler: (tele.TeleDartMessage message, userRole) async {
        final getUserSettings = sl<GetUserSettings>();
        final saveUserSettings = sl<SaveUserSettings>();
        final keyboardProvider = sl<IKeyboardProvider>();

        final userId = message.chat.id.toString();
        var settings = await getUserSettings(userId);
        final telegramLang = message.from?.languageCode ?? 'en';

        if (settings == null) {
          settings = UserSettings(
            userId: userId,
            fundingRateThreshold: 0.01,
            minutesBeforeExpiration: 30,
            lastUpdated: DateTime.now(),
            languageCode: telegramLang,
          );
          await saveUserSettings(settings);
        }

        await S.load(settings.languageCode);

        final welcomeMessage = S.current.welcomeMessageDetailed;
        final availableCommands = S.current.availableCommands;

        final commandRegistry = sl<CommandRegistry>();
        final commandsForRole = commandRegistry.getCommandsForRole(userRole);
        final commandsList = commandsForRole
            .map((c) => '/${c.command} - ${c.description}')
            .join('\n');

        final keyboard = keyboardProvider.getKeyboard(userRole);

        await sl<TeleDart>().sendMessage(
          message.chat.id,
          '$welcomeMessage\n\n$availableCommands\n$commandsList',
          replyMarkup: keyboard,
        );
      },
    ),
  );
}