import 'package:fundingrate/src/data/datasources/user_settings_local_data_source.dart';
import 'package:fundingrate/src/data/repositories/user_settings_repository_impl.dart';
import 'package:fundingrate/src/domain/entities/user_settings.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'user_settings_repository_impl_test.mocks.dart';

@GenerateMocks([UserSettingsLocalDataSource])
void main() {
  late UserSettingsRepositoryImpl repository;
  late MockUserSettingsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockUserSettingsLocalDataSource();
    repository =
        UserSettingsRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tUserId = '1';
  final tUserSettings = UserSettings(
    userId: tUserId,
    fundingRateThreshold: 0.01,
    minutesBeforeExpiration: 30,
    lastUpdated: DateTime.now(),
    languageCode: 'en',
  );

  group('getSettings', () {
    test('should return user settings from the data source', () async {
      // Arrange
      when(mockLocalDataSource.getSettings(any))
          .thenAnswer((_) async => tUserSettings);

      // Act
      final result = await repository.getSettings(tUserId);

      // Assert
      expect(result, tUserSettings);
      verify(mockLocalDataSource.getSettings(tUserId));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('saveSettings', () {
    test('should call the save method on the data source', () async {
      // Arrange
      when(mockLocalDataSource.saveSettings(any))
          .thenAnswer((_) async => null);

      // Act
      await repository.saveSettings(tUserSettings);

      // Assert
      verify(mockLocalDataSource.saveSettings(tUserSettings));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getAllUserIds', () {
    test('should return a list of user ids from the data source', () async {
      // Arrange
      final tUserIds = ['1', '2'];
      when(mockLocalDataSource.getAllUserIds())
          .thenAnswer((_) async => tUserIds);

      // Act
      final result = await repository.getAllUserIds();

      // Assert
      expect(result, tUserIds);
      verify(mockLocalDataSource.getAllUserIds());
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });
}