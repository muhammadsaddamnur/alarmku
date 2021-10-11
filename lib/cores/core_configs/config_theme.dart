import 'package:flutter/material.dart';

class ConfigTheme {
  ///configuration global theme data
  ///
  static ThemeData themeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xff00AA13),
      colorScheme: const ColorScheme(
          primary: Color(0xFF00AB6B),
          primaryVariant: Color(0xFF00AB6B),
          secondary: Color(0xFFD2F3E6),
          secondaryVariant: Color(0xFFD2F3E6),
          surface: Color(0xFFD2F3E6),
          background: Colors.white,
          error: Colors.red,
          onPrimary: Color(0xFF00AB6B),
          onSecondary: Color(0xFFD2F3E6),
          onSurface: Color(0xFFD2F3E6),
          onBackground: Colors.white,
          onError: Colors.red,
          brightness: Brightness.light));
}
