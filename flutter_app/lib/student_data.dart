class StudentData {
  String? branch;
  double? approxInstallmentValue;
  String? paymentResponsible;
  String? worksWhileStudying;
  String? governorate;
  int? registeredHours;
  String? previousPaymentDelay;
  double? gpa;
  double? attendanceRate;
  int? delayCount;
  int? maxDelayDays;
  int? onTimePaymentCount;
  String? familyMonthlyIncome;
  int? privateUniversitySiblings;
  double? semesterFee;
  String? studyYear;
  int? workingFamilyMembers;
  String? previousUnpaidFees;
  String? housing;
  double? distanceFromUniversity;

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'approx_installment_value': approxInstallmentValue,
      'payment_responsible': paymentResponsible,
      'works_while_studying': worksWhileStudying,
      'governorate': governorate,
      'registered_hours': registeredHours,
      'previous_payment_delay': previousPaymentDelay,
      'gpa': gpa,
      'attendance_rate': attendanceRate,
      'delay_count': delayCount,
      'max_delay_days': maxDelayDays,
      'on_time_payment_count': onTimePaymentCount,
      'family_monthly_income': familyMonthlyIncome,
      'private_university_siblings': privateUniversitySiblings,
      'semester_fee': semesterFee,
      'study_year': studyYear,
      'working_family_members': workingFamilyMembers,
      'previous_unpaid_fees': previousUnpaidFees,
      'housing': housing,
      'distance_from_university': distanceFromUniversity,
    };
  }
}