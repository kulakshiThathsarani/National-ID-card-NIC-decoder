/// A Flutter application for decoding Sri Lankan National Identity Card (NIC) numbers.
///
/// This application allows users to input either the old format (9-digit + v/x)
/// or new format (12-digit) NIC numbers and displays decoded information such as
/// date of birth, gender, age, and voting eligibility.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/input_screen.dart';

/// The entry point for the application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// Sets up the theme, routes, and initial screen for the NIC Decoder application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  ///
  /// The [key] parameter is optional and is passed to the parent class.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NIC Decoder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF061552),
          primary: const Color(0xFF061552),
          secondary: const Color(0xFF00FFCC),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF061552),
          primary: const Color(0xFF061552),
          secondary: const Color(0xFF00FFCC),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const InputScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
