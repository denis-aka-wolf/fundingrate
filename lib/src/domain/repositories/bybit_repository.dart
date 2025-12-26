import '../entities/funding_rate.dart';
import '../entities/trading_pair.dart';

abstract class BybitRepository {
  Future<List<TradingPair>> getTradingPairs();
  Future<List<FundingRate>> getFundingRates();
}