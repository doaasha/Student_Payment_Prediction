import 'package:flutter/material.dart';
import '../student_data.dart';
import 'result_screen.dart';

class PredictionScreen extends StatefulWidget {
  final StudentData data;

  const PredictionScreen({
    super.key,
    required this.data,
  });

  @override
  State<PredictionScreen> createState() =>
      _PredictionScreenState();
}

class _PredictionScreenState
    extends State<PredictionScreen> {
  String? previousPaymentDelay;
  String? previousUnpaidFees;
  String? housing;
  String? governorate;

  final delayCountController =
      TextEditingController();

  final maxDelayDaysController =
      TextEditingController();

  final onTimePaymentCountController =
      TextEditingController();

  final distanceController =
      TextEditingController();

  @override
  void dispose() {
    delayCountController.dispose();
    maxDelayDaysController.dispose();
    onTimePaymentCountController.dispose();
    distanceController.dispose();
    super.dispose();
  }

  void showResult() {
    // =========================================
    // إضافة بيانات المرحلة الثالثة
    // إلى StudentData
    // =========================================

    widget.data.previousPaymentDelay =
        previousPaymentDelay;

    widget.data.delayCount =
        int.tryParse(
      delayCountController.text,
    );

    widget.data.maxDelayDays =
        int.tryParse(
      maxDelayDaysController.text,
    );

    widget.data.onTimePaymentCount =
        int.tryParse(
      onTimePaymentCountController.text,
    );

    widget.data.previousUnpaidFees =
        previousUnpaidFees;

    widget.data.housing = housing;

    widget.data.governorate = governorate;

    widget.data.distanceFromUniversity =
        double.tryParse(
      distanceController.text,
    );

    // =========================================
    // الانتقال إلى صفحة النتيجة
    // مع إرسال كل البيانات
    // =========================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
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
              // =================================
              // Header
              // =================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
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

              // =================================
              // Content
              // =================================

              Expanded(
                child:
                    SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .stretch,
                    children: [
                      const Text(
                        'بيانات السداد والسكن',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF29256F),
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      const Text(
                        'المرحلة 3 من 4',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Color(0xFF888895),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const _StepIndicator(
                        activeStep: 3,
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // =================================
                      // Previous payment delay
                      // =================================

                      _dropdown(
                        label:
                            'هل حدث تأخير سابق في السداد؟',
                        value:
                            previousPaymentDelay,
                        items: const [
                          'نعم',
                          'لا',
                        ],
                        onChanged:
                            (value) {
                          setState(() {
                            previousPaymentDelay =
                                value;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // Delay count
                      // =================================

                      _textField(
                        controller:
                            delayCountController,
                        label:
                            'عدد مرات التأخير',
                        hint:
                            'أدخل العدد',
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // Maximum delay days
                      // =================================

                      _textField(
                        controller:
                            maxDelayDaysController,
                        label:
                            'أقصى عدد أيام تأخير',
                        hint:
                            'أدخل عدد الأيام',
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // On-time payment count
                      // =================================

                      _textField(
                        controller:
                            onTimePaymentCountController,
                        label:
                            'عدد مرات السداد في الموعد',
                        hint:
                            'أدخل العدد',
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // Previous unpaid fees
                      // =================================

                      _dropdown(
                        label:
                            'هل توجد أقساط سابقة غير مسددة؟',
                        value:
                            previousUnpaidFees,
                        items: const [
                          'نعم',
                          'لا',
                        ],
                        onChanged:
                            (value) {
                          setState(() {
                            previousUnpaidFees =
                                value;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // Housing
                      // =================================

                      _dropdown(
                        label:
                            'نوع السكن',
                        value: housing,
                        items: const [
                          'ملك',
                          'ايجار',
                          'سكن جامعي',
                          'مع الأقارب',
                          'مخيم',
                        ],
                        onChanged:
                            (value) {
                          setState(() {
                            housing =
                                value;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // Governorate
                      // =================================

                      _dropdown(
                        label:
                            'المحافظة',
                        value:
                            governorate,
                        items: const [
                          'إدلب',
                          'الحسكة',
                          'الرقة',
                          'السويداء',
                          'القنيطرة',
                          'اللاذقية',
                          'حلب',
                          'حماة',
                          'حمص',
                          'درعا',
                          'دمشق',
                          'دير الزور',
                          'طرطوس',
                        ],
                        onChanged:
                            (value) {
                          setState(() {
                            governorate =
                                value;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      // =================================
                      // Distance
                      // =================================

                      _textField(
                        controller:
                            distanceController,
                        label:
                            'المسافة عن الجامعة',
                        hint:
                            'أدخل المسافة بالكيلومتر',
                        decimal: true,
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      // =================================
                      // Buttons
                      // =================================

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
                                  color:
                                      Color(
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
                                  color:
                                      Color(
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
                              onPressed:
                                  showResult,
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
                                    'إظهار النتيجة',
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

              const _BottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // Dropdown
  // =====================================================

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

        const SizedBox(
          height: 7,
        ),

        DropdownButtonFormField<
            String>(
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
                  BorderRadius
                      .circular(
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
                  Color(
                0xFF9999A5,
              ),
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

          onChanged:
              onChanged,
        ),
      ],
    );
  }

  // =====================================================
  // Text Field
  // =====================================================

  Widget _textField({
    required TextEditingController
        controller,
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

        const SizedBox(
          height: 7,
        ),

        TextField(
          controller:
              controller,
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
                  Color(
                0xFF9999A5,
              ),
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
                  BorderRadius
                      .circular(
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
          List.generate(
        4,
        (index) {
          final step =
              index + 1;

          return Expanded(
            child: Container(
              margin:
                  EdgeInsets.only(
                left: index == 3
                    ? 0
                    : 4,
              ),
              height: 5,
              decoration:
                  BoxDecoration(
                color: step <=
                        activeStep
                    ? const Color(
                        0xFF655CFF,
                      )
                    : const Color(
                        0xFFE2E2EB,
                      ),
                borderRadius:
                    BorderRadius
                        .circular(
                  10,
                ),
              ),
            ),
          );
        },
      ),
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