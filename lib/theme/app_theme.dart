// lib/theme/app_theme.dart
//
// WHY THIS FILE EXISTS:
// Instead of writing `color: Color(0xFFEDE6D6)` on every screen, we define
// it once here as `AppColors.background`. If you ever want to tweak the
// palette, you change it in exactly one place. This is a very common
// Flutter pattern — most real apps have a "theme" or "design tokens" file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors pulled from the mockup: warm cream background, soft card surface,
/// near-black ink for text, and a terracotta/rust accent for actions
/// (the record button, the "Publish" button, selected tab, etc).
class AppColors {
  static const background = Color(0xFFEDE6D6);
  static const surface = Color(0xFFF6F1E7);
  static const surfaceDark = Color(0xFF211C17); // used on the Record screen
  static const ink = Color(0xFF2B2620); // primary text
  static const inkMuted = Color(0xFF8A8171); // secondary text / timestamps
  static const border = Color(0xFFDDD4C0);
  static const accent = Color(0xFFC1552F); // rust/terracotta
  static const accentSoft = Color(0xFFE9D9C8);
}

/// Central place for the three typefaces the design calls for:
/// - Newsreader: serif, used for English poem titles/body (literary feel)
/// - Tiro Devanagari Hindi: serif for Nepali script, pairs visually with
///   Newsreader so English and Nepali poems feel like the same "family"
/// - Instrument Sans: the UI font — buttons, nav labels, timestamps
class AppFonts {
  static TextStyle english({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
  }) =>
      GoogleFonts.newsreader(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle nepali({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
  }) =>
      GoogleFonts.tiroDevanagariHindi(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle ui({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink,
  }) =>
      GoogleFonts.instrumentSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  /// Poems can be in either language — this picks the right font family
  /// automatically so screens don't have to branch every time.
  static TextStyle forLanguage(
    String languageCode, {
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
  }) {
    return languageCode == 'ne'
        ? nepali(size: size, weight: weight, color: color, height: height)
        : english(size: size, weight: weight, color: color, height: height);
  }
}

/// The actual ThemeData object we hand to MaterialApp in main.dart.
ThemeData buildKavitaTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      surface: AppColors.surface,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.instrumentSansTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.ink),
    ),
    dividerColor: AppColors.border,
  );
}
