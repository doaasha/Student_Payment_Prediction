import 'package:flutter/material.dart';
import '../student_data.dart';
import 'prediction_screen.dart';

class FinancialScreen extends StatefulWidget {
  final StudentData data;

  const FinancialScreen({
    super.key,
    required this.data,
  });

  @override
  State<FinancialScreen> createState() =>
      _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  String? paymentResponsible;
  String? familyMonthlyIncome;

  final approxInstallmentController =
      TextEditingController();

  final semesterFeeController =
      TextEditingController();

  final workingFamilyMembersController =
      TextEditingController();

  final privateUniversitySiblingsController =
      TextEditingController();

  @override
  void dispose() {
    approxInstallmentController.dispose();
    semesterFeeController.dispose();
    workingFamilyMembersController.dispose();
    privateUniversitySiblingsController.dispose();
    super.dispose();
  }

  void goNext() {
    // إضافة بيانات المرحلة المالية إلى نفس StudentData
    widget.data.approxInstallmentValue =
        double.tryParse(
      approxInstallmentController.text,
    );

    widget.data.semesterFee =
        double.tryParse(
      semesterFeeController.text,
    );

    widget.data.paymentResponsible =
        paymentResponsible;

    widget.data.familyMonthlyIncome =
        familyMonthlyIncome;

    widget.data.workingFamilyMembers =
        int.tryParse(
      workingFamilyMembersController.text,
    );

    widget.data.privateUniversitySiblings =
        int.tryParse(
      privateUniversitySiblingsController.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PredictionScreen(
          data: widget.data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF8F8FF),
        body: SafeArea(
          child: Column(
            children: [
              // =========================
              // Header
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        color:
                            Color(0xFF29256F),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/logo_sd.png',
                      height: 45,
                    ),
                  ],
                ),
              ),

              // =========================
              // Content
              // =========================
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'البيانات المالية',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF29256F),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'المرحلة 2 من 4',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Color(0xFF888895),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const _StepIndicator(
                        activeStep: 2,
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // قيمة القسط التقريبية
                      // =========================
                      _textField(
                        controller:
                            approxInstallmentController,
                        label:
                            'قيمة القسط التقريبية',
                        hint:
                            'أدخل قيمة القسط',
                        decimal: true,
                      ),

                      const SizedBox(height: 14),

                      // =========================
                      // قيمة القسط الفصلي
                      // =========================
                      _textField(
                        controller:
                            semesterFeeController,
                        label:
                            'قيمة القسط الفصلي',
                        hint:
                            'أدخل قيمة القسط الفصلي',
                        decimal: true,
                      ),

                      const SizedBox(height: 14),

                      // =========================
                      // المسؤول عن الدفع
                      // =========================
                      _dropdown(
                        label:
                            'المسؤول عن دفع القسط',
                        value:
                            paymentResponsible,
                        items: const [
                          'الأسرة(اب-أم)',
                          'الطالب',
                          'الطالب والأسرة',
                          'منحة/جهة داعمة',
                        ],
                        onChanged: (value) {
                          setState(() {
                            paymentResponsible =
                                value;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      // =========================
                      // دخل الأسرة
                      // =========================
                      _dropdown(
                        label:
                            'دخل الأسرة الشهري',
                        value:
                            familyMonthlyIncome,
                        items: const [
                          'اقل من 100',
                          'بين 100 و 200',
                          'بين 200 و 500',
                          'بين 500 و 1000',
                          'اكثر من 1000',
                        ],
                        onChanged: (value) {
                          setState(() {
                            familyMonthlyIncome =
                                value;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      // =========================
                      // أفراد الأسرة العاملين
                      // =========================
                      _textField(
                        controller:
                            workingFamilyMembersController,
                        label:
                            'عدد أفراد الأسرة العاملين',
                        hint:
                            'أدخل العدد',
                      ),

                      const SizedBox(height: 14),

                      // =========================
                      // الإخوة في الجامعة الخاصة
                      // =========================
                      _textField(
                        controller:
                            privateUniversitySiblingsController,
                        label:
                            'عدد الإخوة في التعليم الجامعي الخاص',
                        hint:
                            'أدخل العدد',
                      ),

                      const SizedBox(height: 28),

                      // =========================
                      // Buttons
                      // =========================
                      Row(
                        children: [
                          Expanded(
                            child:
                                OutlinedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              style:
                                  OutlinedButton
                                      .styleFrom(
                                minimumSize:
                                    const Size
                                        .fromHeight(
                                  52,
                                ),
                                side:
                                    const BorderSide(
                                  color: Color(
                                    0xFFD8D7E7,
                                  ),
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    15,
                                  ),
                                ),
                              ),
                              child:
                                  const Text(
                                'السابق',
                                style:
                                    TextStyle(
                                  color: Color(
                                    0xFF6D6D78,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            flex: 2,
                            child:
                                ElevatedButton(
                              onPressed: goNext,
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFF29256F,
                                ),
                                foregroundColor:
                                    Colors.white,
                                minimumSize:
                                    const Size
                                        .fromHeight(
                                  52,
                                ),
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    15,
                                  ),
                                ),
                              ),
                              child:
                                  const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Text(
                                    'التالي',
                                    style:
                                        TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons
                                        .arrow_back,
                                    size: 20,
                                  ),
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

              // =========================
              // Bottom Navigation
              // =========================
              const _BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Text Field
  // =========================================================

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool decimal = false,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
            color:
                Color(0xFF4D4D59),
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: controller,
          keyboardType: decimal
              ? const TextInputType
                  .numberWithOptions(
                  decimal: true,
                )
              : TextInputType.number,
          decoration:
              InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF9999A5),
            ),
            filled: true,
            fillColor:
                Colors.white,
            contentPadding:
                const EdgeInsets
                    .symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
              borderSide:
                  BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // Dropdown
  // =========================================================

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>
        onChanged,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
            color:
                Color(0xFF4D4D59),
          ),
        ),

        const SizedBox(height: 7),

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration:
              InputDecoration(
            filled: true,
            fillColor:
                Colors.white,
            contentPadding:
                const EdgeInsets
                    .symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
              borderSide:
                  BorderSide.none,
            ),
          ),
          hint: Text(
            'اختر $label',
            style:
                const TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF9999A5),
            ),
          ),
          items:
              items.map((item) {
            return DropdownMenuItem<
                String>(
              value: item,
              child: Text(
                item,
                style:
                    const TextStyle(
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// =========================================================
// Step Indicator
// =========================================================

class _StepIndicator
    extends StatelessWidget {
  final int activeStep;

  const _StepIndicator({
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          List.generate(4, (index) {
        final step = index + 1;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left:
                  index == 3 ? 0 : 4,
            ),
            height: 5,
            decoration:
                BoxDecoration(
              color: step <=
                      activeStep
                  ? const Color(
                      0xFF655CFF)
                  : const Color(
                      0xFFE2E2EB),
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// =========================================================
// Bottom Navigation
// =========================================================

class _BottomNavigation
    extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 12,
      ),
      decoration:
          const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
                Color(0xFFEAEAF2),
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,
        children: [
          Icon(
            Icons.home_outlined,
            color:
                Color(0xFF9999A6),
          ),
          Icon(
            Icons.analytics_outlined,
            color:
                Color(0xFF29256F),
          ),
        ],
      ),
    );
  }
}