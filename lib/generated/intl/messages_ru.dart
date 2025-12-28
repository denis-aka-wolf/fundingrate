// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(symbol, rate) =>
      "Оповещение о ставке финансирования для ${symbol}: ${rate}";

  static String m1(lang) => "Язык изменен на ${lang}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "botStatus": MessageLookupByLibrary.simpleMessage("Я жив и работаю!"),
    "checkIntervalUpdated": MessageLookupByLibrary.simpleMessage(
      "Интервал проверки обновлен.",
    ),
    "checkIntervalUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /set_check_interval <value>",
    ),
    "fundingRateAlert": m0,
    "fundingRateThresholdUpdated": MessageLookupByLibrary.simpleMessage(
      "Порог ставки финансирования обновлен.",
    ),
    "fundingRateThresholdUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /set_funding_rate_threshold <value>",
    ),
    "langUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /lang <language_code>",
    ),
    "languageChanged": m1,
    "minutesBeforeExpirationUpdated": MessageLookupByLibrary.simpleMessage(
      "Количество минут до истечения срока обновлено.",
    ),
    "minutesBeforeExpirationUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /set_minutes_before_expiration <value>",
    ),
    "settingsNotFound": MessageLookupByLibrary.simpleMessage(
      "Настройки не найдены. Пожалуйста, используйте команду /start, чтобы начать.",
    ),
    "unsupportedLanguage": MessageLookupByLibrary.simpleMessage(
      "Неподдерживаемый язык.",
    ),
    "welcomeBackMessage": MessageLookupByLibrary.simpleMessage(
      "С возвращением! Вы уже настроены.",
    ),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Добро пожаловать! Я буду уведомлять вас о ставках финансирования.",
    ),
  };
}
