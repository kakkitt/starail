// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ... (이전 색상 및 NovaRound 폰트 패밀리 이름 정의는 동일) ...
  static const Color luminaPink = Color(0xFFFF5E9A);
  static const Color luminaPurple = Color(0xFF9C50FF);

  static const Color lightPrimaryBackground = Color(0xFFFDFCFE);
  static const Color lightSecondaryBackground = Color(0xFFF8F7FA);
  static const Color lightPrimaryText = Color(0xFF332E50);
  static const Color lightSecondaryText = Color(0xFF8A8A8E);
  static const Color lightAccent = luminaPink;
  static const Color lightBottomNavBackground = Colors.white;
  static const Color lightUnselectedTabIcon = Color(0xFFB0AEC2);
  static const Color darkSurfaceColor = Color(0xFF2C2C2E);

  static const Color darkPrimaryBackground = Color(0xFF201D33);
  static const Color darkSecondaryBackground = Color(0xFF302C48);
  static const Color darkPrimaryText = Color(0xFFEAE6FF);
  static const Color darkSecondaryText = Color(0xFFB0AEC2);
  static const Color darkAccent = luminaPink;
  static const Color darkBottomNavBackground = Color(0xFF2A2649);
  static const Color darkUnselectedTabIcon = Color(0xFF8A8A8E);

  static const String novaRoundFontFamily = 'NovaRound';
  static const String pretendardFontFamily = 'Pretendard';

  static TextTheme _buildTextTheme(TextTheme base, Color textColor, Color headlineColor) {
    // Material 기본 TextTheme을 가져와서 폰트 패밀리와 색상 등을 오버라이드합니다.
    return base.copyWith(
      displayLarge: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 57, fontWeight: FontWeight.bold, color: headlineColor),
      displayMedium: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 45, fontWeight: FontWeight.bold, color: headlineColor),
      displaySmall: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 36, fontWeight: FontWeight.bold, color: headlineColor),

      headlineLarge: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 32, fontWeight: FontWeight.w700, color: headlineColor),
      headlineMedium: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 28, fontWeight: FontWeight.w700, color: headlineColor),
      headlineSmall: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 24, fontWeight: FontWeight.w700, color: headlineColor),

      titleLarge: base.titleLarge?.copyWith(fontFamily: pretendardFontFamily, fontSize: 22, fontWeight: FontWeight.w700, color: textColor), // Bold
      titleMedium: base.titleMedium?.copyWith(fontFamily: pretendardFontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: textColor), // SemiBold
      titleSmall: base.titleSmall?.copyWith(fontFamily: pretendardFontFamily, fontSize: 14, fontWeight: FontWeight.w500, color: textColor), // Medium

      bodyLarge: base.bodyLarge?.copyWith(fontFamily: pretendardFontFamily, fontSize: 16, fontWeight: FontWeight.w400, color: textColor, height: 1.5), // Regular
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: pretendardFontFamily, fontSize: 14, fontWeight: FontWeight.w400, color: textColor, height: 1.5), // Regular
      bodySmall: base.bodySmall?.copyWith(fontFamily: pretendardFontFamily, fontSize: 12, fontWeight: FontWeight.w400, color: textColor, height: 1.4), // Regular

      labelLarge: base.labelLarge?.copyWith(fontFamily: pretendardFontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: textColor), // SemiBold
      labelMedium: base.labelMedium?.copyWith(fontFamily: pretendardFontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: textColor), // Medium
      labelSmall: base.labelSmall?.copyWith(fontFamily: pretendardFontFamily, fontSize: 11, fontWeight: FontWeight.w500, color: textColor), // Medium
    ).apply(
      // 전반적인 body, display 색상을 textColor, headlineColor로 설정
      bodyColor: textColor,
      displayColor: headlineColor,
    );
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: luminaPink,
    scaffoldBackgroundColor: lightPrimaryBackground,
    colorScheme: const ColorScheme.light(
      primary: luminaPink,
      secondary: luminaPurple,
      background: lightPrimaryBackground,
      surface: lightSecondaryBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightPrimaryText,
      onSurface: lightPrimaryText,
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme, lightPrimaryText, lightPrimaryText),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: lightPrimaryBackground,
      iconTheme: IconThemeData(color: lightPrimaryText),
      titleTextStyle: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 20, fontWeight: FontWeight.w600, color: lightPrimaryText),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightBottomNavBackground,
      selectedItemColor: luminaPink,
      unselectedItemColor: lightUnselectedTabIcon,
      selectedLabelStyle: TextStyle(fontFamily: pretendardFontFamily, fontSize: 12, fontWeight: FontWeight.w500), // Medium
      unselectedLabelStyle: TextStyle(fontFamily: pretendardFontFamily, fontSize: 12, fontWeight: FontWeight.w500), // Medium
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),
    iconTheme: IconThemeData(color: lightPrimaryText),
    dividerColor: Colors.grey[300],
  );

  // ThemeData darkTheme 정의 (BottomNavigationBarThemeData 부분만 확인)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: luminaPink,
    scaffoldBackgroundColor: darkPrimaryBackground,
    colorScheme: const ColorScheme.dark(
      primary: luminaPink,
      secondary: luminaPurple,
      background: darkPrimaryBackground,
      surface: darkSecondaryBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkPrimaryText,
      onSurface: darkPrimaryText,
      error: Colors.redAccent,
      onError: Colors.black,
    ),
    textTheme: _buildTextTheme(ThemeData.dark().textTheme, darkPrimaryText, darkPrimaryText),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: darkPrimaryBackground,
      iconTheme: IconThemeData(color: darkPrimaryText),
      titleTextStyle: TextStyle(fontFamily: novaRoundFontFamily, fontSize: 20, fontWeight: FontWeight.w600, color: darkPrimaryText),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkBottomNavBackground,
      selectedItemColor: luminaPink,
      unselectedItemColor: darkUnselectedTabIcon,
      selectedLabelStyle: TextStyle(fontFamily: pretendardFontFamily, fontSize: 12, fontWeight: FontWeight.w500), // Medium
      unselectedLabelStyle: TextStyle(fontFamily: pretendardFontFamily, fontSize: 12, fontWeight: FontWeight.w500), // Medium
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),
    iconTheme: IconThemeData(color: darkPrimaryText),
    dividerColor: Colors.grey[700],
  );
}