import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color surface = Color(0xFF111317);
  static const Color card = Color(0xFF1C1E25);
  static const Color primary = Color(0xFFFFB74D);
  static const Color accent = Color(0xFFFFCC80);
  static const Color button = Color(0xFFFFA726);
  static const Color altButton = Color(0xFF1A1C23);
  static const Color buttonText = Colors.white;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFFFE0B2);
  static const Color iconSelected = Color(0xFFFFB74D);
  static const Color error = Color(0xFFFF5C5C);
  static const Color navbar = Color(0xFF1A1C23);
  static const Color success = Colors.green;
}

final colorScheme = ColorScheme.dark(
  primary: AppColors.primary,
  secondary: AppColors.accent,
  surface: AppColors.surface,
  error: AppColors.error,
  onPrimary: AppColors.buttonText,
  onSecondary: AppColors.textPrimary,
  onSurface: AppColors.textPrimary,
  onError: AppColors.buttonText,
);

final _theme = ThemeData.from(colorScheme: colorScheme, useMaterial3: true);

final ThemeData appTheme = _theme.copyWith(
  scaffoldBackgroundColor: AppColors.surface,
  cardTheme: const CardThemeData(
    color: AppColors.card,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    elevation: 2,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 1,
    titleTextStyle: GoogleFonts.raleway(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColors.primary),
  ),
  textTheme: GoogleFonts.ralewayTextTheme().apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.button,
      foregroundColor: AppColors.buttonText,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      textStyle: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 16),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  dividerTheme: const DividerThemeData(color: Color(0x22FFFFFF)),
);
