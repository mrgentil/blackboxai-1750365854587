import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Singleton pattern
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _isDarkMode = false;
  ThemeMode _themeMode = ThemeMode.system;

  // Getters
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _themeMode;

  // Theme Colors
  static const Color _lightPrimaryColor = Color(0xFF1E88E5);
  static const Color _darkPrimaryColor = Color(0xFF90CAF9);

  static const Color _lightSecondaryColor = Color(0xFF42A5F5);
  static const Color _darkSecondaryColor = Color(0xFF64B5F6);

  static const Color _lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color _darkBackgroundColor = Color(0xFF121212);

  static const Color _lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color _darkSurfaceColor = Color(0xFF1E1E1E);

  static const Color _lightErrorColor = Color(0xFFE53935);
  static const Color _darkErrorColor = Color(0xFFEF5350);

  static const Color _lightTextColor = Color(0xFF000000);
  static const Color _darkTextColor = Color(0xFFFFFFFF);

  // Theme Data
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _lightPrimaryColor,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        error: _lightErrorColor,
        background: _lightBackgroundColor,
        surface: _lightSurfaceColor,
      ),
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackgroundColor,
        foregroundColor: _lightTextColor,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: _lightSurfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: _lightSurfaceColor,
      ),
      dividerTheme: DividerThemeData(
        color: _lightTextColor.withOpacity(0.1),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _lightTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _lightTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: _lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: _lightTextColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _lightTextColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: _lightTextColor,
          fontSize: 12,
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        error: _darkErrorColor,
        background: _darkBackgroundColor,
        surface: _darkSurfaceColor,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackgroundColor,
        foregroundColor: _darkTextColor,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: _darkSurfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: _darkSurfaceColor,
      ),
      dividerTheme: DividerThemeData(
        color: _darkTextColor.withOpacity(0.1),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _darkTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _darkTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: _darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: _darkTextColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _darkTextColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: _darkTextColor,
          fontSize: 12,
        ),
      ),
    );
  }

  // Theme Mode Methods
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _isDarkMode = mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      setThemeMode(ThemeMode.light);
    } else if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.system);
    }
  }

  String getThemeModeName() {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'Système';
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
    }
  }

  IconData getThemeModeIcon() {
    switch (_themeMode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.brightness_7;
      case ThemeMode.dark:
        return Icons.brightness_4;
    }
  }
}
