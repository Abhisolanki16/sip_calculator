import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/model/calculation_model.dart';
import 'package:sip_calculator/features/sip_calculator/model/saved_plan.dart';
import 'package:sip_calculator/features/sip_calculator/model/sip_projection.dart';
import 'package:sip_calculator/features/sip_calculator/provider/saved_plan_provider.dart';
import '../../../utils/helper.dart';

class SipGoalType {
  final String title;
  final String subtitle;
  final IconData icon;

  const SipGoalType({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

final List<SipGoalType> sipGoalTypes = [
  SipGoalType(
    title: 'Life & Family',
    subtitle: 'Security, home, family',
    icon: Icons.home_rounded,
  ),
  SipGoalType(
    title: 'Lifestyle',
    subtitle: 'Car, gadgets, luxury',
    icon: Icons.directions_car_rounded,
  ),
  SipGoalType(
    title: 'Education',
    subtitle: 'Studies & future growth',
    icon: Icons.school_rounded,
  ),
  SipGoalType(
    title: 'Retirement',
    subtitle: 'Long-term wealth',
    icon: Icons.emoji_events_rounded,
  ),
  SipGoalType(
    title: 'Wealth Creation',
    subtitle: 'Grow money smartly',
    icon: Icons.trending_up_rounded,
  ),
  SipGoalType(
    title: 'Travel',
    subtitle: 'Trips & experiences',
    icon: Icons.flight_takeoff_rounded,
  ),
];

class SipGoalTypeProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  String _selectedTitle = sipGoalTypes[0].title;

  int get selectedIndex => _selectedIndex;
  String get selectedTitle => _selectedTitle;

  SipGoalType get selectedGoal => sipGoalTypes[_selectedIndex];

  void selectGoal(int index) {
    _selectedIndex = index;
    _selectedTitle = sipGoalTypes[index].title;
    notifyListeners();
  }
}

class SipCalculationProvider extends ChangeNotifier {
  // ---- Constants ----
  static const double minAmount = 500;
  static const double maxAmount = 100000;
  static const double minRate = 1;
  static const double maxRate = 30;
  static const double minYears = 1;
  static const double maxYears = 40;
  static const int amountStep = 500;
  static const List<int> quickAddAmounts = [500, 1000, 5000];

  // ---- Controllers ----
  final amountController = TextEditingController(text: '500');
  final rateController = TextEditingController(text: '12');
  final yearController = TextEditingController(text: '10');

  // ---- UI State ----
  bool _inflationAdjusted = false;
  bool get inflationAdjusted => _inflationAdjusted;

  // ---- Model ----
  SipCalculationModel _model = SipCalculationModel(
    title: sipGoalTypes[0].title,
    monthlyInvestment: 500,
    expectedReturn: 12,
    investmentYears: 10,
    projectedAmount: 0,
    totalInvested: 0,
    wealthGained: 0,
  );

  SipCalculationModel get model => _model;

  SipCalculationProvider() {
    _recalculate();
  }

  void updateGoalTitle(String title) {
    _model = _model.copyWith(title: title);
    notifyListeners();
  }

  // ---- Update Methods ----
  void updateAmount(double value) {
    if (value > maxAmount) {
      showErrorToast('Maximum monthly investment is ₹1,00,000');
      value = maxAmount;
    }
    _model = _model.copyWith(monthlyInvestment: value);
    amountController.text = value.toInt().toString();
    _recalculate();
  }

  void updateRate(double value) {
    if (value > maxRate) {
      showErrorToast('Expected return rate cannot exceed 30%');
      value = maxRate;
    }
    _model = _model.copyWith(expectedReturn: value);
    rateController.text = value.toStringAsFixed(1);
    _recalculate();
  }

  void updateYears(double value) {
    if (value > maxYears) {
      showErrorToast('Maximum investment period is 40 years');
      value = maxYears;
    }
    _model = _model.copyWith(investmentYears: value);
    yearController.text = value.toInt().toString();
    _recalculate();
  }

  void addQuickAmount(int amount) {
    final newAmount = (_model.monthlyInvestment + amount).clamp(
      minAmount,
      maxAmount,
    );
    updateAmount(newAmount);
  }

  void updateInflationAdjusted(bool value) {
    if (_inflationAdjusted == value) return;
    _inflationAdjusted = value;
    notifyListeners();
  }

  // ---- Calculation ----
  void _recalculate() {
    final totalInvested =
        _model.monthlyInvestment * 12 * _model.investmentYears;
    final projected = calculateSip(
      monthlyInvestment: _model.monthlyInvestment,
      annualRate: _model.expectedReturn,
      years: _model.investmentYears,
    );

    final wealthGained = projected - totalInvested;

    _model = _model.copyWith(
      projectedAmount: projected,
      totalInvested: totalInvested,
      wealthGained: wealthGained,
    );
    notifyListeners();
  }

  /// CALL THIS AFTER CALCULATION
  void saveCurrentSip(BuildContext context) {
    final savedProvider = Provider.of<SavedPlansProvider>(
      context,
      listen: false,
    );

    final totalInvestment =
        model.monthlyInvestment * 12 * model.investmentYears;

    final maturityValue = model.projectedAmount; // already calculated

    final plan = SavedPlan(
      title: model.title,
      date: DateFormat('dd MMM yyyy').format(DateTime.now()),
      investment: '₹${totalInvestment.toStringAsFixed(0)}',
      maturity: '₹${maturityValue.toStringAsFixed(0)}',
      iconColor: Colors.green,
      icon: Icons.trending_up,
      years: model.investmentYears.round(),
      monthlyAmount: model.monthlyInvestment,
    );

    savedProvider.addPlan(plan);
  }

  @override
  void dispose() {
    amountController.dispose();
    rateController.dispose();
    yearController.dispose();
    super.dispose();
  }
}

List<SipTableRow> buildSipTableRows({
  required int totalYears,
  required double monthlyAmount,
  required double annualRate,
}) {
  final List<int> yearsList = _projectionYears(totalYears);
  final List<SipTableRow> rows = [];

  for (final year in yearsList) {
    final int months = year * 12;
    final double investedAmount = monthlyAmount * months;
    final double monthlyRate = pow(1 + annualRate / 100, 1 / 12) - 1;
    final double futureValue =
        monthlyAmount *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    rows.add(
      SipTableRow(
        duration: '$year year${year > 1 ? 's' : ''}',
        amount: _formatCurrency(investedAmount),
        futureValue: futureValue.toInt().toString(),
        isHighlighted: year == totalYears,
      ),
    );
  }

  return rows;
}

String _formatCurrency(double value) {
  return '₹${value.toStringAsFixed(0)}';
}

String _formatLakhs(double value) {
  final lakhs = value / 100000;
  return '${lakhs.toStringAsFixed(1)} Lakhs';
}

List<int> _projectionYears(int totalYears) {
  final Set<int> years = {1};

  if (totalYears <= 5) {
    years.addAll(List.generate(totalYears, (i) => i + 1));
  } else if (totalYears <= 10) {
    years.addAll([2, 3, 5]);
  } else if (totalYears <= 15) {
    years.addAll([3, 5, 10, 15]);
  } else if (totalYears <= 25) {
    years.addAll([5, 10, 15, 20, 25]);
  } else {
    years.addAll([10, 20, 30]);
  }

  // 🔹 Always include selected year
  years.add(totalYears);

  // 🔹 Ensure one value BELOW and ABOVE totalYears (around 11 rule)
  if (totalYears > 10) {
    years.add(10);
  }
  if (totalYears < 15) {
    years.add(15);
  }

  // 🔹 Keep logical bounds
  years.removeWhere((y) => y <= 0 || y > totalYears + 10);

  return years.toList()..sort();
}
