import '../../domain/entities/funding_rate.dart';
import '../../domain/entities/trading_pair.dart';
import '../../domain/repositories/bybit_repository.dart';
import '../datasources/bybit_remote_data_source.dart';

class BybitRepositoryImpl implements BybitRepository {
  final BybitRemoteDataSource remoteDataSource;

  BybitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TradingPair>> getTradingPairs() {
    return remoteDataSource.getTradingPairs();
  }

  @override
  Future<List<FundingRate>> getFundingRates() {
    return remoteDataSource.getFundingRates();
  }
}