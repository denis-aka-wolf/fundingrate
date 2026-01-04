import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';
import 'dart:async';
import 'dart:io';
import 'package:dotenv/dotenv.dart';

import '../../generated/l10n.dart';
import '../data/datasources/user_settings_local_data_source.dart';
import '../domain/usecases/get_user_settings.dart';
import '../domain/usecases/save_user_settings.dart';
import '../domain/usecases/get_all_user_ids.dart';
import '../domain/usecases/get_funding_rates.dart';
import '../domain/usecases/check_funding_rates.dart';
import '../domain/usecases/config_and_roles_usecases.dart';
import '../domain/entities/user_settings.dart';
import '../domain/entities/user.dart';

class FundingRateBot {
  final GetUserSettings getUserSettings;
  final SaveUserSettings saveUserSettings;
  final GetAllUserIds getAllUserIds;
  final GetFundingRates getFundingRates;
 final CheckFundingRates checkFundingRates;
  final int checkIntervalMinutes;
  final GetConfig getConfig;
  final SetConfig setConfig;
  final GetRole getRole;
  final AddRole addRole;
  final RemoveRole removeRole;
  final GetAdminIds getAdminIds;
  final GetModeratorIds getModeratorIds;

  late TeleDart teledart;
  final TeleDart? _injectedTeleDart;

  FundingRateBot({
    required this.getUserSettings,
    required this.saveUserSettings,
    required this.getAllUserIds,
    required this.getFundingRates,
    required this.checkFundingRates,
    this.checkIntervalMinutes = 10,
    required this.getConfig,
    required this.setConfig,
    required this.getRole,
    required this.addRole,
    required this.removeRole,
    required this.getAdminIds,
    required this.getModeratorIds,
    TeleDart? teledart,
 }) : _injectedTeleDart = teledart;

 Future<void> start() async {
    if (_injectedTeleDart != null) {
      teledart = _injectedTeleDart!;
    } else {
      final env = DotEnv(includePlatformEnvironment: true)..load();
      final botToken = env['TELEGRAM_BOT_TOKEN']!;
      final username = (await Telegram(botToken).getMe()).username;
      teledart = TeleDart(botToken, Event(username!));
    }

    if (_injectedTeleDart == null) {
      teledart.start();
    }

    _registerCommandHandlers();
    teledart.onCallbackQuery().listen((callbackQuery) async {
      final command = callbackQuery.data;
      if (command != null) {
        final message = callbackQuery.message;
        if (message != null) {
          // We need to edit the message for the reply to work correctly
          // as if it was a command
          switch (command) {
            case 'users_admin':
              await teledart.editMessageText(
                S.current.adminsList((await getAdminIds()).join(', ')),
                chatId: message.chat.id,
                messageId: message.messageId,
              );
              break;
            case 'users_moderator':
              await teledart.editMessageText(
                S.current.moderatorsList((await getModeratorIds()).join(', ')),
                chatId: message.chat.id,
                messageId: message.messageId,
              );
              break;
            case 'settings_app':
              final config = await getConfig();
              final settingsString =
                  config.entries.map((e) => '${e.key}: ${e.value}').join('\n');
              await teledart.editMessageText(
                settingsString,
                chatId: message.chat.id,
                messageId: message.messageId,
              );
              break;
          }
        }
      }
      await teledart.answerCallbackQuery(callbackQuery.id);
    });

    print('Bot started!');

    _startFundingRateChecker();
  }

