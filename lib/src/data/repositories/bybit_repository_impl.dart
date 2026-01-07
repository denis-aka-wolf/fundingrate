import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/funding_rate.dart';
import '../../domain/repositories/bybit_repository.dart';
import '../datasources/bybit_remote_data_source.dart';

class BybitRepositoryImpl implements BybitRepository {
  final BybitRemoteDataSource remoteDataSource;

  BybitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FundingRate>>> getFundingRates() async {
    try {
      final rates = await remoteDataSource.getFundingRates();
      return Right(rates);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
