import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle displaySerif({
    double size = 28,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double height = 1.15,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle title({
    double size = 20,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double height = 1.25,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textSecondary,
    double height = 1.45,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle label({
    double size = 12,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.textMuted,
    double height = 1.3,
    double letterSpacing = 0.6,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle button({
    double size = 15,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.textOnDark,
  }) {
    return GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);
  }
}
