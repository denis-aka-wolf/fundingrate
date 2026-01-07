import 'package:fundingrate/generated/l10n.dart';
import 'package:fundingrate/src/domain/entities/user_settings.dart';
import 'package:fundingrate/src/presentation/bot.dart';
import 'package:fundingrate/src/domain/usecases/get_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/save_user_settings.dart';
import 'package:fundingrate/src/domain/usecases/get_all_user_ids.dart';
import 'package:fundingrate/src/domain/usecases/get_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/check_funding_rates.dart';
import 'package:fundingrate/src/domain/usecases/config_and_roles_usecases.dart';
import 'package:fundingrate/src/presentation/commands/command_registry.dart';
import 'package:fundingrate/src/presentation/keyboards/keyboard_provider.dart';
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
  final _messageController = StreamController<TeleDartMessage>.broadcast();
  final _callbackQueryController = StreamController<TeleDartCallbackQuery>.broadcast();
  final MockTelegram _telegram;

  FakeTeleDart(this._telegram);

  @override
  Stream<TeleDartMessage> onMessage({String? entityType, dynamic keyword}) {
    return _messageController.stream;
  }

  @override
  Stream<TeleDartCallbackQuery> onCallbackQuery() {
    return _callbackQueryController.stream;
  }

  void sendCallbackQuery(TeleDartCallbackQuery query) {
    _callbackQueryController.add(query);
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

@GenerateMocks(
  [
    GetUserSettings,
    SaveUserSettings,
    GetAllUserIds,
    GetFundingRates,
    CheckFundingRates,
    GetRole,
    CommandRegistry,
    IKeyboardProvider,
    Telegram,
    Message,
    Chat,
    User,
  ],
  customMocks: [MockSpec<TeleDartMessage>(as: #MockTeleDartMessage)],
)
void main() {
  late FundingRateBot bot;
  late MockGetUserSettings mockGetUserSettings;
  late MockSaveUserSettings mockSaveUserSettings;
  late MockGetAllUserIds mockGetAllUserIds;
  late MockGetFundingRates mockGetFundingRates;
  late MockCheckFundingRates mockCheckFundingRates;
  late MockGetRole mockGetRole;
  late MockCommandRegistry mockCommandRegistry;
  late MockIKeyboardProvider mockKeyboardProvider;
  late FakeTeleDart fakeTeleDart;
  late MockTelegram mockTelegram;

  setUp(() async {
    mockGetUserSettings = MockGetUserSettings();
    mockSaveUserSettings = MockSaveUserSettings();
    mockGetAllUserIds = MockGetAllUserIds();
    mockGetFundingRates = MockGetFundingRates();
    mockCheckFundingRates = MockCheckFundingRates();
    mockGetRole = MockGetRole();
    mockCommandRegistry = MockCommandRegistry();
    mockKeyboardProvider = MockIKeyboardProvider();
    mockTelegram = MockTelegram();
    fakeTeleDart = FakeTeleDart(mockTelegram);

    bot = FundingRateBot(
      getUserSettings: mockGetUserSettings,
      saveUserSettings: mockSaveUserSettings,
      getAllUserIds: mockGetAllUserIds,
      getFundingRates: mockGetFundingRates,
      checkFundingRates: mockCheckFundingRates,
      getRole: mockGetRole,
      checkIntervalMinutes: 5,
      keyboardProvider: mockKeyboardProvider,
      commandRegistry: mockCommandRegistry,
      teledart: fakeTeleDart,
    );

    await S.load('en');

    // Call start to register handlers
    await bot.start();
  });

  MockTeleDartMessage createMockMessage(
    int chatId,
    String langCode, {
    String? text,
  }) {
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
  
  // Tests will be added here later
}
