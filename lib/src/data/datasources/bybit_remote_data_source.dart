import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../core/service_locator.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/funding_rate.dart';

abstract class BybitRemoteDataSource {
  Future<List<FundingRate>> getFundingRates();
}

class BybitRemoteDataSourceImpl implements BybitRemoteDataSource {
  final Dio dio;
  final String _baseUrl = 'https://api.bybit.com';

  BybitRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FundingRate>> getFundingRates() async {
    final url = '$_baseUrl/v5/market/tickers?category=linear';
    
    try {
      final response = await dio.get(
        url,
        options: Options(receiveTimeout: Duration(seconds: 30)),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> tickers = data['result']['list'];
        return tickers
            .where(
              (ticker) =>
                  ticker['fundingRate'] != null &&
                  ticker['nextFundingTime'] != null,
            )
            .map(
              (ticker) => FundingRate(
                symbol: ticker['symbol'],
                fundingRate:
                    double.tryParse(ticker['fundingRate']?.toString() ?? '0.0') ?? 0.0,
                fundingTime:
                    int.tryParse(ticker['nextFundingTime']?.toString() ?? '0') ?? 0,
              ),
            )
            .where((rate) => rate.fundingTime != 0)
            .toList();
      } else {
        // Specific exception for HTTP errors
        throw ServerException(message: 'Failed to load funding rates: ${response.statusCode}');
      }
    } on DioException catch (e, s) {
        // Specific exception for network/Dio errors
        sl<Logger>().e('Error during HTTP request', error: e, stackTrace: s);
        throw ServerException(message: 'Failed to load funding rates: $e');
    } catch (e, s) {
        // Catch any other errors (e.g., parsing)
        sl<Logger>().e('An unexpected error occurred', error: e, stackTrace: s);
        throw ServerException(message: 'Failed to process funding rates: $e');
    }
  }
}
