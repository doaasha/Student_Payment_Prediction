import 'package:flutter/material.dart';
import 'academic_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF29256F);
  static const Color backgroundColor = Color(0xFFF8F8FF);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // User icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDECF8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Logo
                    Expanded(
                      child: Image.asset(
                        'assets/logo_sd.png',
                        height: 48,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Notification
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'مرحباً بك',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF25235F),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'نظام التنبؤ بسداد الأقساط',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B6B7A),
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        'استخدم البيانات المتاحة لمعرفة احتمال السداد في الموعد.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A8A96),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Small cards
                      Row(
                        children: const [
                          Expanded(
                            child: _InfoCard(
                              number: '4',
                              title: 'مراحل مكتملة',
                              icon: Icons.check_circle_outline,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              number: '1',
                              title: 'تنبؤ سابق',
                              icon: Icons.analytics_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Payment probability card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: CircularProgressIndicator(
                                      value: 0.638,
                                      strokeWidth: 8,
                                      backgroundColor:
                                          const Color(0xFFE8E8F2),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF655CFF),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '63%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 15),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'احتمال السداد في الموعد',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF29256F),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'تعكس النسبة الحالية احتمال قيام الطالب بسداد القسط في موعده.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.6,
                                      color: Color(0xFF777783),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Helpful information
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: primaryColor,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'معلومات مساعدة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            _CheckText(
                              text: 'أدخل البيانات بشكل صحيح للحصول على نتيجة أدق.',
                            ),
                            _CheckText(
                              text: 'جميع البيانات تستخدم لغرض التنبؤ فقط.',
                            ),
                            _CheckText(
                              text: 'يمكنك إعادة التنبؤ في أي وقت.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Start prediction button
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AcademicScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ابدأ التنبؤ الآن',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_back,
                                size: 21,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFEAEAF2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BottomItem(
                      icon: Icons.home_outlined,
                      title: 'الرئيسية',
                      active: true,
                    ),
                    _BottomItem(
                      icon: Icons.analytics_outlined,
                      title: 'ابدأ التنبؤ',
                      active: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AcademicScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;

  const _InfoCard({
    required this.number,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFF655CFF),
          ),
          const SizedBox(height: 2),
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              height: 1.1,
              fontWeight: FontWeight.bold,
              color: Color(0xFF29256F),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              height: 1.1,
              color: Color(0xFF777783),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckText extends StatelessWidget {
  final String text;

  const _CheckText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 17,
            color: Color(0xFF655CFF),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF656572),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final VoidCallback? onTap;

  const _BottomItem({
    required this.icon,
    required this.title,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active
                ? const Color(0xFF29256F)
                : const Color(0xFF9A9AA6),
            size: 23,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight:
                  active ? FontWeight.bold : FontWeight.normal,
              color: active
                  ? const Color(0xFF29256F)
                  : const Color(0xFF9A9AA6),
            ),
          ),
        ],
      ),
    );
  }
}