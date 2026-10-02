import 'package:flutter/material.dart';
import '../student_data.dart';
import 'financial_screen.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  String? branch;
  String? studyYear;
  String? worksWhileStudying;

  final gpaController = TextEditingController();
  final registeredHoursController = TextEditingController();
  final attendanceRateController = TextEditingController();

  @override
  void dispose() {
    gpaController.dispose();
    registeredHoursController.dispose();
    attendanceRateController.dispose();
    super.dispose();
  }

  void goNext() {
    final data = StudentData();

    data.branch = branch;
    data.studyYear = studyYear;
    data.worksWhileStudying = worksWhileStudying;
    data.gpa = double.tryParse(gpaController.text);
    data.registeredHours = int.tryParse(registeredHoursController.text);
    data.attendanceRate = double.tryParse(attendanceRateController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FinancialScreen(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FF),
        body: SafeArea(
          child: Column(
            children: [
              _header(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'البيانات الأكاديمية',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF29256F),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'المرحلة 1 من 4',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888895),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const _StepIndicator(activeStep: 1),

                      const SizedBox(height: 25),

                      _dropdown(
                        label: 'الفرع',
                        value: branch,
                        items: const [
                          'كلية الهندسة المعلوماتية',
                          'معهد أمن المعلومات والشبكات',
                          'معهد نظم المعلومات الإدارية',
                          'كلية إدارة الأعمال',
                          'كلية الاقتصاد',
                          'كلية التمريض',
                          'كلية الحقوق',
                          'كلية الصيدلة',
                          'كلية الهندسة المدنية',
                          'كلية الهندسة المعمارية',
                        ],
                        onChanged: (value) {
                          setState(() => branch = value);
                        },
                      ),

                      const SizedBox(height: 14),

                      _dropdown(
                        label: 'السنة الدراسية',
                        value: studyYear,
                        items: const [
                          'أولى',
                          'ثانية',
                          'ثالثة',
                          'رابعة',
                          'خامسة',
                        ],
                        onChanged: (value) {
                          setState(() => studyYear = value);
                        },
                      ),

                      const SizedBox(height: 14),

                      _textField(
                        controller: gpaController,
                        label: 'المعدل',
                        hint: 'أدخل المعدل من 100',
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _textField(
                        controller: registeredHoursController,
                        label: 'عدد الساعات المسجلة',
                        hint: 'مثال: 18',
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      _textField(
                        controller: attendanceRateController,
                        label: 'نسبة الحضور',
                        hint: 'أدخل النسبة من 100',
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _dropdown(
                        label: 'هل تعمل أثناء الدراسة؟',
                        value: worksWhileStudying,
                        items: const ['نعم', 'لا'],
                        onChanged: (value) {
                          setState(() {
                            worksWhileStudying = value;
                          });
                        },
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('السابق'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: goNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF29256F),
                                foregroundColor: Colors.white,
                                minimumSize:
                                    const Size.fromHeight(52),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text('التالي'),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_back),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const _BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 13,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_forward,
              color: Color(0xFF29256F),
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/logo_sd.png',
            height: 45,
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D4D59),
          ),
        ),

        const SizedBox(height: 7),

        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text(
            'اختر $label',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9999A5),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D4D59),
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9999A5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int activeStep;

  const _StepIndicator({
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final step = index + 1;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: index == 3 ? 0 : 4,
            ),
            height: 5,
            decoration: BoxDecoration(
              color: step <= activeStep
                  ? const Color(0xFF655CFF)
                  : const Color(0xFFE2E2EB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.home_outlined,
            color: Color(0xFF9999A6),
          ),
          Icon(
            Icons.analytics_outlined,
            color: Color(0xFF29256F),
          ),
        ],
      ),
    );
  }
}