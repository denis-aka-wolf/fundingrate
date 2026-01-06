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

  static String m0(userIds) => "Администраторы: ${userIds}";

  static String m1(symbol, fundingRate) =>
      "Высокая ставка финансирования для ${symbol}: ${fundingRate}";

  static String m2(lang) => "Язык изменен на ${lang}";

  static String m3(userIds) => "Модераторы: ${userIds}";

  static String m6(userId) => "Пользователь ${userId} больше не администратор.";

  static String m7(userId) => "Пользователь ${userId} больше не модератор.";

  static String m8(userId) => "Пользователь ${userId} теперь администратор.";

  static String m9(userId) => "Пользователь ${userId} теперь модератор.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accessDenied": MessageLookupByLibrary.simpleMessage("Доступ запрещен."),
    "adminCommands": MessageLookupByLibrary.simpleMessage(
      "- /add_admin <user_id> - назначить пользователя администратором\n- /add_moderator <user_id> - назначить пользователя модератором\n- /del_admin <user_id> - лишить пользователя прав администратора\n- /del_moderator <user_id> - лишить пользователя прав модератора\n- /users_admin - список всех администраторов\n- /users_moderator - список всех модераторов",
    ),
    "adminsList": m0,
    "availableCommands": MessageLookupByLibrary.simpleMessage(
      "Доступные команды:",
    ),
    "botStatus": MessageLookupByLibrary.simpleMessage("Бот запущен."),
    "fundingRateAlert": m1,
    "fundingRateThresholdUpdated": MessageLookupByLibrary.simpleMessage(
      "Порог ставки финансирования обновлен.",
    ),
    "fundingRateThresholdUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /set_funding_rate_threshold <значение>",
    ),
    "langUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /lang <код_языка>",
    ),
    "languageChanged": m2,
    "minutesBeforeExpirationUpdated": MessageLookupByLibrary.simpleMessage(
      "Количество минут до истечения срока обновлено.",
    ),
    "minutesBeforeExpirationUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /set_minutes_before_expiration <значение>",
    ),
    "moderatorCommands": MessageLookupByLibrary.simpleMessage(
      "- /settings_app - показать текущие настройки приложения\n- /set <parameter> <value> - изменить настройку приложения",
    ),
    "moderatorsList": m3,
    "setUsage": MessageLookupByLibrary.simpleMessage(
      "Использование: /set <KEY> <VALUE>",
    ),
    "settingsNotFound": MessageLookupByLibrary.simpleMessage(
      "Настройки не найдены. Пожалуйста, используйте /start для инициализации.",
    ),
    "specifyUser": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, укажите ID пользователя или ответьте на сообщение.",
    ),
    "unsupportedLanguage": MessageLookupByLibrary.simpleMessage(
      "Неподдерживаемый язык.",
    ),
    "userCommands": MessageLookupByLibrary.simpleMessage(
      "- /start - начать работу с ботом\n- /settings - посмотреть текущие настройки\n- /status - проверить статус бота\n- /lang <language_code> - изменить язык\n- /set_funding_rate_threshold <value> - установить порог ставки финансирования\n- /set_minutes_before_expiration <value> - установить количество минут до истечения срока",
    ),
    "userDemotedFromAdmin": m6,
    "userDemotedFromModerator": m7,
    "userPromotedToAdmin": m8,
    "userPromotedToModerator": m9,
    "welcomeBackMessage": MessageLookupByLibrary.simpleMessage(
      "С возвращением!",
    ),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Добро пожаловать! Я буду уведомлять вас о высоких ставках финансирования.",
    ),
    "welcomeMessageDetailed": MessageLookupByLibrary.simpleMessage(
      "Привет! Я бот, который отслеживает ставки финансирования для различных криптовалютных пар на Bybit. Я могу уведомлять вас, когда ставки превышают заданный порог.",
    ),
  };
}
