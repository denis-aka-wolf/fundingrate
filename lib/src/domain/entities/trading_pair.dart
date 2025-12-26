class TradingPair {
  final String symbol;
  final DateTime? nextFundingTime;
  final double? lastFundingRate;

  TradingPair({
    required this.symbol,
    this.nextFundingTime,
    this.lastFundingRate,
  });

  @override
  String toString() {
    return 'TradingPair: $symbol, Next Funding: $nextFundingTime, Last Rate: $lastFundingRate';
  }
}