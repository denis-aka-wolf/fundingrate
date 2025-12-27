import 'package:flutter/material.dart';
import 'package:fundingrate/generated/l10n.dart';
import 'package:fundingrate/src/domain/entities/user_settings.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:fundingrate/src/domain/usecases/get_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/save_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/get_all_user_ids.dart';
import 'package:fundingrate/src/domain/usecases/get_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/check_funding_rates.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:test/test.dart';
import 'dart:async';

import 'bot_test.mocks.dart';

// FAKE TeleDart for testing
class FakeTeleDart implements TeleDart {
  final _commandControllers = <String, StreamController<TeleDartMessage>>{};
  final MockTelegram _telegram;

  FakeTeleDart(this._telegram);

  @override
  Stream<TeleDartMessage> onCommand([dynamic command]) {
    if (command is String) {
      return _commandControllers.putIfAbsent(command, () => StreamController<TeleDartMessage>()).stream;
    }
    // This case is for onMessage without a specific command, which we are not testing here.
    return Stream.empty();
  }

  void sendCommand(String command, TeleDartMessage message) {
    _commandControllers[command]?.add(message);
  }
  
  @override
  Future<bool> start() async => true;

  @override
  Telegram get telegram => _telegram;

  // Add other required methods and properties from TeleDart interface, returning default values
  @override
  dynamic noSuchMethod(Invocation invocation) {
    print('Called noSuchMethod for ${invocation.memberName}');
    return super.noSuchMethod(invocation);
  }
}


@GenerateMocks([
  GetUserSettings,
  SaveUserSettings,
  GetAllUserIds,
  GetFundingRates,
  CheckFundingRates,
  Telegram,
  Message,
  Chat,
  User,
], customMocks: [
  MockSpec<TeleDartMessage>(as: #MockTeleDartMessage),
])
void main() {
  late FundingRateBot bot;
  late MockGetUserSettings mockGetUserSettings;
  late MockSaveUserSettings mockSaveUserSettings;
  late MockGetAllUserIds mockGetAllUserIds;
  late MockGetFundingRates mockGetFundingRates;
  late MockCheckFundingRates mockCheckFundingRates;
  late FakeTeleDart fakeTeleDart;
  late MockTelegram mockTelegram;

  setUp(() async {
    mockGetUserSettings = MockGetUserSettings();
    mockSaveUserSettings = MockSaveUserSettings();
    mockGetAllUserIds = MockGetAllUserIds();
    mockGetFundingRates = MockGetFundingRates();
    mockCheckFundingRates = MockCheckFundingRates();
    mockTelegram = MockTelegram();
    fakeTeleDart = FakeTeleDart(mockTelegram);

    bot = FundingRateBot(
      getUserSettings: mockGetUserSettings,
      saveUserSettings: mockSaveUserSettings,
      getAllUserIds: mockGetAllUserIds,
      getFundingRates: mockGetFundingRates,
      checkFundingRates: mockCheckFundingRates,
      teledart: fakeTeleDart,
    );

    await S.load(const Locale('en'));
    
    // Call start to register handlers
    await bot.start();
  });

  MockTeleDartMessage createMockMessage(int chatId, String langCode, {String? text}) {
    final mockMessage = MockTeleDartMessage();
    final mockChat = MockChat();
    final mockUser = MockUser();
    
    when(mockMessage.chat).thenReturn(mockChat);
    when(mockChat.id).thenReturn(chatId);
    when(mockMessage.from).thenReturn(mockUser);
    when(mockUser.languageCode).thenReturn(langCode);
    if (text != null) {
      when(mockMessage.text).thenReturn(text);
    }
    when(mockMessage.reply(any)).thenAnswer((_) async => mockMessage);
    
    return mockMessage;
  }

  group('/start command', () {
    test('should save new user and send welcome message', () async {
      // Arrange
      final mockMessage = createMockMessage(123, 'en');
      when(mockGetUserSettings('123')).thenAnswer((_) async => null);
      when(mockSaveUserSettings(any)).thenAnswer((_) async {});

      // Act
      fakeTeleDart.sendCommand('start', mockMessage);
      
      // Assert
      await untilCalled(mockMessage.reply(S.current.welcomeMessage));
      verify(mockGetUserSettings('123')).called(1);
      final captured = verify(mockSaveUserSettings(captureAny)).captured.single as UserSettings;
      expect(captured.userId, '123');
    });

    test('should send welcome back message to existing user', () async {
      // Arrange
      final mockMessage = createMockMessage(123, 'en');
      final existingSettings = UserSettings(userId: '123', fundingRateThreshold: 0, minutesBeforeExpiration: 0, checkIntervalMinutes: 0, lastUpdated: DateTime.now(), languageCode: 'en');
      when(mockGetUserSettings('123')).thenAnswer((_) async => existingSettings);

      // Act
      fakeTeleDart.sendCommand('start', mockMessage);

      // Assert
      await untilCalled(mockMessage.reply(S.current.welcomeBackMessage));
      verify(mockGetUserSettings('123')).called(1);
      verifyNever(mockSaveUserSettings(any));
    });
  });
}