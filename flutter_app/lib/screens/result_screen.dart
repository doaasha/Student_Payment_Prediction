import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../student_data.dart';

class ResultScreen extends StatefulWidget {
  final StudentData data;

  const ResultScreen({
    super.key,
    required this.data,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // =========================================================
  // FastAPI
  // =========================================================

  static const String apiUrl =
      'http://127.0.0.1:8000';

  // =========================================================
  // Result variables
  // =========================================================

  bool loading = true;
  String? errorMessage;

  String prediction = '';
  double lateProbability = 0;
  double onTimeProbability = 0;
  String modelName = '';

  // Model comparison
  List<Map<String, dynamic>> models = [];

  @override
  void initState() {
    super.initState();

    getPrediction();
  }

  // =========================================================
  // Send prediction request
  // =========================================================

  Future<void> getPrediction() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      // -------------------------------------------------------
      // التأكد من وجود البيانات المطلوبة
      // -------------------------------------------------------

      final missingFields =
          getMissingFields();

      if (missingFields.isNotEmpty) {
        setState(() {
          loading = false;
          errorMessage =
              'يرجى إدخال جميع البيانات المطلوبة:\n\n'
              '${missingFields.join('\n')}';
        });

        return;
      }

      // -------------------------------------------------------
      // تجهيز البيانات
      // -------------------------------------------------------

      final body = widget.data.toJson();

      // -------------------------------------------------------
      // إرسال الطلب إلى FastAPI
      // -------------------------------------------------------

      final response = await http.post(
        Uri.parse('$apiUrl/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // -------------------------------------------------------
      // التحقق من الاستجابة
      // -------------------------------------------------------

      if (response.statusCode == 200) {
        final result =
            jsonDecode(response.body);

        setState(() {
          prediction =
              result['prediction'] ?? '';

          lateProbability =
              (result['late_probability'] ?? 0)
                  .toDouble();

          onTimeProbability =
              (result['on_time_probability'] ?? 0)
                  .toDouble();

          modelName =
              result['model'] ?? '';

          loading = false;
        });

        // تحميل مقارنة النماذج
        await getModelComparison();
      } else {
        setState(() {
          loading = false;

          errorMessage =
              'حدث خطأ أثناء التنبؤ.\n\n'
              'رمز الخطأ: ${response.statusCode}\n\n'
              '${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;

        errorMessage =
            'تعذر الاتصال بالخادم.\n\n'
            'تأكدي من تشغيل FastAPI ثم حاولي مرة أخرى.';
      });
    }
  }

  // =========================================================
  // Model comparison
  // =========================================================

  Future<void> getModelComparison() async {
    try {
      final response =
          await http.get(
        Uri.parse(
          '$apiUrl/model-comparison',
        ),
      );

      if (response.statusCode == 200) {
        final result =
            jsonDecode(response.body);

        final modelList =
            result['models'];

        if (modelList is List) {
          setState(() {
            models =
                modelList
                    .map<Map<String, dynamic>>(
                      (item) =>
                          Map<String, dynamic>.from(
                        item,
                      ),
                    )
                    .toList();
          });
        }
      }
    } catch (_) {
      // إذا فشل تحميل المقارنة
      // لا نوقف عرض نتيجة التنبؤ
    }
  }

  // =========================================================
  // Check missing fields
  // =========================================================

  List<String> getMissingFields() {
    final List<String> missing = [];

    if (widget.data.branch == null) {
      missing.add('الفرع');
    }

    if (widget.data.approxInstallmentValue ==
        null) {
      missing.add('قيمة القسط التقريبية');
    }

    if (widget.data.paymentResponsible ==
        null) {
      missing.add('المسؤول عن الدفع');
    }

    if (widget.data.worksWhileStudying ==
        null) {
      missing.add('العمل أثناء الدراسة');
    }

    if (widget.data.governorate == null) {
      missing.add('المحافظة');
    }

    if (widget.data.registeredHours == null) {
      missing.add('عدد الساعات المسجلة');
    }

    if (widget.data.previousPaymentDelay ==
        null) {
      missing.add('التأخير السابق');
    }

    if (widget.data.gpa == null) {
      missing.add('المعدل');
    }

    if (widget.data.attendanceRate == null) {
      missing.add('نسبة الحضور');
    }

    if (widget.data.delayCount == null) {
      missing.add('عدد مرات التأخير');
    }

    if (widget.data.maxDelayDays == null) {
      missing.add('أقصى عدد أيام تأخير');
    }

    if (widget.data.onTimePaymentCount ==
        null) {
      missing.add('عدد مرات السداد في الموعد');
    }

    if (widget.data.familyMonthlyIncome ==
        null) {
      missing.add('دخل الأسرة الشهري');
    }

    if (widget.data.privateUniversitySiblings ==
        null) {
      missing.add(
        'عدد الإخوة في التعليم الجامعي الخاص',
      );
    }

    if (widget.data.semesterFee == null) {
      missing.add('قيمة القسط الفصلي');
    }

    if (widget.data.studyYear == null) {
      missing.add('السنة الدراسية');
    }

    if (widget.data.workingFamilyMembers ==
        null) {
      missing.add(
        'عدد أفراد الأسرة العاملين',
      );
    }

    if (widget.data.previousUnpaidFees ==
        null) {
      missing.add(
        'الأقساط السابقة غير المسددة',
      );
    }

    if (widget.data.housing == null) {
      missing.add('نوع السكن');
    }

    if (widget.data.distanceFromUniversity ==
        null) {
      missing.add(
        'المسافة عن الجامعة',
      );
    }

    return missing;
  }

  // =========================================================
  // Build
  // =========================================================

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
              // =================================================
              // Header
              // =================================================

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

              // =================================================
              // Content
              // =================================================

              Expanded(
                child: loading
                    ? _loadingView()
                    : errorMessage != null
                        ? _errorView()
                        : _resultView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Loading
  // =========================================================

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 45,
            height: 45,
            child:
                CircularProgressIndicator(
              strokeWidth: 4,
              color: Color(0xFF655CFF),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'جاري تحليل البيانات...',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
              color:
                  Color(0xFF29256F),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'يرجى الانتظار',
            style: TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF888895),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Error
  // =========================================================

  Widget _errorView() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFFFEEEE),
                shape:
                    BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color:
                    Color(0xFFD95D5D),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'تعذر الحصول على النتيجة',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF29256F),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              errorMessage ?? '',
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.7,
                color:
                    Color(0xFF777783),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    getPrediction,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF29256F,
                  ),
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                child:
                    const Text(
                  'إعادة المحاولة',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child:
                    const Text(
                  'العودة',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Result
  // =========================================================

  Widget _resultView() {
    final bool isLate =
        prediction == 'late';

    return SingleChildScrollView(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        25,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const Text(
            'نتيجة التنبؤ',
            style: TextStyle(
              fontSize: 27,
              fontWeight:
                  FontWeight.bold,
              color:
                  Color(0xFF29256F),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'النتيجة المتوقعة بناءً على البيانات المدخلة',
            style: TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF888895),
            ),
          ),

          const SizedBox(height: 25),

          // =================================================
          // Main result card
          // =================================================

          Container(
            padding:
                const EdgeInsets.all(22),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.04),
                  blurRadius: 15,
                  offset:
                      const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration:
                      BoxDecoration(
                    color: isLate
                        ? const Color(
                            0xFFFFEEEE,
                          )
                        : const Color(
                            0xFFE8F8EF,
                          ),
                    shape:
                        BoxShape.circle,
                  ),
                  child: Icon(
                    isLate
                        ? Icons.warning_amber
                        : Icons.check,
                    size: 38,
                    color: isLate
                        ? const Color(
                            0xFFD95D5D,
                          )
                        : const Color(
                            0xFF2EAA68,
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  isLate
                      ? 'من المتوقع تأخر سداد القسط'
                      : 'من المتوقع سداد القسط في الموعد',
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF29256F),
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'نتيجة النموذج',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Color(0xFF888895),
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child:
                          _ProbabilityBox(
                        title:
                            'احتمال السداد في الموعد',
                        value:
                            '${(onTimeProbability * 100).toStringAsFixed(1)}%',
                        valueColor:
                            const Color(
                          0xFF2EAA68,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          _ProbabilityBox(
                        title:
                            'احتمال التأخير',
                        value:
                            '${(lateProbability * 100).toStringAsFixed(1)}%',
                        valueColor:
                            const Color(
                          0xFFE36A6A,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // =================================================
          // Best model
          // =================================================

          Container(
            padding:
                const EdgeInsets.all(18),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'أفضل نموذج مستخدم',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF29256F),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.auto_graph,
                      color:
                          Color(0xFF655CFF),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Text(
                        modelName,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(
                            0xFF444451,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // =================================================
          // Model comparison
          // =================================================

          if (models.isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مقارنة النماذج',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF29256F),
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  ...models.map(
                    (model) {
                      final name =
                          model['name']
                              ?.toString() ??
                              '';

                      final accuracy =
                          (model['accuracy'] ??
                                  0)
                              .toDouble();

                      return Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          bottom: 14,
                        ),
                        child:
                            _ModelBar(
                          name: name,
                          value:
                              accuracy,
                          percentage:
                              '${(accuracy * 100).toStringAsFixed(1)}%',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 18),

          // =================================================
          // Note
          // =================================================

          Container(
            padding:
                const EdgeInsets.all(16),
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFEFEFFF),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: const Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color:
                      Color(0xFF655CFF),
                  size: 21,
                ),

                SizedBox(width: 9),

                Expanded(
                  child: Text(
                    'هذه النتيجة تقديرية وتعتمد على البيانات المدخلة والنموذج المدرب.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.6,
                      color:
                          Color(0xFF666675),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // =================================================
          // New prediction
          // =================================================

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) =>
                      route.isFirst,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF29256F,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
              ),
              child: const Text(
                'تنبؤ جديد',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // =================================================
          // Close
          // =================================================

          SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) =>
                      route.isFirst,
                );
              },
              style:
                  OutlinedButton.styleFrom(
                side:
                    const BorderSide(
                  color:
                      Color(0xFFD8D7E7),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
              ),
              child: const Text(
                'إغلاق',
                style: TextStyle(
                  color:
                      Color(0xFF6D6D78),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// Probability Box
// =============================================================

class _ProbabilityBox
    extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _ProbabilityBox({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(13),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF8F8FC),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color: valueColor,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color:
                  Color(0xFF777783),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// Model Bar
// =============================================================

class _ModelBar
    extends StatelessWidget {
  final String name;
  final double value;
  final String percentage;

  const _ModelBar({
    required this.name,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style:
                    const TextStyle(
                  fontSize: 11,
                  color:
                      Color(0xFF555560),
                ),
              ),
            ),

            Text(
              percentage,
              style:
                  const TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF29256F),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          child:
              LinearProgressIndicator(
            value: value.clamp(
              0.0,
              1.0,
            ),
            minHeight: 8,
            backgroundColor:
                const Color(
              0xFFE8E8F0,
            ),
            valueColor:
                const AlwaysStoppedAnimation<
                    Color>(
              Color(0xFF655CFF),
            ),
          ),
        ),
      ],
    );
  }
}