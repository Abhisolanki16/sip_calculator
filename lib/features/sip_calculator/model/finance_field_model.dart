import 'package:sip_calculator/utils/app_text_styles.dart';

class FinanceFieldModel {
  final String title;
  final String minLabel;
  final String maxLabel;
  final InputFieldType type;
  final bool showQuickAddChips;

  const FinanceFieldModel({
    required this.title,
    required this.minLabel,
    required this.maxLabel,
    required this.type,
    this.showQuickAddChips = false,
  });
}
