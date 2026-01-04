import 'package:fundingrate/src/data/datasources/bybit_remote_data_source.dart';
import 'package:fundingrate/src/data/repositories/bybit_repository_impl.dart';
import 'package:fundingrate/src/domain/entities/funding_rate.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'bybit_repository_impl_test.mocks.dart';

@GenerateMocks([BybitRemoteDataSource])
void main() {
  late BybitRepositoryImpl repository;
  late MockBybitRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockBybitRemoteDataSource();
    repository = BybitRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getFundingRates', () {
    test(
      'should return a list of funding rates from the data source',
      () async {
        // Arrange
        final tRates = [
          FundingRate(
            symbol: 'BTCUSDT',
            fundingRate: 0.01,
            fundingTime: 1234567890,
          ),
        ];
        when(
          mockRemoteDataSource.getFundingRates(),
        ).thenAnswer((_) async => tRates);

        // Act
        final result = await repository.getFundingRates();

        // Assert
        expect(result, tRates);
        verify(mockRemoteDataSource.getFundingRates());
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should throw an exception when the data source throws an exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getFundingRates(),
        ).thenThrow(Exception('Failed to fetch rates'));

        // Act
        final call = repository.getFundingRates;

        // Assert
        expect(() => call(), throwsA(isA<Exception>()));
      },
    );
  });
}
