import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import '../../domain/entities/user.dart';

typedef CommandHandlerCallback = Future<void> Function(
    TeleDartMessage message, UserRole userRole);
typedef CallbackQueryHandlerCallback = Future<void> Function(
    CallbackQuery query, UserRole userRole);

class BotCommand {
  final String command;
  final String description;
  final UserRole requiredRole;
  final CommandHandlerCallback? handler;
  final CallbackQueryHandlerCallback? callbackHandler;
  final bool showInKeyboard;
  final String? keyboardButtonText;

  BotCommand({
    required this.command,
    required this.description,
    this.requiredRole = UserRole.user,
    this.handler,
    this.callbackHandler,
    this.showInKeyboard = false,
    this.keyboardButtonText,
  }) {
    if (showInKeyboard && keyboardButtonText == null) {
      throw ArgumentError(
          'keyboardButtonText must be provided if showInKeyboard is true.');
    }
    if (handler == null && callbackHandler == null) {
      throw ArgumentError('At least one handler must be provided.');
    }
  }

  bool canExecute(UserRole userRole) {
    return userRole.index >= requiredRole.index;
  }
}