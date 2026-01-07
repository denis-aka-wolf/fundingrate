import 'package:teledart/model.dart' as tele;
import '../../../generated/l10n.dart';
import '../../core/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/config_and_roles_usecases.dart';
import '../commands/bot_command.dart';
import '../commands/command_registry.dart';

void registerRoleCommands(CommandRegistry registry) {
  _registerAddAdmin(registry);
  _registerDelAdmin(registry);
  _registerAddModerator(registry);
  _registerDelModerator(registry);
}

int? _getUserIdFromMessage(tele.TeleDartMessage message) {
  if (message.replyToMessage != null) {
    return message.replyToMessage!.from!.id;
  }
  final parts = message.text!.split(' ');
  if (parts.length == 2) {
    return int.tryParse(parts[1]);
  }
  return null;
}

void _registerAddAdmin(CommandRegistry registry) {
  registry.register(
    BotCommand(
        command: 'add_admin',
        description: 'Promote user to admin',
        requiredRole: UserRole.admin,
        handler: (message, userRole) async {
          final addRole = sl<AddRole>();
          final userId = _getUserIdFromMessage(message);
          if (userId != null) {
            await addRole(userId, UserRole.admin);
            await message
                .reply(S.current.userPromotedToAdmin(userId.toString()));
          } else {
            await message.reply(S.current.specifyUser);
          }
        },
        showInKeyboard: true,
        keyboardButtonText: 'Add Admin'),
  );
}

void _registerDelAdmin(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'del_admin',
      description: 'Demote user from admin',
      requiredRole: UserRole.admin,
      handler: (message, userRole) async {
        final removeRole = sl<RemoveRole>();
        final userId = _getUserIdFromMessage(message);
        if (userId != null) {
          await removeRole(userId, UserRole.admin);
          await message.reply(S.current.userDemotedFromAdmin(userId.toString()));
        } else {
          await message.reply(S.current.specifyUser);
        }
      },
    ),
  );
}

void _registerAddModerator(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'add_moderator',
      description: 'Promote user to moderator',
      requiredRole: UserRole.admin,
      handler: (message, userRole) async {
        final addRole = sl<AddRole>();
        final userId = _getUserIdFromMessage(message);
        if (userId != null) {
          await addRole(userId, UserRole.moderator);
          await message.reply(S.current.userPromotedToModerator(userId.toString()));
        } else {
          await message.reply(S.current.specifyUser);
        }
      },
    ),
  );
}

void _registerDelModerator(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'del_moderator',
      description: 'Demote user from moderator',
      requiredRole: UserRole.admin,
      handler: (message, userRole) async {
        final removeRole = sl<RemoveRole>();
        final userId = _getUserIdFromMessage(message);
        if (userId != null) {
          await removeRole(userId, UserRole.moderator);
          await message.reply(S.current.userDemotedFromModerator(userId.toString()));
        } else {
          await message.reply(S.current.specifyUser);
        }
      },
    ),
  );
}