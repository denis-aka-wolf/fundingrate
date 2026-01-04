class UserSettings {
  final String userId;
  final double fundingRateThreshold;
  final int minutesBeforeExpiration;
  final DateTime lastUpdated;
  final String languageCode;

  UserSettings({
    required this.userId,
    required this.fundingRateThreshold,
    required this.minutesBeforeExpiration,
    required this.lastUpdated,
    required this.languageCode,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] ?? '',
      fundingRateThreshold:
          (json['funding_rate_threshold'] as num?)?.toDouble() ?? 0.01,
      minutesBeforeExpiration: json['minutes_before_expiration'] ?? 30,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
      languageCode: json['language_code'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'funding_rate_threshold': fundingRateThreshold,
      'minutes_before_expiration': minutesBeforeExpiration,
      'last_updated': lastUpdated.toIso8601String(),
      'language_code': languageCode,
    };
  }

  @override
  String toString() {
    return '''
UserSettings for $userId:
  Funding Rate Threshold: $fundingRateThreshold
  Minutes Before Expiration: $minutesBeforeExpiration
  Last Updated: $lastUpdated
  Language: $languageCode
''';
  }
}
