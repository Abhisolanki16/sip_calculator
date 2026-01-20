import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/model/finance_field_model.dart';
import 'package:sip_calculator/features/sip_calculator/provider/calculation_provider.dart';
import 'package:sip_calculator/features/sip_calculator/screens/calculated_return.dart';
import 'package:sip_calculator/utils/app_text_styles.dart';
import 'package:sip_calculator/utils/colors.dart';
import 'package:sip_calculator/utils/extensions.dart';
import 'package:sip_calculator/widgets/amt_per_yr_field.dart';
import 'package:sip_calculator/widgets/sip_goal_type_selector.dart';

class CalculationInputScreen extends StatefulWidget {
  const CalculationInputScreen({super.key});
  @override
  State<CalculationInputScreen> createState() => _CalculationInputScreenState();
}

class _CalculationInputScreenState extends State<CalculationInputScreen> {
  static const List<FinanceFieldModel> _fieldConfigs = [
    FinanceFieldModel(
      title: 'Monthly Investment',
      minLabel: '₹500',
      maxLabel: '₹1L',
      type: InputFieldType.amount,
      showQuickAddChips: true,
    ),
    FinanceFieldModel(
      title: 'Expected Return Rate (p.a)',
      minLabel: '1%',
      maxLabel: '30%',
      type: InputFieldType.percentage,
    ),
    FinanceFieldModel(
      title: 'Time Period',
      minLabel: '1 YR',
      maxLabel: '40 YR',
      type: InputFieldType.year,
    ),
  ];

