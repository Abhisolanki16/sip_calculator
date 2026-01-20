import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_calculator/utils/colors.dart';

void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: AppColors.backgroundDark,
    timeInSecForIosWeb: 2,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

double calculateSip({
  required double monthlyInvestment,
  required double annualRate,
  required double years,
}) {
  if (annualRate == 0) {
    return monthlyInvestment * years * 12;
  }

  final double monthlyRate = pow(1 + annualRate / 100, 1 / 12) - 1;

  final double months = years * 12;

  final double futureValue =
      monthlyInvestment *
      ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
      (1 + monthlyRate);

  return futureValue;
}
