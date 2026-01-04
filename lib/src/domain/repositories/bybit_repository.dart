import '../entities/funding_rate.dart';

abstract class BybitRepository {
  Future<List<FundingRate>> getFundingRates();
}
