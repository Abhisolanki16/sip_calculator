import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/model/saved_plan.dart';
import 'package:sip_calculator/features/sip_calculator/provider/saved_plan_provider.dart';
import 'package:sip_calculator/features/sip_calculator/screens/calculation_input.dart';
import 'package:sip_calculator/utils/app_text_styles.dart';
import 'package:sip_calculator/utils/colors.dart';
import 'package:sip_calculator/utils/extensions.dart';

class SavedPlansScreen extends StatelessWidget {
  const SavedPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedPlansProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text('Saved Plans', style: AppTextStyles.bold20),
        centerTitle: true,
      ),
      backgroundColor: AppColors.projectionBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.r),
              _filters(provider),
              SizedBox(height: 20.r),
              Expanded(child: _plansList(provider, context)),
              _ctaButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filters(SavedPlansProvider provider) {
    return SizedBox(
      height: 36.r,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.r),
        itemBuilder: (_, index) {
          final filter = provider.filters[index];
          final isSelected = provider.selectedFilter == filter;

          return GestureDetector(
            onTap: () => provider.changeFilter(filter),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 8.r),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.chipSelected : AppColors.chipBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                filter,
                style: AppTextStyles.medium14.copyWith(
                  color: isSelected
                      ? AppColors.chipTextSelected
                      : AppColors.chipText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _plansList(SavedPlansProvider provider, BuildContext context) {
    return ListView.separated(
      itemCount: provider.plans.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.r),
      itemBuilder: (_, index) {
        return _planCard(provider.plans[index], context, provider);
      },
    );
  }

  Widget _planCard(
    SavedPlan plan,
    BuildContext context,
    SavedPlansProvider provider,
  ) {
    IconData getSipGoalIcon(String goalTitle) {
      switch (goalTitle) {
        case 'Life & Family':
          return Icons.home_rounded;

        case 'Lifestyle':
          return Icons.directions_car_rounded;

        case 'Education':
          return Icons.school_rounded;

        case 'Retirement':
          return Icons.emoji_events_rounded;

        case 'Wealth Creation':
          return Icons.trending_up_rounded;

        case 'Travel':
          return Icons.flight_takeoff_rounded;

        default:
          return Icons.trending_up_rounded;
      }
    }

    Color getSipGoalColor(String goalTitle) {
      switch (goalTitle) {
        case 'Life & Family':
          return Colors.blue;

        case 'Lifestyle':
          return Colors.orange;

        case 'Education':
          return Colors.purple;

        case 'Retirement':
          return Colors.green;

        case 'Wealth Creation':
          return Colors.teal;

        case 'Travel':
          return Colors.red;

        default:
          return Colors.grey;
      }
    }

    final icon = getSipGoalIcon(plan.title);
    final color = getSipGoalColor(plan.title);
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  color: plan.iconColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 20.r),
              ),
              SizedBox(width: 12.r),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.title, style: AppTextStyles.bold14),
                    SizedBox(height: 4.r),
                    Text(
                      plan.date,
                      style: AppTextStyles.regular14.copyWith(
                        fontSize: 12.spMin,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<SavedPlansProvider>().removePlan(plan);
                  if (provider.plans.isEmpty) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                child: Icon(
                  Icons.delete_forever,
                  color: AppColors.textSecondary,
                  size: 25.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.r),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoBlock(
                'INVESTMENT',
                plan.investment.toString().formatAmount(),
              ),
              _infoBlock(
                'MATURITY AMOUNT',
                plan.maturity.toString().formatAmount(),
                highlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(String label, String value, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.regular14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.r),
        Text(
          value,
          style: AppTextStyles.bold14.copyWith(
            fontSize: highlight ? 16.spMin : 14.spMin,
            color: highlight ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _ctaButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12.r),
      child: SizedBox(
        height: 52.r,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalculationInputScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
          ),
          child: Text(
            '+  Calculate New SIP',
            style: AppTextStyles.bold16.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
