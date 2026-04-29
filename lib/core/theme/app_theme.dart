import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF7F8FC);
  static const card = Color(0xFFF1F3FA);
  static const primary = Color(0xFF2F6EA5);
  static const text = Color(0xFF20232A);
  static const mutedText = Color(0xFF7A7D85);
  static const border = Color(0xFFE4E7EF);
  static const chipBg = Color(0xFFE3F0FF);
}

class AppSpacing {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadius {
  static const card = 22.0;
  static const button = 18.0;
  static const image = 18.0;
  static const chip = 24.0;
}

class AppTextStyles {
  static const appTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const sectionTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const cardTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    height: 1.35,
  );

  static const bodyMuted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
    height: 1.35,
  );

  static const chip = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

class AppShadows {
  static const card = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];
}

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.appTitle,
      iconTheme: IconThemeData(color: AppColors.text),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.background,
      elevation: 0,
    ),
  );
}