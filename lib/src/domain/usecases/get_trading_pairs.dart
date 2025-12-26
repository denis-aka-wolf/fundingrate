import '../entities/trading_pair.dart';
import '../repositories/bybit_repository.dart';

class GetTradingPairs {
  final BybitRepository repository;

  GetTradingPairs(this.repository);

  Future<List<TradingPair>> call() {
    return repository.getTradingPairs();
  }
}