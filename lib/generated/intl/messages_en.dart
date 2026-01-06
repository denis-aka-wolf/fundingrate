// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(userIds) => "Admins: ${userIds}";

  static String m1(symbol, fundingRate) =>
      "High funding rate for ${symbol}: ${fundingRate}";

  static String m2(lang) => "Language changed to ${lang}";

  static String m3(userIds) => "Moderators: ${userIds}";

  static String m4(key) => "Failed to update setting ${key}.";

  static String m5(key, value) => "Setting ${key} updated to ${value}.";

  static String m6(userId) => "User ${userId} is no longer an admin.";

  static String m7(userId) => "User ${userId} is no longer a moderator.";

  static String m8(userId) => "User ${userId} is now an admin.";

  static String m9(userId) => "User ${userId} is now a moderator.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accessDenied": MessageLookupByLibrary.simpleMessage("Access denied."),
    "adminCommands": MessageLookupByLibrary.simpleMessage(
      "- /add_admin <user_id> - Promote user to admin\n- /add_moderator <user_id> - Promote user to moderator\n- /del_admin <user_id> - Demote user from admin\n- /del_moderator <user_id> - Demote user from moderator\n- /users_admin - List all admins\n- /users_moderator - List all moderators",
    ),
    "adminsList": m0,
    "availableCommands": MessageLookupByLibrary.simpleMessage(
      "Available commands:",
    ),
    "botStatus": MessageLookupByLibrary.simpleMessage("Bot is running."),
    "fundingRateAlert": m1,
    "fundingRateThresholdUpdated": MessageLookupByLibrary.simpleMessage(
      "Funding rate threshold updated.",
    ),
    "fundingRateThresholdUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /set_funding_rate_threshold <value>",
    ),
    "langUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /lang <language_code>",
    ),
    "languageChanged": m2,
    "minutesBeforeExpirationUpdated": MessageLookupByLibrary.simpleMessage(
      "Minutes before expiration updated.",
    ),
    "minutesBeforeExpirationUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /set_minutes_before_expiration <value>",
    ),
    "moderatorCommands": MessageLookupByLibrary.simpleMessage(
      "- /settings_app - Show current application settings\n- /set <parameter> <value> - Change application setting",
    ),
    "moderatorsList": m3,
    "setUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /set <KEY> <VALUE>",
    ),
    "settingUpdateFailed": m4,
    "settingUpdated": m5,
    "settingsNotFound": MessageLookupByLibrary.simpleMessage(
      "Settings not found. Please use /start to initialize your settings.",
    ),
    "specifyUser": MessageLookupByLibrary.simpleMessage(
      "Please specify a user ID or reply to a message.",
    ),
    "unsupportedLanguage": MessageLookupByLibrary.simpleMessage(
      "Unsupported language.",
    ),
    "userCommands": MessageLookupByLibrary.simpleMessage(
      "- /start - Start the bot\n- /settings - View current settings\n- /status - Check bot status\n- /lang <language_code> - Change language\n- /set_funding_rate_threshold <value> - Set funding rate threshold\n- /set_minutes_before_expiration <value> - Set minutes before expiration",
    ),
    "userDemotedFromAdmin": m6,
    "userDemotedFromModerator": m7,
    "userPromotedToAdmin": m8,
    "userPromotedToModerator": m9,
    "welcomeBackMessage": MessageLookupByLibrary.simpleMessage("Welcome back!"),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Welcome! I will notify you about high funding rates.",
    ),
    "welcomeMessageDetailed": MessageLookupByLibrary.simpleMessage(
      "Hello! I am a bot that tracks funding rates for various cryptocurrency pairs on Bybit. I can notify you when rates exceed a specified threshold.",
    ),
  };
}
