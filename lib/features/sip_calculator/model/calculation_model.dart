class SipCalculationModel {
  final String title;
  final double monthlyInvestment;
  final double expectedReturn;
  final double investmentYears;
  final double projectedAmount;
  final double totalInvested;
  final double wealthGained;

  SipCalculationModel({
    required this.title,
    required this.monthlyInvestment,
    required this.expectedReturn,
    required this.investmentYears,
    required this.projectedAmount,
    required this.totalInvested,
    required this.wealthGained,
  });

  SipCalculationModel copyWith({
    String? title,
    double? monthlyInvestment,
    double? expectedReturn,
    double? investmentYears,
    double? projectedAmount,
    double? totalInvested,
    double? wealthGained,
  }) {
    return SipCalculationModel(
      title: title ?? this.title,
      monthlyInvestment: monthlyInvestment ?? this.monthlyInvestment,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      investmentYears: investmentYears ?? this.investmentYears,
      projectedAmount: projectedAmount ?? this.projectedAmount,
      totalInvested: totalInvested ?? this.totalInvested,
      wealthGained: wealthGained ?? this.wealthGained,
    );
  }
}
