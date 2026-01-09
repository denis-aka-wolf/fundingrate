import '../../domain/entities/user.dart';
import 'bot_command.dart';

class CommandRegistry {
  final List<BotCommand> _commands = [];

  void register(BotCommand command) {
    _commands.add(command);
  }

  BotCommand? findByCommand(String command) {
    // command might be "/start" or "/start@botname"
    final commandWithoutBotName = command.split('@').first;
    return _commands.firstWhere(
      (c) => '/${c.command}' == commandWithoutBotName,
      orElse: () => _commands.firstWhere(
        (c) => c.command == command,
        orElse: () => throw Exception('Command not found'),
      ),
    );
  }

  BotCommand? findByCallbackData(String callbackData) {
    try {
      return _commands.firstWhere((c) => c.command == callbackData);
    } catch (e) {
      return null;
    }
  }

  List<BotCommand> getCommandsForRole(UserRole role) {
    return _commands.where((c) => c.canExecute(role)).toList();
  }

  List<BotCommand> getKeyboardCommandsForRole(UserRole role) {
    return _commands
        .where((c) => c.showInKeyboard && c.canExecute(role))
        .toList();
  }

  List<BotCommand> getAllCommands() {
    return List.unmodifiable(_commands);
  }
}