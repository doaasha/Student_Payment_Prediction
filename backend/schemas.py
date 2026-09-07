from typing import Literal

from pydantic import BaseModel, Field


# =========================================================
# القيم الفئوية المسموح بها
# =========================================================

YesNo = Literal[
    "نعم",
    "لا"
]


Branch = Literal[
    "كلية الهندسة المعلوماتية",
    "معهد أمن المعلومات والشبكات",
    "معهد نظم المعلومات الإدارية",
    "كلية إدارة الأعمال",
    "كلية الاقتصاد",
    "كلية التمريض",
    "كلية الحقوق",
    "كلية الصيدلة",
    "كلية الهندسة المدنية",
    "كلية الهندسة المعمارية"
]


PaymentResponsible = Literal[
    "الأسرة(اب-أم)",
    "الطالب",
    "الطالب والأسرة",
    "منحة/جهة داعمة"
]


Governorate = Literal[
    "إدلب",
    "الحسكة",
    "الرقة",
    "السويداء",
    "القنيطرة",
    "اللاذقية",
    "حلب",
    "حماة",
    "حمص",
    "درعا",
    "دمشق",
    "دير الزور",
    "طرطوس"
]


FamilyMonthlyIncome = Literal[
    "اقل من 100",
    "بين 100 و 200",
    "بين 200 و 500",
    "بين 500 و 1000",
    "اكثر من 1000"
]


StudyYear = Literal[
    "أولى",
    "ثانية",
    "ثالثة",
    "رابعة",
    "خامسة"
]


Housing = Literal[
    "ملك",
    "ايجار",
    "سكن جامعي",
    "مع الأقارب",
    "مخيم"
]


# =========================================================
# بيانات الطالب الداخلة إلى النموذج
# =========================================================

class StudentInput(BaseModel):

    branch: Branch = Field(
        ...,
        description="الفرع أو الكلية التي يدرس بها الطالب"
    )

    approx_installment_value: float = Field(
        ...,
        gt=0,
        description="قيمة القسط التقريبية"
    )

    payment_responsible: PaymentResponsible = Field(
        ...,
        description="الجهة المسؤولة عن دفع القسط"
    )

    works_while_studying: YesNo = Field(
        ...,
        description="هل يعمل الطالب إلى جانب الدراسة"
    )

    governorate: Governorate = Field(
        ...,
        description="محافظة الطالب"
    )

    registered_hours: int = Field(
        ...,
        ge=0,
        le=30,
        description="عدد الساعات المسجلة"
    )

    previous_payment_delay: YesNo = Field(
        ...,
        description="هل سبق للطالب التأخر في دفع القسط"
    )

    gpa: float = Field(
        ...,
        ge=0,
        le=100,
        description="المعدل التراكمي من 100"
    )

    attendance_rate: float = Field(
        ...,
        ge=0,
        le=100,
        description="نسبة الحضور من 100"
    )

    delay_count: int = Field(
        ...,
        ge=0,
        description="عدد مرات التأخر السابقة في دفع القسط"
    )

    max_delay_days: int = Field(
        ...,
        ge=0,
        description="أقصى عدد أيام تأخر بها الطالب سابقًا"
    )

    on_time_payment_count: int = Field(
        ...,
        ge=0,
        description="عدد مرات دفع القسط في الموعد"
    )

    family_monthly_income: FamilyMonthlyIncome = Field(
        ...,
        description="فئة الدخل الشهري للأسرة"
    )

    private_university_siblings: int = Field(
        ...,
        ge=0,
        description="عدد الإخوة والأخوات في التعليم الجامعي الخاص"
    )

    semester_fee: float = Field(
        ...,
        gt=10,
        description="قيمة القسط الفصلي التقديرية"
    )

    study_year: StudyYear = Field(
        ...,
        description="السنة الدراسية الحالية"
    )

    working_family_members: int = Field(
        ...,
        ge=0,
        description="عدد الأشخاص العاملين في الأسرة"
    )

    previous_unpaid_fees: YesNo = Field(
        ...,
        description="هل توجد أقساط جامعية سابقة غير مسددة"
    )

    housing: Housing = Field(
        ...,
        description="نوع سكن الطالب"
    )

    distance_from_university: float = Field(
        ...,
        ge=0,
        le=1000,
        description="بعد سكن الطالب عن الجامعة بالكيلومتر"
    )


# =========================================================
# نتيجة التنبؤ
# =========================================================

class PredictionResponse(BaseModel):

    prediction: Literal[
        "late",
        "on_time"
    ]

    late_probability: float = Field(
        ...,
        ge=0,
        le=1
    )

    on_time_probability: float = Field(
        ...,
        ge=0,
        le=1
    )

    model: str


# =========================================================
# نتيجة نموذج واحد ضمن المقارنة
# =========================================================

class ModelMetrics(BaseModel):

    name: str

    accuracy: float = Field(
        ...,
        ge=0,
        le=1
    )

    precision: float = Field(
        ...,
        ge=0,
        le=1
    )

    recall: float = Field(
        ...,
        ge=0,
        le=1
    )

    f1: float = Field(
        ...,
        ge=0,
        le=1
    )

    roc_auc: float = Field(
        ...,
        ge=0,
        le=1
    )

    is_best: bool


# =========================================================
# استجابة مقارنة النماذج
# =========================================================

class ModelComparisonResponse(BaseModel):

    selection_metric: str

    comparison_method: str

    best_model: str

    models: list[ModelMetrics]


# =========================================================
# معلومات النموذج النهائي
# =========================================================

class ModelInfoResponse(BaseModel):

    model_name: str

    selection_metric: str

    features: list[str]

    categorical_features: list[str]

    numeric_features: list[str]

    test_metrics: dict[str, float]


# =========================================================
# استجابة الصفحة الرئيسية للـ API
# =========================================================

class APIStatusResponse(BaseModel):

    status: str

    message: str

    model_loaded: bool