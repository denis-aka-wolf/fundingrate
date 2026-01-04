import '../../domain/entities/funding_rate.dart';
import '../../domain/repositories/bybit_repository.dart';
import '../datasources/bybit_remote_data_source.dart';

class BybitRepositoryImpl implements BybitRepository {
  final BybitRemoteDataSource remoteDataSource;

  BybitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FundingRate>> getFundingRates() {
    return remoteDataSource.getFundingRates();
  }
}
