import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const StudentPaymentApp());
}

class StudentPaymentApp extends StatelessWidget {
  const StudentPaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDAD ML',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const SplashScreen(),
    );
  }
}