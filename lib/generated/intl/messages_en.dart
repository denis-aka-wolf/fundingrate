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

  static String m0(symbol, rate) => "Funding Rate Alert for ${symbol}: ${rate}";

  static String m1(lang) => "Language changed to ${lang}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "botStatus": MessageLookupByLibrary.simpleMessage(
      "I am alive and running!",
    ),
    "checkIntervalUpdated": MessageLookupByLibrary.simpleMessage(
      "Check interval updated.",
    ),
    "checkIntervalUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /set_check_interval <value>",
    ),
    "fundingRateAlert": m0,
    "fundingRateThresholdUpdated": MessageLookupByLibrary.simpleMessage(
      "Funding rate threshold updated.",
    ),
    "fundingRateThresholdUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /set_funding_rate_threshold <value>",
    ),
    "langUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /lang <language_code>",
    ),
    "languageChanged": m1,
    "minutesBeforeExpirationUpdated": MessageLookupByLibrary.simpleMessage(
      "Minutes before expiration updated.",
    ),
    "minutesBeforeExpirationUsage": MessageLookupByLibrary.simpleMessage(
      "Usage: /set_minutes_before_expiration <value>",
    ),
    "settingsNotFound": MessageLookupByLibrary.simpleMessage(
      "Settings not found. Please use the /start command to begin.",
    ),
    "unsupportedLanguage": MessageLookupByLibrary.simpleMessage(
      "Unsupported language.",
    ),
    "welcomeBackMessage": MessageLookupByLibrary.simpleMessage(
      "Welcome back! You are already set up.",
    ),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Welcome! I will notify you about funding rates.",
    ),
  };
}
