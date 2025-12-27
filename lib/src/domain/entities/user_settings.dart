class UserSettings {
  final String userId;
  final double fundingRateThreshold;
  final int minutesBeforeExpiration;
  final int checkIntervalMinutes;
  final DateTime lastUpdated;

  UserSettings({
    required this.userId,
    required this.fundingRateThreshold,
    required this.minutesBeforeExpiration,
    required this.checkIntervalMinutes,
    required this.lastUpdated,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'],
      fundingRateThreshold: (json['funding_rate_threshold'] as num).toDouble(),
      minutesBeforeExpiration: json['minutes_before_expiration'],
      checkIntervalMinutes: json['check_interval_minutes'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'funding_rate_threshold': fundingRateThreshold,
      'minutes_before_expiration': minutesBeforeExpiration,
      'check_interval_minutes': checkIntervalMinutes,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
UserSettings for $userId:
  Funding Rate Threshold: $fundingRateThreshold
  Minutes Before Expiration: $minutesBeforeExpiration
  Check Interval (minutes): $checkIntervalMinutes
  Last Updated: $lastUpdated
''';
  }
}