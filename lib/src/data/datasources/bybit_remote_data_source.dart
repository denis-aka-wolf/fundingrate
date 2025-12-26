import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/funding_rate.dart';
import '../../domain/entities/trading_pair.dart';

abstract class BybitRemoteDataSource {
  Future<List<TradingPair>> getTradingPairs();
  Future<List<FundingRate>> getFundingRates();
}

class BybitRemoteDataSourceImpl implements BybitRemoteDataSource {
  final http.Client client;
  final String _baseUrl = 'https://api.bybit.com';

  BybitRemoteDataSourceImpl(this.client);

  @override
  Future<List<TradingPair>> getTradingPairs() async {
    final response = await client.get(Uri.parse('$_baseUrl/v2/public/symbols'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> symbols = data['result'];
      return symbols
          .where((s) => s['quote_currency'] == 'USDT' && s['name'].endsWith('USDT'))
          .map((symbol) => TradingPair(symbol: symbol['name']))
          .toList();
    } else {
      throw Exception('Failed to load trading pairs');
    }
  }

  @override
  Future<List<FundingRate>> getFundingRates() async {
    final response = await client.get(Uri.parse('$_baseUrl/v2/public/tickers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> tickers = data['result'];
      return tickers
          .where((ticker) => ticker['funding_rate'] != null)
          .map((ticker) => FundingRate(
                symbol: ticker['symbol'],
                fundingRate: double.parse(ticker['funding_rate']),
                fundingTime: ticker['next_funding_time_ms'] ?? DateTime.now().millisecondsSinceEpoch,
              ))
          .toList();
    } else {
      throw Exception('Failed to load funding rates');
    }
  }
}