  VoidCallback? _amountListener;
  VoidCallback? _rateListener;
  VoidCallback? _yearListener;
  SipCalculationProvider? _provider;
  bool _listenersSetup = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_listenersSetup) {
      _provider = Provider.of<SipCalculationProvider>(context, listen: false);
      _setupAmountControllerListener(_provider!);
      _setupPercentageControllerListener(_provider!);
      _setupYearControllerListener(_provider!);
      _listenersSetup = true;
    }
  }

  @override
  void dispose() {
    if (_listenersSetup && _provider != null) {
      if (_amountListener != null) {
        _provider!.amountController.removeListener(_amountListener!);
      }
      if (_rateListener != null) {
        _provider!.rateController.removeListener(_rateListener!);
      }
      if (_yearListener != null) {
        _provider!.yearController.removeListener(_yearListener!);
      }
    }
    super.dispose();
  }

  void _setupAmountControllerListener(SipCalculationProvider provider) {
    _amountListener = () {
      final rawValue = provider.amountController.text.replaceAll(',', '');
      final parsedValue = double.tryParse(rawValue);
      if (parsedValue == null) return;
      if (parsedValue == provider.model.monthlyInvestment) return;
      if (parsedValue > SipCalculationProvider.maxAmount) {
        provider.updateAmount(SipCalculationProvider.maxAmount);
        return;
      }
      if (parsedValue < SipCalculationProvider.minAmount) return;
      provider.updateAmount(parsedValue);
    };
    provider.amountController.addListener(_amountListener!);
  }

  void _setupPercentageControllerListener(SipCalculationProvider provider) {
    _rateListener = () {
      final rawValue = provider.rateController.text.replaceAll('%', '');
      final parsedValue = double.tryParse(rawValue);
      if (parsedValue == null) return;
      final roundedValue = parsedValue.round().toDouble();
      if (roundedValue == provider.model.expectedReturn) return;
      if (roundedValue > SipCalculationProvider.maxRate) {
        provider.updateRate(SipCalculationProvider.maxRate);
        return;
      }
      if (roundedValue < SipCalculationProvider.minRate) return;
      provider.updateRate(roundedValue);
    };
    provider.rateController.addListener(_rateListener!);
  }

  void _setupYearControllerListener(SipCalculationProvider provider) {
    _yearListener = () {
      final parsedValue = double.tryParse(provider.yearController.text);
      if (parsedValue == null) return;
      final roundedYear = parsedValue.roundToDouble();
      if (roundedYear == provider.model.investmentYears) return;
      if (roundedYear > SipCalculationProvider.maxYears) {
        provider.updateYears(SipCalculationProvider.maxYears);
        return;
      }
      if (roundedYear < SipCalculationProvider.minYears) return;
      provider.updateYears(roundedYear);
    };
    provider.yearController.addListener(_yearListener!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SipCalculationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: _buildAppBar(),
          body: SafeArea(child: _buildBody(provider)),
          bottomSheet: _buildBottomSheet(provider),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('SIP Calculator'));
  }

  Widget _buildBody(SipCalculationProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionText(),
            20.verticalSpace,
            SipGoalTypeChips(),

            20.verticalSpace,
            for (int i = 0; i < _fieldConfigs.length; i++) ...[
              _buildFieldCard(_fieldConfigs[i], provider),
              if (i != _fieldConfigs.length - 1) 20.verticalSpace,
            ],

            200.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      'Calculate your future wealth by investing small amount regularly',
      textAlign: TextAlign.center,
      style: AppTextStyles.regular16.copyWith(
        color: AppColors.textSecondary,
        fontSize: 14.spMin,
      ),
    );
  }

  Widget _buildFieldCard(
    FinanceFieldModel config,
    SipCalculationProvider provider,
  ) {
    late final TextEditingController controller;
    late final double value;

    switch (config.type) {
      case InputFieldType.amount:
        controller = provider.amountController;
        value = provider.model.monthlyInvestment;
        break;
      case InputFieldType.percentage:
        controller = provider.rateController;
        value = provider.model.expectedReturn;
        break;
      case InputFieldType.year:
        controller = provider.yearController;
        value = provider.model.investmentYears;
        break;
    }

    return _buildInputCard(
      title: config.title,
      controller: controller,
      minLabel: config.minLabel,
      maxLabel: config.maxLabel,
      type: config.type,
      value: value,
      showQuickAddChips: config.showQuickAddChips,
      provider: provider,
    );
  }

  Widget _buildBottomSheet(SipCalculationProvider provider) {
    return Container(
      width: 1.sw,
      height: 180.r,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.appBackground,
        border: Border.all(color: AppColors.borderDark),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProjectedAmountLabel(),
          2.verticalSpace,
          _buildProjectedAmountValue(provider),
          20.verticalSpace,
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildProjectedAmountLabel() {
    return Text('Projected Amount', style: AppTextStyles.medium14);
  }

  Widget _buildProjectedAmountValue(SipCalculationProvider provider) {
    return Text(
      provider.model.projectedAmount.round().toString().formatAmount(),
      style: AppTextStyles.bold20,
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: 1.sw,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalculatedReturn()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calculate Returns',
              style: AppTextStyles.bold16.copyWith(color: Colors.white),
            ),
            SizedBox(width: 12.r),
            Icon(Icons.arrow_forward, size: 22.r, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required String minLabel,
    required String maxLabel,
    required InputFieldType type,
    required double value,
    required bool showQuickAddChips,
    required SipCalculationProvider provider,
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputCardHeader(title, controller, type),
          5.verticalSpace,
          _buildInputSlider(type, value, controller, provider),
          _buildSliderLabels(minLabel, maxLabel),
          if (showQuickAddChips) ...[
            10.verticalSpace,
            _buildQuickAddChips(provider),
          ],
        ],
      ),
    );
  }

  Widget _buildInputCardHeader(
    String title,
    TextEditingController controller,
    InputFieldType type,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.medium14),
        SizedBox(
          width: 100.r,
          child: FinanceInputField(controller: controller, type: type),
        ),
      ],
    );
  }

  Widget _buildInputSlider(
    InputFieldType type,
    double value,
    TextEditingController controller,
    SipCalculationProvider provider,
  ) {
    return SizedBox(
      width: 1.sw,
      child: Slider(
        min: _getMinValueForType(type),
        activeColor: AppColors.blue,
        max: _getMaxValueForType(type),
        padding: EdgeInsets.zero,
        value: value,
        onChanged: (newValue) =>
            _handleSliderChange(type, newValue, controller, provider),
      ),
    );
  }

  Widget _buildSliderLabels(String minLabel, String maxLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          minLabel,
          style: AppTextStyles.bold14.copyWith(color: Colors.grey),
        ),
        Text(
          maxLabel,
          style: AppTextStyles.bold14.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickAddChips(SipCalculationProvider provider) {
    return Wrap(
      spacing: 10.r,
      children: SipCalculationProvider.quickAddAmounts.map((amount) {
        return _buildQuickAddChip(amount, provider);
      }).toList(),
    );
  }

  Widget _buildQuickAddChip(int amount, SipCalculationProvider provider) {
    final chipText = '+ ₹${amount.toString()}';
    return GestureDetector(
      onTap: () => _handleQuickAddTap(amount, provider),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 5.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: AppColors.appBackground,
        ),
        child: Text(chipText.formatAmount(), style: AppTextStyles.regular14),
      ),
    );
  }

  double _getMinValueForType(InputFieldType type) {
    switch (type) {
      case InputFieldType.amount:
        return SipCalculationProvider.minAmount;
      case InputFieldType.percentage:
        return SipCalculationProvider.minRate;
      case InputFieldType.year:
        return SipCalculationProvider.minYears;
    }
  }

  double _getMaxValueForType(InputFieldType type) {
    switch (type) {
      case InputFieldType.amount:
        return SipCalculationProvider.maxAmount;
      case InputFieldType.percentage:
        return SipCalculationProvider.maxRate;
      case InputFieldType.year:
        return SipCalculationProvider.maxYears;
    }
  }

  void _handleSliderChange(
    InputFieldType type,
    double newValue,
    TextEditingController controller,
    SipCalculationProvider provider,
  ) {
    double processedValue;
    switch (type) {
      case InputFieldType.amount:
        processedValue =
            (newValue / SipCalculationProvider.amountStep).round() *
            SipCalculationProvider.amountStep.toDouble();
        provider.updateAmount(processedValue);
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        break;
      case InputFieldType.percentage:
        processedValue = newValue.round().toDouble();
        provider.updateRate(processedValue);
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        break;
      case InputFieldType.year:
        processedValue = newValue.round().toDouble();
        provider.updateYears(processedValue);
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        break;
    }
  }

  void _handleQuickAddTap(int addAmount, SipCalculationProvider provider) {
    provider.addQuickAmount(addAmount);
  }
}
