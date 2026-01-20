import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/model/sip_projection.dart';
import 'package:sip_calculator/features/sip_calculator/provider/calculation_provider.dart';
import 'package:sip_calculator/utils/app_text_styles.dart';

class SipDataTable extends StatelessWidget {
  const SipDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SipCalculationProvider>();

    final rows = buildSipTableRows(
      totalYears: provider.model.investmentYears.round(),
      monthlyAmount: provider.model.monthlyInvestment,
      annualRate: provider.model.expectedReturn,
    );

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: Table(
        border: TableBorder.all(
          color: Colors.white.withOpacity(0.12),
          width: 1.r,
          borderRadius: BorderRadius.circular(20.r),
        ),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [_buildHeaderRow(), ...rows.map(_buildDataRow)],
      ),
    );
  }

  /// ---------------- Header Row ----------------
  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
      children: const [
        _HeaderCell('DURATION'),
        _HeaderCell('INVESTED AMOUNT'),
        _HeaderCell('FUTURE VALUE'),
      ],
    );
  }

  /// ---------------- Data Row ----------------
  TableRow _buildDataRow(SipTableRow row) {
    final textColor = row.isHighlighted
        ? const Color(0xFF00C38A)
        : Colors.white;

    return TableRow(
      decoration: BoxDecoration(
        color: row.isHighlighted
            ? const Color(0xFF00C38A).withOpacity(0.12)
            : Colors.transparent,
      ),
      children: [
        _DataCell(row.duration, textColor),
        _DataCell(row.amount, textColor),
        _DataCell(row.futureValue, textColor, isBold: true),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.r, horizontal: 5.r),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.regular12.copyWith(color: Colors.white70),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final Color color;
  final bool isBold;

  const _DataCell(this.text, this.color, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.r),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.medium14.copyWith(
            fontSize: 14.spMin,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ),
    );
  }
}
