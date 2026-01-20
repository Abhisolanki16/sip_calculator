import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/model/sip_projection.dart';
import 'package:sip_calculator/features/sip_calculator/provider/calculation_provider.dart';
import 'package:sip_calculator/features/sip_calculator/screens/saved_plans.dart';
import 'package:sip_calculator/utils/app_text_styles.dart';
import 'package:sip_calculator/utils/colors.dart';
import 'package:sip_calculator/utils/extensions.dart';
import 'package:sip_calculator/widgets/animated_amount.dart';
import 'package:sip_calculator/widgets/sip_data_table.dart';

class SipTableItem {
  final int years;
  final int sipAmount;
  final double futureValue;

  SipTableItem({
    required this.years,
    required this.sipAmount,
    required this.futureValue,
  });
}

class CalculatedReturn extends StatefulWidget {
  const CalculatedReturn({super.key});

  @override
  State<CalculatedReturn> createState() => _CalculatedReturnState();
}

class _CalculatedReturnState extends State<CalculatedReturn> {
  SipCalculationProvider provider = SipCalculationProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SipCalculationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.projectionBackground,
          bottomSheet: Container(
            padding: EdgeInsets.all(10.r),
            color: AppColors.projectionBackground,
            height: 100.r,
            width: 1.sw,
            child: _bottomButtons().paddingSymmetric(h: 10.r),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: const Text('Projection'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  _maturityHeader(provider),
                  SizedBox(height: 24.r),
                  SizedBox(height: 20.r),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          _donutChart(provider),
                          SizedBox(height: 20.r),
                          _legend(),
                        ],
                      ),
                      _statsCards(provider),
                    ],
                  ),

                  SizedBox(height: 24.r),

                  SipDataTable(),
                  100.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------- HEADER ----------
  Widget _maturityHeader(SipCalculationProvider provider) {
    return Column(
      children: [
        Text(
          'EXPECTED MATURITY AMOUNT',
          style: TextStyle(
            color: AppColors.white54,

            fontSize: 12.r,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.r),
        AnimatedAmountText(
          value: provider.model.projectedAmount,
          style: TextStyle(
            fontSize: 32.r,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.r),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 6.r),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 16.r),
              SizedBox(width: 6.r),
              Text(
                '+236% Growth',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.r,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ---------- DONUT ----------
  Widget _donutChart(SipCalculationProvider provider) {
    final projected = provider.model.projectedAmount;
    final invested = provider.model.totalInvested;
    final investedRatio = projected <= 0
        ? 0.0
        : (invested / projected).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: investedRatio),
      builder: (_, animatedRatio, child) {
        return SizedBox(
          height: 220.r,
          width: 220.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(220.r, 220.r),
                painter: DonutPainter(animatedRatio),
              ),
              child!,
            ],
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TOTAL TERM',
            style: TextStyle(color: AppColors.white54, fontSize: 12.r),
          ),
          SizedBox(height: 4.r),
          Text(
            '${provider.model.investmentYears.round()} Yrs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.r,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- LEGEND ----------
  Widget _legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(Colors.blue, 'Wealth Gained'),
        SizedBox(width: 20.r),
        _dot(Colors.blueGrey, 'Invested'),
      ],
    );
  }

  Widget _dot(Color color, String label) {
    return Row(
      children: [
        Container(
          height: 10.r,
          width: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.r),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 14.r),
        ),
      ],
    );
  }

  /// ---------- STATS ----------
  Widget _statsCards(SipCalculationProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _infoCard(
          'TOTAL INVESTED',
          provider.model.totalInvested,
          Icons.account_balance_wallet,
        ),
        20.verticalSpace,
        _infoCard(
          'WEALTH GAINED',
          provider.model.wealthGained,
          Icons.trending_up,
          highlight: true,
        ),
      ],
    );
  }

  Widget _infoCard(
    String title,
    double value,
    IconData icon, {
    bool highlight = false,
  }) {
    return Container(
      width: 130.r,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.white54, size: 25.r),
          SizedBox(height: 12.r),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.white54, fontSize: 12.r),
            ),
          ),
          SizedBox(height: 6.r),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedAmountText(
              value: value,
              style: TextStyle(
                color: highlight ? Colors.blue : Colors.white,
                fontSize: 20.spMin,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- TOGGLE ----------
  Widget _inflationToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inflation Adjusted',
                  style: TextStyle(color: Colors.white, fontSize: 16.r),
                ),
                SizedBox(height: 4.r),
                Text(
                  'Show real value (6% inflation)',
                  style: TextStyle(color: AppColors.white54, fontSize: 12.r),
                ),
              ],
            ),
          ),
          Consumer<SipCalculationProvider>(
            builder: (context, provider, child) => Switch(
              value: provider.inflationAdjusted,
              activeTrackColor: AppColors.accent.withOpacity(0.2),
              inactiveThumbColor: Colors.white,
              trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
              inactiveTrackColor: AppColors.appBackground,
              onChanged: provider.updateInflationAdjusted,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- TIMELINE ----------
  /* Widget _growthTimeline(SipCalculationProvider provider) {
    final model = provider.model;
    final totalYears = model.investmentYears.round().clamp(1, 40).toInt();
    if (totalYears <= 0) return const SizedBox.shrink();

    final projections = generateSipProjections(
      monthlyInvestment: model.monthlyInvestment,
      annualRate: model.expectedReturn,
      totalYears: totalYears,
    );

    final chartValues = projections
        .map((projection) => projection.futureValue)
        .toList();

    return Container(
      height: 200.r,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Growth Timeline',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 4.r),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  'Yearly',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12.r,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.r),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (_, animationValue, __) {
                return CustomPaint(
                  painter: LineChartPainter(
                    values: chartValues,
                    animationValue: animationValue,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.r),
          _buildYearLabels(totalYears),
        ],
      ),
    );
  }*/

  void _addIfValid(List<int> list, int value, int max) {
    if (value <= max) list.add(value);
  }

  Widget _buildYearLabels(int totalYears) {
    final List<int> ticks = [];

    // Always show start
    ticks.add(1);

    if (totalYears <= 5) {
      for (int i = 2; i <= totalYears; i++) {
        ticks.add(i);
      }
    } else if (totalYears <= 10) {
      _addIfValid(ticks, 3, totalYears);
      _addIfValid(ticks, 5, totalYears);
      _addIfValid(ticks, 7, totalYears);
    } else if (totalYears <= 15) {
      _addIfValid(ticks, 5, totalYears);
      _addIfValid(ticks, 10, totalYears);
    } else if (totalYears <= 25) {
      _addIfValid(ticks, 5, totalYears);
      _addIfValid(ticks, 10, totalYears);
      _addIfValid(ticks, 15, totalYears);
      _addIfValid(ticks, 20, totalYears);
    } else if (totalYears <= 40) {
      _addIfValid(ticks, 10, totalYears);
      _addIfValid(ticks, 20, totalYears);
      _addIfValid(ticks, 30, totalYears);
    } else {
      _addIfValid(ticks, 15, totalYears);
      _addIfValid(ticks, 30, totalYears);
      _addIfValid(ticks, 45, totalYears);
    }

    // Always show the final real year
    if (!ticks.contains(totalYears)) {
      ticks.add(totalYears);
    }

    ticks.sort();

    final baseYear = DateTime.now().year;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final year in ticks)
          Expanded(
            child: Text(
              '${baseYear + (year - 1)}',
              textAlign: year == ticks.first
                  ? TextAlign.left
                  : year == ticks.last
                  ? TextAlign.right
                  : TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 11.r),
            ),
          ),
      ],
    );
  }

  // List<SipProjection> generateSipProjections({
  //   required double monthlyInvestment,
  //   required double annualRate,
  //   required int totalYears,
  // }) {
  //   final monthlyRate = annualRate / 12 / 100;
  //   final projectionYears = _projectionYears(totalYears);

  //   final List<SipProjection> projections = [];

  //   for (final years in projectionYears) {
  //     double balance = 0;

  //     for (int i = 0; i < years * 12; i++) {
  //       balance = balance * (1 + monthlyRate) + monthlyInvestment;
  //     }

  //     projections.add(SipProjection(years: years, futureValue: balance));
  //   }

  //   return projections;
  // }

  /// ---------- BUTTONS ----------
  Widget _bottomButtons() {
    return Row(
      children: [
        // -------- Share Button --------
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 48.r,
            padding: EdgeInsets.symmetric(horizontal: 20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.ios_share, color: Colors.white, size: 20.r),
                SizedBox(width: 8.r),
                Text('Share', style: AppTextStyles.bold16),
              ],
            ),
          ),
        ),

        SizedBox(width: 12.r),

        // -------- Save Plan Button --------
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<SipCalculationProvider>().saveCurrentSip(context);
              Fluttertoast.showToast(
                msg: "Plan Saved Successfully",
                backgroundColor: AppColors.cardBackground,
                fontSize: 18.spMin,
                textColor: Colors.white,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedPlansScreen()),
              );
            },
            child: Container(
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.primaryCta, // Primary blue
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark, color: Colors.white, size: 20.r),
                  SizedBox(width: 8.r),
                  Text('Save Plan', style: AppTextStyles.bold16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DonutPainter extends CustomPainter {
  final double investedRatio; // 0.0 → 1.0

  DonutPainter(this.investedRatio);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 18.r;
    final radius = size.width / 2 - stroke / 2;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final safeRatio = investedRatio.clamp(0.0, 1.0);
    final investedSweep = 2 * pi * safeRatio;
    final gainedSweep = 2 * pi * (1 - safeRatio);

    /// Base track
    final basePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    /// Invested (grey)
    final investedPaint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    /// Wealth gained (blue)
    final gainedPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Draw base ring
    canvas.drawArc(rect, 0, 2 * pi, false, basePaint);

    // Start angle (top)
    final startAngle = -pi / 2;

    // Draw invested part
    canvas.drawArc(rect, startAngle, investedSweep, false, investedPaint);

    // Draw wealth gained part
    canvas.drawArc(
      rect,
      startAngle + investedSweep,
      gainedSweep,
      false,
      gainedPaint,
    );
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) {
    return oldDelegate.investedRatio != investedRatio;
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> values;
  final double animationValue;

  LineChartPainter({required this.values, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxValue = values.reduce(max);
    if (maxValue <= 0) return;

    final strokeWidth = 3.r;
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final bottomPadding = 8.r;
    final chartHeight = size.height - bottomPadding;

    final count = values.length;
    final dx = count == 1 ? 0.0 : size.width / (count - 1);

    double getY(double value) {
      final normalized = (value / maxValue).clamp(0.0, 1.0);
      final topPaddingFactor = 0.85; // leave some space at top
      final effectiveHeight = chartHeight * topPaddingFactor;
      final y = chartHeight - normalized * effectiveHeight;
      return y;
    }

    final points = <Offset>[];
    for (int i = 0; i < count; i++) {
      final x = dx * i;
      final y = getY(values[i]);
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.quadraticBezierTo(controlX, p0.dy, p1.dx, p1.dy);
    }

    // Clip by animation progress from left to right
    canvas.save();
    final clipWidth = size.width * animationValue.clamp(0.0, 1.0);
    canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, size.height));
    canvas.drawPath(path, paint);
    canvas.restore();

    // Draw end dot
    final endProgressX = clipWidth;
    if (endProgressX > 0) {
      // Find corresponding y on the last segment for the current animated x
      final totalWidth = size.width;
      final tGlobal = (endProgressX / totalWidth).clamp(0.0, 1.0);
      final position = _samplePath(points, tGlobal);

      final dotPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position, strokeWidth * 1.2, dotPaint);
    }
  }

  Offset _samplePath(List<Offset> points, double t) {
    if (points.length == 1) return points.first;
    final segmentCount = points.length - 1;
    final scaled = t * segmentCount;
    final index = scaled.floor().clamp(0, segmentCount - 1);
    final localT = scaled - index;
    final p0 = points[index];
    final p1 = points[index + 1];
    return Offset(
      p0.dx + (p1.dx - p0.dx) * localT,
      p0.dy + (p1.dy - p0.dy) * localT,
    );
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.animationValue != animationValue;
  }
}
