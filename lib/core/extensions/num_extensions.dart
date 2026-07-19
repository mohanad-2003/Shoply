extension PriceX on num {
  /// Formats a price with two decimals and a currency symbol.
  String toPrice({String symbol = '\$'}) => '$symbol${toStringAsFixed(2)}';
}
