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

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(String locale) {
    final name = locale;
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  /// `Welcome! I will notify you about funding rates.`
  String get welcomeMessage {
    return Intl.message(
      'Welcome! I will notify you about funding rates.',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! You are already set up.`
  String get welcomeBackMessage {
    return Intl.message(
      'Welcome back! You are already set up.',
      name: 'welcomeBackMessage',
      desc: '',
      args: [],
    );
  }

  /// `Settings not found. Please use the /start command to begin.`
  String get settingsNotFound {
    return Intl.message(
      'Settings not found. Please use the /start command to begin.',
      name: 'settingsNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Funding Rate Alert for {symbol}: {rate}`
  String fundingRateAlert(Object symbol, Object rate) {
    return Intl.message(
      'Funding Rate Alert for $symbol: $rate',
      name: 'fundingRateAlert',
      desc: '',
      args: [symbol, rate],
    );
  }

  /// `I am alive and running!`
  String get botStatus {
    return Intl.message(
      'I am alive and running!',
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
}

class AppLocalizationDelegate {
  const AppLocalizationDelegate();

  List<String> get supportedLocales {
    return const <String>[
      'en',
      'ru',
    ];
  }

  bool isSupported(String locale) => _isSupported(locale);
  Future<S> load(String locale) => S.load(locale);
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(String locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale == locale) {
        return true;
      }
    }
    return false;
  }
}
