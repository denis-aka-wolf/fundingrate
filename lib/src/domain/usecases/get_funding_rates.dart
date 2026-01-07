import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/funding_rate.dart';
import '../repositories/bybit_repository.dart';

class GetFundingRates {
  final BybitRepository repository;

  GetFundingRates(this.repository);

  Future<Either<Failure, List<FundingRate>>> call() {
    return repository.getFundingRates();
  }
}
