import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sip_calculator/utils/app_text_styles.dart';
import 'package:sip_calculator/utils/colors.dart';
import 'package:sip_calculator/utils/extensions.dart';
import 'package:sip_calculator/widgets/app_text_field.dart';

class FinanceInputField extends StatelessWidget {
  final TextEditingController controller;
  final InputFieldType type;
  final TextStyle? textStyle;
  List<TextInputFormatter>? formatters;

  FinanceInputField({
    super.key,
    required this.controller,
    required this.type,
    this.textStyle,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: '',
      hint: '',
      controller: controller,

      contentPadding: EdgeInsets.zero,
      textStyle: textStyle ?? AppTextStyles.bold16,
      inputType: TextInputType.number,
      inputFormatters: formatters,
      filled: true,
      fillColor: Colors.black38,
      enabledBorder: _border(),
      focusedBorder: _border(),
      prefix: 1.horizontalSpace,
      suffix: _suffixWidget(),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueGrey),
      borderRadius: BorderRadius.circular(12.r),
    );
  }

  Widget? _suffixWidget() {
    switch (type) {
      case InputFieldType.percentage:
        return Icon(Icons.percent, size: 22.r, color: AppColors.accent);
      case InputFieldType.amount:
        return Icon(Icons.currency_rupee, size: 22.r, color: AppColors.accent);
      case InputFieldType.year:
        return _suffixText("YR");
      default:
        return null;
    }
  }

  Widget _suffixText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: AppTextStyles.bold18.copyWith(color: AppColors.accent),
          ),
        ),
        8.horizontalSpace,
      ],
    );
  }
}
