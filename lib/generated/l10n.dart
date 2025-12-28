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
    final localeName = Intl.canonicalizedLocale(locale);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(dynamic context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(dynamic context) {
    return null;
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

  /// `Check interval updated.`
  String get checkIntervalUpdated {
    return Intl.message(
      'Check interval updated.',
      name: 'checkIntervalUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Usage: /set_check_interval <value>`
  String get checkIntervalUsage {
    return Intl.message(
      'Usage: /set_check_interval <value>',
      name: 'checkIntervalUsage',
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
