import 'package:teledart/model.dart';
import '../../domain/entities/user.dart';
import '../commands/command_registry.dart';

abstract class IKeyboardProvider {
  InlineKeyboardMarkup? getKeyboard(UserRole role);
}

class KeyboardProvider implements IKeyboardProvider {
  final CommandRegistry commandRegistry;

  KeyboardProvider({required this.commandRegistry});

  @override
  InlineKeyboardMarkup? getKeyboard(UserRole role) {
    final commands = commandRegistry.getKeyboardCommandsForRole(role);

    if (commands.isEmpty) {
      return null;
    }

    // Группируем кнопки по 3 в ряду
    final List<List<InlineKeyboardButton>> keyboard = [];
    List<InlineKeyboardButton> row = [];
    for (final command in commands) {
      row.add(InlineKeyboardButton(
        text: command.keyboardButtonText!,
        callbackData: command.command,
      ));
      if (row.length == 3) {
        keyboard.add(row);
        row = [];
      }
    }
    if (row.isNotEmpty) {
      keyboard.add(row);
    }

    return InlineKeyboardMarkup(inlineKeyboard: keyboard);
  }
}