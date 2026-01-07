import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/funding_rate.dart';

abstract class BybitRepository {
  Future<Either<Failure, List<FundingRate>>> getFundingRates();
}
