import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum InputFieldType { amount, percentage, year }

class AppTextStyles {
  // ===== Base Poppins Style =====
  static final TextStyle _base = GoogleFonts.poppins(color: Colors.white);

  // ===== Font Weights =====
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ===== Custom TextStyle =====
  static TextStyle custom({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.white,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    return _base.copyWith(
      fontSize: size.spMin,
      fontWeight: weight,
      color: color,
      overflow: overflow,
    );
  }

  // ===== Regular =====
  static final TextStyle regular14 = _base.copyWith(
    fontSize: 14.spMin,
    fontWeight: regular,
  );
  static final TextStyle regular12 = _base.copyWith(
    fontSize: 12.spMin,
    fontWeight: regular,
  );

  static final TextStyle regular16 = _base.copyWith(
    fontSize: 16.spMin,
    fontWeight: regular,
  );

  static final TextStyle regular18 = _base.copyWith(
    fontSize: 18.spMin,
    fontWeight: regular,
  );

  static final TextStyle regular20 = _base.copyWith(
    fontSize: 20.spMin,
    fontWeight: regular,
  );

  static final TextStyle regular22 = _base.copyWith(
    fontSize: 22.spMin,
    fontWeight: regular,
  );

  // ===== Medium =====
  static final TextStyle medium14 = _base.copyWith(
    fontSize: 14.spMin,
    fontWeight: medium,
  );
  static final TextStyle medium12 = _base.copyWith(
    fontSize: 12.spMin,
    fontWeight: medium,
  );

  static final TextStyle medium16 = _base.copyWith(
    fontSize: 16.spMin,
    fontWeight: medium,
  );

  static final TextStyle medium18 = _base.copyWith(
    fontSize: 18.spMin,
    fontWeight: medium,
  );

  static final TextStyle medium20 = _base.copyWith(
    fontSize: 20.spMin,
    fontWeight: medium,
  );

  static final TextStyle medium22 = _base.copyWith(
    fontSize: 22.spMin,
    fontWeight: medium,
  );

  // ===== Semi-Bold =====
  static final TextStyle semiBold14 = _base.copyWith(
    fontSize: 14.spMin,
    fontWeight: semiBold,
  );
  static final TextStyle semiBold12 = _base.copyWith(
    fontSize: 12.spMin,
    fontWeight: semiBold,
  );

  static final TextStyle semiBold16 = _base.copyWith(
    fontSize: 16.spMin,
    fontWeight: semiBold,
  );

  static final TextStyle semiBold18 = _base.copyWith(
    fontSize: 18.spMin,
    fontWeight: semiBold,
  );

  static final TextStyle semiBold20 = _base.copyWith(
    fontSize: 20.spMin,
    fontWeight: semiBold,
  );

  static final TextStyle semiBold22 = _base.copyWith(
    fontSize: 22.spMin,
    fontWeight: semiBold,
  );

  // ===== Bold =====
  static final TextStyle bold14 = _base.copyWith(
    fontSize: 14.spMin,
    fontWeight: bold,
  );
  static final TextStyle bold12 = _base.copyWith(
    fontSize: 12.spMin,
    fontWeight: bold,
  );

  static final TextStyle bold16 = _base.copyWith(
    fontSize: 16.spMin,
    fontWeight: bold,
  );

  static final TextStyle bold18 = _base.copyWith(
    fontSize: 18.spMin,
    fontWeight: bold,
  );

  static final TextStyle bold20 = _base.copyWith(
    fontSize: 20.spMin,
    fontWeight: bold,
  );

  static final TextStyle bold22 = _base.copyWith(
    fontSize: 22.spMin,
    fontWeight: bold,
  );
}
