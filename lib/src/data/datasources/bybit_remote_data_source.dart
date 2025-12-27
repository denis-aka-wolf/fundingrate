import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/funding_rate.dart';

abstract class BybitRemoteDataSource {
  Future<List<FundingRate>> getFundingRates();
}

class BybitRemoteDataSourceImpl implements BybitRemoteDataSource {
  final http.Client client;
  final String _baseUrl = 'https://api.bybit.com';

  BybitRemoteDataSourceImpl(this.client);

  @override
  Future<List<FundingRate>> getFundingRates() async {
    final response = await client
        .get(Uri.parse('$_baseUrl/v5/market/tickers?category=linear'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> tickers = data['result']['list'];
      return tickers
          .where((ticker) => ticker['fundingRate'] != null && ticker['nextFundingTime'] != null)
          .map((ticker) => FundingRate(
                symbol: ticker['symbol'],
                fundingRate: double.tryParse(ticker['fundingRate'] ?? '0.0') ?? 0.0,
                fundingTime: int.parse(ticker['nextFundingTime']),
              ))
          .toList();
    } else {
      throw Exception('Failed to load funding rates');
    }
  }
}