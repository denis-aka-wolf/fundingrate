import 'package:fundingrate/src/domain/entities/funding_rate.dart';
import 'package:fundingrate/src/domain/entities/user_settings.dart';
import 'package:fundingrate/src/domain/usecases/check_funding_rates.dart';
import 'package:test/test.dart';

void main() {
  late CheckFundingRates usecase;

  setUp(() {
    usecase = CheckFundingRates();
  });

  test(
    'should return funding rates that meet the threshold and time constraints',
    () {
      // Arrange
      final settings = UserSettings(
        userId: '1',
        fundingRateThreshold: 0.01,
        minutesBeforeExpiration: 30,
        lastUpdated: DateTime.now(),
        languageCode: 'en',
      );

      final rates = [
        FundingRate(
          symbol: 'BTCUSDT',
          fundingRate: 0.015,
          fundingTime: DateTime.now()
              .add(const Duration(minutes: 15))
              .millisecondsSinceEpoch,
        ),
        FundingRate(
          symbol: 'ETHUSDT',
          fundingRate: -0.02,
          fundingTime: DateTime.now()
              .add(const Duration(minutes: 25))
              .millisecondsSinceEpoch,
        ),
        FundingRate(
          symbol: 'BTCUSDT',
          fundingRate: 0.005,
          fundingTime: DateTime.now()
              .add(const Duration(minutes: 5))
              .millisecondsSinceEpoch,
        ),
      ];

      // Act
      final result = usecase(rates: rates, settings: settings);

      // Assert
      expect(result.length, 2);
      expect(result[0].symbol, 'BTCUSDT');
      expect(result[1].symbol, 'ETHUSDT');
    },
  );

  test('should return an empty list when no rates meet the threshold', () {
    // Arrange
    final settings = UserSettings(
      userId: '1',
      fundingRateThreshold: 0.03,
      minutesBeforeExpiration: 30,
      lastUpdated: DateTime.now(),
      languageCode: 'en',
    );

    final rates = [
      FundingRate(
        symbol: 'BTCUSDT',
        fundingRate: 0.015,
        fundingTime: DateTime.now()
            .add(const Duration(minutes: 15))
            .millisecondsSinceEpoch,
      ),
      FundingRate(
        symbol: 'ETHUSDT',
        fundingRate: -0.02,
        fundingTime: DateTime.now()
            .add(const Duration(minutes: 25))
            .millisecondsSinceEpoch,
      ),
    ];

    // Act
    final result = usecase(rates: rates, settings: settings);

    // Assert
    expect(result.isEmpty, isTrue);
  });

  test(
    'should return an empty list when no rates are within the time window',
    () {
      // Arrange
      final settings = UserSettings(
        userId: '1',
        fundingRateThreshold: 0.01,
        minutesBeforeExpiration: 10,
        lastUpdated: DateTime.now(),
        languageCode: 'en',
      );

      final rates = [
        FundingRate(
          symbol: 'BTCUSDT',
          fundingRate: 0.015,
          fundingTime: DateTime.now()
              .add(const Duration(minutes: 15))
              .millisecondsSinceEpoch,
        ),
        FundingRate(
          symbol: 'ETHUSDT',
          fundingRate: -0.02,
          fundingTime: DateTime.now()
              .add(const Duration(minutes: 25))
              .millisecondsSinceEpoch,
        ),
      ];

      // Act
      final result = usecase(rates: rates, settings: settings);

      // Assert
      expect(result.isEmpty, isTrue);
    },
  );
}
