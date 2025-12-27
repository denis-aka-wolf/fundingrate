import '../entities/funding_rate.dart';
import '../entities/user_settings.dart';

class CheckFundingRates {
  List<FundingRate> call({
    required List<FundingRate> rates,
    required UserSettings settings,
  }) {
    final now = DateTime.now().toUtc();
    final notifications = <FundingRate>[];

    for (final rate in rates) {

      final fundingTime = DateTime.fromMillisecondsSinceEpoch(rate.fundingTime, isUtc: true);
      final difference = fundingTime.difference(now);

      if (difference.isNegative) {
        continue;
      }

      final shouldNotify = difference.inMinutes <= settings.minutesBeforeExpiration &&
          rate.fundingRate.abs() >= settings.fundingRateThreshold;

      if (shouldNotify) {
        notifications.add(rate);
      }
    }

    return notifications;
  }
}