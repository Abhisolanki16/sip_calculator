import 'package:flutter/material.dart';
import 'package:sip_calculator/utils/extensions.dart';

class AnimatedAmountText extends StatelessWidget {
  final double value;
  final TextStyle style;
  final Duration duration;

  const AnimatedAmountText({
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, animatedValue, __) =>
          Text(animatedValue.round().toString().formatAmount(), style: style),
    );
  }
}
