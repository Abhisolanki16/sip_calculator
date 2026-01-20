import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/provider/calculation_provider.dart';

class SipGoalTypeChips extends StatelessWidget {
  const SipGoalTypeChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SipGoalTypeProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 56.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: sipGoalTypes.length,
            separatorBuilder: (_, __) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              final item = sipGoalTypes[index];
              final isSelected = provider.selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  final goalProvider = context.read<SipGoalTypeProvider>();
                  final calcProvider = context.read<SipCalculationProvider>();

                  goalProvider.selectGoal(index);
                  calcProvider.updateGoalTitle(sipGoalTypes[index].title);
                  print(calcProvider.model.title);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF38BDF8).withOpacity(0.15)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF38BDF8)
                          : Colors.white12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 18.sp,
                        color: isSelected
                            ? const Color(0xFF38BDF8)
                            : Colors.white70,
                      ),
                      8.horizontalSpace,
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF38BDF8)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
