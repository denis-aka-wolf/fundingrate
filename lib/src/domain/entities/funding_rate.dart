class FundingRate {
  final String symbol;
  final double fundingRate;
  final int fundingTime;

  FundingRate({
    required this.symbol,
    required this.fundingRate,
    required this.fundingTime,
  });

  factory FundingRate.fromJson(Map<String, dynamic> json) {
    return FundingRate(
      symbol: json['symbol'],
      fundingRate: double.parse(json['fundingRate']),
      fundingTime: json['fundingTime'],
    );
  }

  @override
  String toString() {
    return 'FundingRate for $symbol: $fundingRate at ${DateTime.fromMillisecondsSinceEpoch(fundingTime)}';
  }
}