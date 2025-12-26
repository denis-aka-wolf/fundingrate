import '../entities/funding_rate.dart';
import '../repositories/bybit_repository.dart';

class GetFundingRates {
  final BybitRepository repository;

  GetFundingRates(this.repository);

  Future<List<FundingRate>> call() {
    return repository.getFundingRates();
  }
}
