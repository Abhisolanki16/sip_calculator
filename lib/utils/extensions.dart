import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

extension FinanceAmountFormatter on String {
  String formatAmount({bool compact = false}) {
    final isPositive = startsWith('+');
    final isNegative = startsWith('-');

    final prefix = isPositive
        ? '+ ₹'
        : isNegative
        ? '- ₹'
        : '₹ ';

    final cleaned = replaceAll(RegExp(r'[^\d.]'), '');
    final value = double.tryParse(cleaned);

    if (value == null) return this;

    if (!compact) {
      return '$prefix${NumberFormat.decimalPattern('en_IN').format(value.round())}';
    }

    return '$prefix${_financeCompact(value)}';
  }

  /// Finance-friendly compact formatter
  String _financeCompact(double value) {
    if (value >= 10000000) {
      return '${_round(value / 10000000)} Cr';
    }
    if (value >= 100000) {
      return '${_round(value / 100000)} L';
    }
    if (value >= 1000) {
      return '${_round(value / 1000)} K';
    }
    return value.toStringAsFixed(0);
  }

  /// Smart rounding (max 1 decimal)
  String _round(double value) {
    final rounded = value.toStringAsFixed(1);
    return rounded.endsWith('.0') ? rounded.replaceAll('.0', '') : rounded;
  }
}

/// ====================
/// 🔹 WIDGET EXTENSIONS
/// ====================
extension WidgetPadding on Widget {
  /// Add padding
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double h = 0, double v = 0}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
    child: this,
  );

  Widget paddingOnly({
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) => Padding(
    padding: EdgeInsets.only(left: l, top: t, right: r, bottom: b),
    child: this,
  );

  /// Add margin (wrap inside Container)
  Widget marginAll(double value) =>
      Container(margin: EdgeInsets.all(value), child: this);

  Widget marginSymmetric({double h = 0, double v = 0}) => Container(
    margin: EdgeInsets.symmetric(horizontal: h, vertical: v),
    child: this,
  );

  /// Alignment
  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);

  /// Background color
  Widget bg(Color color) => Container(color: color, child: this);

  /// Rounded corners
  Widget rounded(double radius) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);

  static Divider hDiv({
    Color? color,
    double thickness = 1,
    double indent = 0,
    double endIndent = 0,
    double? height,
  }) {
    return Divider(
      color: color ?? Colors.grey,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }

  static VerticalDivider vDiv({
    Color? color,
    double thickness = 1,
    double width = 20,
    double? indent,
    double? endIndent,
  }) {
    return VerticalDivider(
      color: color ?? Colors.grey,
      thickness: thickness,
      width: width,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// Shadow
  Widget shadow({
    Color color = Colors.black26,
    double blur = 8,
    double spread = 1,
    Offset offset = const Offset(2, 2),
  }) => Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: color,
          blurRadius: blur,
          spreadRadius: spread,
          offset: offset,
        ),
      ],
    ),
    child: this,
  );
}

/// ====================
/// 🔹 STRING EXTENSIONS
/// ====================
extension StringValidators on String {
  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isPhone => RegExp(r'^[0-9]{10}$').hasMatch(this);

  bool get isNumeric => double.tryParse(this) != null;

  String get capitalize =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";

  String get titleCase => split(" ").map((w) => w.capitalize).join(" ");

  String get removeSpaces => replaceAll(" ", "");

  /// Mask sensitive data (email, phone, etc.)
  String mask({int visible = 2}) {
    if (length <= visible) return this;
    return substring(0, visible) + "*" * (length - visible);
  }
}

/// ====================
/// 🔹 NUMBER EXTENSIONS
/// ====================
extension NumExtensions on num {
  String get toCurrency => "₹${toStringAsFixed(2)}";

  String get toPercent => "${this.toString()}%";

  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());

  double get toRadians => this * (3.1415926535 / 180.0);
  double get toDegrees => this * (180.0 / 3.1415926535);
}

/// ====================
/// 🔹 DATETIME EXTENSIONS
/// ====================
extension DateTimeExtensions on DateTime {
  String get formatDate =>
      "${day.toString().padLeft(2, '0')}/"
      "${month.toString().padLeft(2, '0')}/"
      "$year";

