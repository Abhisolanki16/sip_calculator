// saved_plan.dart (NO CHANGE)
import 'package:flutter/material.dart';

class SavedPlan {
  final String title;
  final String date;
  final String investment;
  final String maturity;
  final Color iconColor;
  final IconData icon;
  final int years;
  final double monthlyAmount;

  SavedPlan({
    required this.title,
    required this.date,
    required this.investment,
    required this.maturity,
    required this.iconColor,
    required this.icon,
    required this.years,
    required this.monthlyAmount,
  });
}
