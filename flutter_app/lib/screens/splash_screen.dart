import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // الانتظار 4 ثواني قبل الانتقال للصفحة الرئيسية
    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FF),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EEFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                bottom: -120,
                left: -120,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EEFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo_sd.png',
                        width: 190,
                        height: 100,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'تنبؤ أذكى لأقساطك الدراسية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF273078),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'تحليل ذكي .. قرارات أفضل ..',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6F789D),
                        ),
                      ),

                      const Text(
                        'لمستقبل دراسي أكثر استقراراً',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6F789D),
                        ),
                      ),

                      const SizedBox(height: 35),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 22,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5147F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(width: 5),

                          Container(
                            width: 9,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8D7F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(width: 5),

                          Container(
                            width: 9,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8D7F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}