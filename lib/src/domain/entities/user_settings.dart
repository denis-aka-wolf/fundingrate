class UserSettings {
  final String userId;
  final List<String> pairs;
  final double fundingRateThreshold;
  final int minutesBeforeExpiration;
  final int checkIntervalMinutes;
  final DateTime lastUpdated;

  UserSettings({
    required this.userId,
    required this.pairs,
    required this.fundingRateThreshold,
    required this.minutesBeforeExpiration,
    required this.checkIntervalMinutes,
    required this.lastUpdated,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'],
      pairs: List<String>.from(json['pairs']),
      fundingRateThreshold: (json['funding_rate_threshold'] as num).toDouble(),
      minutesBeforeExpiration: json['minutes_before_expiration'],
      checkIntervalMinutes: json['check_interval_minutes'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'pairs': pairs,
      'funding_rate_threshold': fundingRateThreshold,
      'minutes_before_expiration': minutesBeforeExpiration,
      'check_interval_minutes': checkIntervalMinutes,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    final pairsString = pairs.length > 10
        ? '${pairs.take(10).join(', ')}... and ${pairs.length - 10} more'
        : pairs.join(', ');
    return '''
UserSettings for $userId:
  Pairs: $pairsString
  Funding Rate Threshold: $fundingRateThreshold
  Minutes Before Expiration: $minutesBeforeExpiration
  Check Interval (minutes): $checkIntervalMinutes
  Last Updated: $lastUpdated
''';
  }
}