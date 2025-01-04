import 'package:flutter/material.dart';

class AppTheme {
  static const mainColor = Color(0xFF15384E);

  static ThemeData lightTheme = ThemeData(
    primaryColor: mainColor,
    colorScheme: ColorScheme.light(
      primary: mainColor,
      secondary: mainColor.withValues(),
      surface: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color.fromARGB(255, 255, 255, 255),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 79, 89, 95),
      secondary: const Color.fromARGB(255, 192, 203, 210).withValues(),
      surface: Color(0xFF1E1E1E),
    ),
    iconTheme: IconThemeData(color: Color(0xFF15384E)),
  );
}