  void _registerCommandHandlers() {
    teledart.onCommand('start').listen((message) async {
      final userId = message.chat.id.toString();
      var settings = await getUserSettings(userId);
      final lang = message.from?.languageCode ?? 'en';

      if (settings == null) {
        settings = UserSettings(
          userId: userId,
          fundingRateThreshold: 0.01,
          minutesBeforeExpiration: 30,
          lastUpdated: DateTime.now(),
          languageCode: lang,
        );
        await saveUserSettings(settings);
      }

      await S.load(settings.languageCode);

      final userRole = await getRole(int.parse(userId));
      final welcomeMessage = S.current.welcomeMessageDetailed;
      final availableCommands = S.current.availableCommands;
      var commandsList = S.current.userCommands;

      InlineKeyboardMarkup? keyboard;

      if (userRole == UserRole.admin) {
        commandsList += '\n\n${S.current.adminCommands}';
        keyboard = _adminInlineKeyboard();
      } else if (userRole == UserRole.moderator) {
        commandsList += '\n\n${S.current.moderatorCommands}';
        keyboard = _moderatorInlineKeyboard();
      }

      await message.reply(
        '$welcomeMessage\n\n$availableCommands\n$commandsList',
        replyMarkup: keyboard,
      );
    });

    teledart.onCommand('settings').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      if (settings != null) {
        await message.reply(settings.toString());
      } else {
        await S.load(message.from?.languageCode ?? 'en');
        await message.reply(S.current.settingsNotFound);
      }
    });

    teledart.onCommand('status').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      await S.load(
        settings?.languageCode ?? message.from?.languageCode ?? 'en',
      );
      await message.reply(S.current.botStatus);
    });

    teledart.onCommand('lang').listen((message) async {
      final userId = message.chat.id.toString();
      final settings = await getUserSettings(userId);
      final text = message.text;

      if (settings != null && text != null) {
        final parts = text.split(' ');
        if (parts.length == 2) {
          final lang = parts[1];
          if (S.supportedLocales.contains(lang)) {
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
          await S.load(settings.languageCode);
          await message.reply(S.current.langUsage);
        }
      }
    });

    _createSettingsCommandHandler<double>(
      command: 'set_funding_rate_threshold',
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

    _createSettingsCommandHandler<int>(
      command: 'set_minutes_before_expiration',
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

    _registerAdminCommands();
    _registerModeratorCommands();
  }

  void _createSettingsCommandHandler<T>({
    required String command,
    required T Function(String) parser,
    required UserSettings Function(UserSettings, T) updater,
    required String successMessage,
    required String usageMessage,
  }) {
    teledart.onCommand(command).listen((message) async {
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
    });
  }

  void _startFundingRateChecker() {
    _checkRates();
  }

  void _checkRates() async {
    print('Starting funding rate check...');
    try {
      final userIds = await getAllUserIds();
      final rates = await getFundingRates();

      for (final userId in userIds) {
        final settings = await getUserSettings(userId);
        if (settings != null) {
          await S.load(settings.languageCode);
          final notifications = checkFundingRates(
            rates: rates,
            settings: settings,
          );

          for (final notification in notifications) {
            try {
              await teledart.sendMessage(
                userId,
                S.current.fundingRateAlert(
                  notification.symbol,
                  notification.fundingRate.toString(),
                ),
              );
            } on TeleDartException catch (e) {
              final error = e.toString();
              // User blocked the bot or chat not found, remove user settings
              if (error.contains('chat not found') ||
                  error.contains('bot was blocked by the user')) {
                print(
                    'User $userId blocked the bot or chat not found. Removing user settings.');
                final localDataSource =
                    UserSettingsLocalDataSourceImpl(Directory('settings'));
                await localDataSource.deleteSettings(userId);
              } else {
                rethrow;
              }
            }
          }
        }
      }
    } catch (e, s) {
      print('Error during funding rate check: $e');
      print(s);
    } finally {
      Future.delayed(Duration(minutes: checkIntervalMinutes), _checkRates);
    }
  }

  void _registerAdminCommands() {
    _roleCommandHandler('add_admin', UserRole.admin, _addAdmin);
    _roleCommandHandler('add_moderator', UserRole.admin, _addModerator);
    _roleCommandHandler('del_admin', UserRole.admin, _delAdmin);
    _roleCommandHandler('del_moderator', UserRole.admin, _delModerator);
    _roleCommandHandler('users_admin', UserRole.admin, _getAdmins);
    _roleCommandHandler('users_moderator', UserRole.admin, _getModerators);
  }

  void _registerModeratorCommands() {
    _roleCommandHandler('settings_app', UserRole.moderator, _getAppSettings);
    _roleCommandHandler('set', UserRole.moderator, _setAppSetting);
  }

  void _roleCommandHandler(
    String command,
    UserRole requiredRole,
    Future<void> Function(TeleDartMessage) handler,
 ) {
    teledart.onCommand(command).listen((message) async {
      final userRole = await getRole(message.from!.id);
      final settings = await getUserSettings(message.chat.id.toString());
      await S.load(
        settings?.languageCode ?? message.from?.languageCode ?? 'en',
      );
      if (userRole == requiredRole || userRole == UserRole.admin) {
        await handler(message);
      } else {
        await message.reply(S.current.accessDenied);
      }
    });
  }

  Future<void> _addAdmin(TeleDartMessage message) async {
    final userId = _getUserIdFromMessage(message);
    if (userId != null) {
      await addRole(userId, UserRole.admin);
      await message.reply(
        S.current.userPromotedToAdmin(userId.toString()),
        replyMarkup: _inlineKeyboard(),
      );
    } else {
      await message.reply(S.current.specifyUser);
    }
  }

  Future<void> _addModerator(TeleDartMessage message) async {
    final userId = _getUserIdFromMessage(message);
    if (userId != null) {
      await addRole(userId, UserRole.moderator);
      await message.reply(
        S.current.userPromotedToModerator(userId.toString()),
        replyMarkup: _inlineKeyboard(),
      );
    } else {
      await message.reply(S.current.specifyUser);
    }
  }

  Future<void> _delAdmin(TeleDartMessage message) async {
    final userId = _getUserIdFromMessage(message);
    if (userId != null) {
      await removeRole(userId, UserRole.admin);
      await message.reply(
        S.current.userDemotedFromAdmin(userId.toString()),
        replyMarkup: _inlineKeyboard(),
      );
    } else {
      await message.reply(S.current.specifyUser);
    }
  }

  Future<void> _delModerator(TeleDartMessage message) async {
    final userId = _getUserIdFromMessage(message);
    if (userId != null) {
      await removeRole(userId, UserRole.moderator);
      await message.reply(
        S.current.userDemotedFromModerator(userId.toString()),
        replyMarkup: _inlineKeyboard(),
      );
    } else {
      await message.reply(S.current.specifyUser);
    }
  }

  Future<void> _getAdmins(TeleDartMessage message) async {
    final adminIds = await getAdminIds();
    await message.reply(
      S.current.adminsList(adminIds.join(', ')),
      replyMarkup: _inlineKeyboard(),
    );
  }

  Future<void> _getModerators(TeleDartMessage message) async {
    final moderatorIds = await getModeratorIds();
    await message.reply(
      S.current.moderatorsList(moderatorIds.join(', ')),
      replyMarkup: _inlineKeyboard(),
    );
  }

  int? _getUserIdFromMessage(TeleDartMessage message) {
    if (message.replyToMessage != null) {
      return message.replyToMessage!.from!.id;
    }
    final parts = message.text!.split(' ');
    if (parts.length == 2) {
      return int.tryParse(parts[1]);
    }
    return null;
  }

  Future<void> _getAppSettings(TeleDartMessage message) async {
    final config = await getConfig();
    final settingsString =
        config.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    await message.reply(settingsString, replyMarkup: _inlineKeyboard());
  }

  Future<void> _setAppSetting(TeleDartMessage message) async {
    final parts = message.text!.split(' ');
    if (parts.length == 3) {
      final key = parts[1];
      final value = parts[2];
      final success = await setConfig(key, value);
      if (success) {
        await message.reply('Setting $key updated to $value.');
      } else {
        await message.reply('Failed to update setting $key.');
      }
    } else {
      await message.reply('Usage: /set <KEY> <VALUE>');
    }
 }

  InlineKeyboardMarkup _inlineKeyboard() {
    return InlineKeyboardMarkup(
      inlineKeyboard: [
        [
          InlineKeyboardButton(
            text: 'Admins',
            callbackData: 'users_admin',
          ),
          InlineKeyboardButton(
            text: 'Moderators',
            callbackData: 'users_moderator',
          ),
          InlineKeyboardButton(
            text: 'Settings',
            callbackData: 'settings_app',
          ),
        ],
      ],
    );
  }

  InlineKeyboardMarkup _adminInlineKeyboard() {
    return InlineKeyboardMarkup(
      inlineKeyboard: [
        [
          InlineKeyboardButton(
            text: 'Admins',
            callbackData: 'users_admin',
          ),
          InlineKeyboardButton(
            text: 'Moderators',
            callbackData: 'users_moderator',
          ),
          InlineKeyboardButton(
            text: 'Settings',
            callbackData: 'settings_app',
          ),
        ],
        [
          InlineKeyboardButton(
            text: 'Add Admin',
            callbackData: 'add_admin',
          ),
          InlineKeyboardButton(
            text: 'Add Moderator',
            callbackData: 'add_moderator',
          ),
        ],
      ],
    );
  }

  InlineKeyboardMarkup _moderatorInlineKeyboard() {
    return InlineKeyboardMarkup(
      inlineKeyboard: [
        [
          InlineKeyboardButton(
            text: 'Admins',
            callbackData: 'users_admin',
          ),
          InlineKeyboardButton(
            text: 'Moderators',
            callbackData: 'users_moderator',
          ),
          InlineKeyboardButton(
            text: 'Settings',
            callbackData: 'settings_app',
          ),
        ],
      ],
    );
  }
}
