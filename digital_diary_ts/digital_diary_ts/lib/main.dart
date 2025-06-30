import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/set_pin_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? pin = prefs.getString('user_pin');

  runApp(MyApp(isLoggedIn: isLoggedIn, hasPin: pin != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool hasPin;

  const MyApp({super.key, required this.isLoggedIn, required this.hasPin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Diary TS',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? const HomeScreen()
          : hasPin
              ? const LoginScreen()
              : const SetPinScreen(),
    );
  }
}
