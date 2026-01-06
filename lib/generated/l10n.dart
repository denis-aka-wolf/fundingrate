// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }


  static const List<String> supportedLocales = ['en', 'ru'];

  static Future<S> load(String locale) {
    final name = supportedLocales.contains(locale) ? locale : 'en';
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  /// `Welcome! I will notify you about high funding rates.`
  String get welcomeMessage {
    return Intl.message(
      'Welcome! I will notify you about high funding rates.',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get welcomeBackMessage {
    return Intl.message(
      'Welcome back!',
      name: 'welcomeBackMessage',
      desc: '',
      args: [],
    );
  }

  /// `Settings not found. Please use /start to initialize your settings.`
  String get settingsNotFound {
    return Intl.message(
      'Settings not found. Please use /start to initialize your settings.',
      name: 'settingsNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Bot is running.`
  String get botStatus {
    return Intl.message(
      'Bot is running.',
      name: 'botStatus',
      desc: '',
      args: [],
    );
  }

  /// `Language changed to {lang}`
  String languageChanged(Object lang) {
    return Intl.message(
      'Language changed to $lang',
      name: 'languageChanged',
      desc: '',
      args: [lang],
    );
  }

  /// `Unsupported language.`
  String get unsupportedLanguage {
    return Intl.message(
      'Unsupported language.',
      name: 'unsupportedLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Usage: /lang <language_code>`
  String get langUsage {
    return Intl.message(
      'Usage: /lang <language_code>',
      name: 'langUsage',
      desc: '',
      args: [],
    );
  }

  /// `Funding rate threshold updated.`
  String get fundingRateThresholdUpdated {
    return Intl.message(
      'Funding rate threshold updated.',
      name: 'fundingRateThresholdUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Usage: /set_funding_rate_threshold <value>`
  String get fundingRateThresholdUsage {
    return Intl.message(
      'Usage: /set_funding_rate_threshold <value>',
      name: 'fundingRateThresholdUsage',
      desc: '',
      args: [],
    );
  }

  /// `Minutes before expiration updated.`
  String get minutesBeforeExpirationUpdated {
    return Intl.message(
      'Minutes before expiration updated.',
      name: 'minutesBeforeExpirationUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Usage: /set_minutes_before_expiration <value>`
  String get minutesBeforeExpirationUsage {
    return Intl.message(
      'Usage: /set_minutes_before_expiration <value>',
      name: 'minutesBeforeExpirationUsage',
      desc: '',
      args: [],
    );
  }

  /// `High funding rate for {symbol}: {fundingRate}`
  String fundingRateAlert(Object symbol, Object fundingRate) {
    return Intl.message(
      'High funding rate for $symbol: $fundingRate',
      name: 'fundingRateAlert',
      desc: '',
      args: [symbol, fundingRate],
    );
  }

  /// `Access denied.`
  String get accessDenied {
    return Intl.message(
      'Access denied.',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `User {userId} is now an admin.`
  String userPromotedToAdmin(Object userId) {
    return Intl.message(
      'User $userId is now an admin.',
      name: 'userPromotedToAdmin',
      desc: '',
      args: [userId],
    );
  }

  /// `User {userId} is now a moderator.`
  String userPromotedToModerator(Object userId) {
    return Intl.message(
      'User $userId is now a moderator.',
      name: 'userPromotedToModerator',
      desc: '',
      args: [userId],
    );
  }

  /// `User {userId} is no longer an admin.`
  String userDemotedFromAdmin(Object userId) {
    return Intl.message(
      'User $userId is no longer an admin.',
      name: 'userDemotedFromAdmin',
      desc: '',
      args: [userId],
    );
  }

  /// `User {userId} is no longer a moderator.`
  String userDemotedFromModerator(Object userId) {
    return Intl.message(
      'User $userId is no longer a moderator.',
      name: 'userDemotedFromModerator',
      desc: '',
      args: [userId],
    );
  }

  /// `Please specify a user ID or reply to a message.`
  String get specifyUser {
    return Intl.message(
      'Please specify a user ID or reply to a message.',
      name: 'specifyUser',
      desc: '',
      args: [],
    );
  }

  /// `Admins: {userIds}`
  String adminsList(Object userIds) {
    return Intl.message(
      'Admins: $userIds',
      name: 'adminsList',
      desc: '',
      args: [userIds],
    );
  }

  /// `Moderators: {userIds}`
  String moderatorsList(Object userIds) {
    return Intl.message(
      'Moderators: $userIds',
      name: 'moderatorsList',
      desc: '',
      args: [userIds],
    );
  }

  /// `Setting {key} updated to {value}.`
  String settingUpdated(Object key, Object value) {
    return Intl.message(
      'Setting $key updated to $value.',
      name: 'settingUpdated',
      desc: '',
      args: [key, value],
    );
  }

  /// `Failed to update setting {key}.`
  String settingUpdateFailed(Object key) {
    return Intl.message(
      'Failed to update setting $key.',
      name: 'settingUpdateFailed',
      desc: '',
      args: [key],
    );
  }

  /// `Usage: /set <KEY> <VALUE>`
  String get setUsage {
    return Intl.message(
      'Usage: /set <KEY> <VALUE>',
      name: 'setUsage',
      desc: '',
      args: [],
    );
  }

  /// `Hello! I am a bot that tracks funding rates for various cryptocurrency pairs on Bybit. I can notify you when rates exceed a specified threshold.`
  String get welcomeMessageDetailed {
    return Intl.message(
      'Hello! I am a bot that tracks funding rates for various cryptocurrency pairs on Bybit. I can notify you when rates exceed a specified threshold.',
      name: 'welcomeMessageDetailed',
      desc: '',
      args: [],
    );
  }

  /// `Available commands:`
  String get availableCommands {
    return Intl.message(
      'Available commands:',
      name: 'availableCommands',
      desc: '',
      args: [],
    );
  }

  /// `- /start - Start the bot\n- /settings - View current settings\n- /status - Check bot status\n- /lang <language_code> - Change language\n- /set_funding_rate_threshold <value> - Set funding rate threshold\n- /set_minutes_before_expiration <value> - Set minutes before expiration`
  String get userCommands {
    return Intl.message(
      '- /start - Start the bot\n- /settings - View current settings\n- /status - Check bot status\n- /lang <language_code> - Change language\n- /set_funding_rate_threshold <value> - Set funding rate threshold\n- /set_minutes_before_expiration <value> - Set minutes before expiration',
      name: 'userCommands',
      desc: '',
      args: [],
    );
  }

  /// `- /add_admin <user_id> - Promote user to admin\n- /add_moderator <user_id> - Promote user to moderator\n- /del_admin <user_id> - Demote user from admin\n- /del_moderator <user_id> - Demote user from moderator\n- /users_admin - List all admins\n- /users_moderator - List all moderators`
  String get adminCommands {
    return Intl.message(
      '- /add_admin <user_id> - Promote user to admin\n- /add_moderator <user_id> - Promote user to moderator\n- /del_admin <user_id> - Demote user from admin\n- /del_moderator <user_id> - Demote user from moderator\n- /users_admin - List all admins\n- /users_moderator - List all moderators',
      name: 'adminCommands',
      desc: '',
      args: [],
    );
  }

  /// `- /settings_app - Show current application settings\n- /set <parameter> <value> - Change application setting`
  String get moderatorCommands {
    return Intl.message(
      '- /settings_app - Show current application settings\n- /set <parameter> <value> - Change application setting',
      name: 'moderatorCommands',
      desc: '',
      args: [],
    );
  }
}

