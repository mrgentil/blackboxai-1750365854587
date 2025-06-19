import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/theme_service.dart';
import 'services/user_service.dart';
import 'utils/constants.dart';

void main() {
  runApp(const ChurchApp());
}

class ChurchApp extends StatefulWidget {
  const ChurchApp({Key? key}) : super(key: key);

  @override
  State<ChurchApp> createState() => _ChurchAppState();
}

class _ChurchAppState extends State<ChurchApp> {
  final ThemeService _themeService = ThemeService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _themeService.addListener(_handleThemeChange);
    _userService.addListener(_handleAuthChange);
  }

  @override
  void dispose() {
    _themeService.removeListener(_handleThemeChange);
    _userService.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _handleThemeChange() {
    setState(() {});
  }

  void _handleAuthChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: _themeService.lightTheme,
      darkTheme: _themeService.darkTheme,
      themeMode: _themeService.themeMode,
      debugShowCheckedModeBanner: false,
      home: _userService.currentUser != null
          ? const HomeScreen()
          : const LoginScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
