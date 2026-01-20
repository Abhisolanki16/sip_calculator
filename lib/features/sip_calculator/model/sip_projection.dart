class SipProjection {
  final int years;
  final double futureValue;

  SipProjection({required this.years, required this.futureValue});
}

class SipTableRow {
  final String duration;
  final String amount;
  final String futureValue;
  final bool isHighlighted;

  SipTableRow({
    required this.duration,
    required this.amount,
    required this.futureValue,
    this.isHighlighted = false,
  });
}
