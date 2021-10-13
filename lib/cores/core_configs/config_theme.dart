import 'package:flutter/material.dart';

class ConfigTheme {
  ///configuration global theme data
  ///
  static ThemeData themeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xff00AA13),
      colorScheme: const ColorScheme(
          primary: Color(0xFF00AB6B),
          primaryVariant: Color(0xFF07e391),
          secondary: Color(0xFFD2F3E6),
          secondaryVariant: Color(0xFFD2F3E6),
          surface: Color(0xFFD2F3E6),
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.light));
}