  String get formatTime =>
      "${hour.toString().padLeft(2, '0')}:"
      "${minute.toString().padLeft(2, '0')}";

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  String timeAgo() {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "Just now";
  }
}

/// ====================
/// 🔹 BUSINESS LOGIC HELPERS
/// ====================
extension BoolExtensions on bool {
  String get toYesNo => this ? "Yes" : "No";
  String get toOnOff => this ? "On" : "Off";
}

extension ListExtensions<T> on List<T> {
  bool get isNotEmptyList => isNotEmpty;
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> unique() => toSet().toList();
}

extension ContextX on BuildContext {
  /// 🔹 Screen sizes
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 🔹 Orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// 🔹 Theme & Colors
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// 🔹 Navigation
  Future<T?> push<T>(Widget page) =>
      Navigator.push(this, MaterialPageRoute(builder: (_) => page));

  void pop<T extends Object?>([T? result]) => Navigator.pop(this, result);

  Future<T?> pushReplacement<T, TO>(Widget page) =>
      Navigator.pushReplacement(this, MaterialPageRoute(builder: (_) => page));

  Future<T?> pushAndRemoveUntil<T>(Widget page) => Navigator.pushAndRemoveUntil(
    this,
    MaterialPageRoute(builder: (_) => page),
    (_) => false,
  );

  /// 🔹 Snackbars
  void showSnackBar(
    String message, {
    Color? bgColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor ?? colors.primary,
        duration: duration,
        action: action,
      ),
    );
  }

  /// 🔹 Dialogs
  Future<void> showAlert({
    required String title,
    required String message,
    String confirmText = "OK",
    VoidCallback? onConfirm,
  }) async {
    await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// 🔹 Bottom Sheet
  Future<T?> showCustomBottomSheet<T>(Widget child) async {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(this).viewInsets.bottom),
        child: child,
      ),
    );
  }

  /// 🔹 Loader
  void showLoader() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoader() {
    Navigator.of(this, rootNavigator: true).pop();
  }
}

extension DateTimeFormatExtensions on DateTime {
  /// Convert Local time to UTC
  DateTime toUtcDateTime() => toUtc();

  /// Convert UTC time to Local
  DateTime toLocalDateTime() => toLocal();

  /// Format Local time to readable String
  String formatLocal({String pattern = "yyyy-MM-dd HH:mm:ss"}) {
    final local = toLocal();
    return "${local.year.toString().padLeft(4, '0')}-"
        "${local.month.toString().padLeft(2, '0')}-"
        "${local.day.toString().padLeft(2, '0')} "
        "${local.hour.toString().padLeft(2, '0')}:"
        "${local.minute.toString().padLeft(2, '0')}:"
        "${local.second.toString().padLeft(2, '0')}";
  }

  /// Format UTC time to readable String
  String formatUtc({String pattern = "yyyy-MM-dd HH:mm:ss"}) {
    final utc = toUtc();
    return "${utc.year.toString().padLeft(4, '0')}-"
        "${utc.month.toString().padLeft(2, '0')}-"
        "${utc.day.toString().padLeft(2, '0')} "
        "${utc.hour.toString().padLeft(2, '0')}:"
        "${utc.minute.toString().padLeft(2, '0')}:"
        "${utc.second.toString().padLeft(2, '0')}";
  }

  /// Format: 25 Feb 25
  String get shortDayMonthYear => DateFormat("dd MMM yy").format(this);

  /// Format: 25 February 2025
  String get fullDayMonthYear => DateFormat("dd MMMM yyyy").format(this);

  /// Format: 25/02
  String get dayMonthSlash => DateFormat("dd/MM").format(this);

  /// Format: 25-02-2025
  String get dayMonthYearDash => DateFormat("dd-MM-yyyy").format(this);

  /// Format: Feb 25, 2025
  String get monthDayYear => DateFormat("MMM dd, yyyy").format(this);

  /// Format: Tuesday, 25 Feb 2025
  String get fullWeekDayMonthYear =>
      DateFormat("EEEE, dd MMM yyyy").format(this);

  /// Format: 25th Feb 2025
  String get dayWithSuffixMonthYear {
    int day = this.day;
    String suffix = "th";
    if (!(day >= 11 && day <= 13)) {
      switch (day % 10) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
      }
    }
    return "$day$suffix ${DateFormat("MMM yyyy").format(this)}";
  }
}
