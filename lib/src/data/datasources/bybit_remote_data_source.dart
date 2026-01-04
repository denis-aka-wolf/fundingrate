import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
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
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final url = '$_baseUrl/v5/market/tickers?category=linear';
    print('Requesting data from: $url');

    try {
      final response = await dio.get(
        url,
        options: Options(receiveTimeout: Duration(seconds: 30)),
      );
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (env['CONSOLE_OUTPUT'] == 'true') {
          print(response.data);
        }
        if (env['SAVE_BYBIT_RESPONSE'] == 'true') {
          final now = DateTime.now().toIso8601String().replaceAll(':', '-');
          final directory = Directory('bybit_responses');
          if (!await directory.exists()) {
            await directory.create();
          }
          final file = File('bybit_responses/response_$now.json');
          await file.writeAsString(json.encode(response.data));
        }

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
                    double.tryParse(ticker['fundingRate'] ?? '0.0') ?? 0.0,
                fundingTime:
                    int.tryParse(ticker['nextFundingTime'] ?? '0') ?? 0,
              ),
            )
            .where((rate) => rate.fundingTime != 0)
            .toList();
      } else {
        throw Exception('Failed to load funding rates');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw Exception('Failed to load funding rates: $e');
    }
  }
}
