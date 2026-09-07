from pathlib import Path
import json

import joblib


# =========================================================
# تحديد مسارات المشروع
# =========================================================

# مسار مجلد backend
BACKEND_DIR = Path(__file__).resolve().parent

# مسار جذر المشروع
PROJECT_ROOT = BACKEND_DIR.parent

# مسار مجلد models
MODELS_DIR = PROJECT_ROOT / "models"


# =========================================================
# مسارات ملفات النموذج
# =========================================================

MODEL_PATH = (
    MODELS_DIR
    / "student_payment_classifier.joblib"
)

METADATA_PATH = (
    MODELS_DIR
    / "student_payment_classifier_metadata.json"
)

COMPARISON_PATH = (
    MODELS_DIR
    / "model_comparison.json"
)


# =========================================================
# التحقق من وجود الملفات
# =========================================================

def validate_model_files():
    """
    التأكد من أن جميع ملفات النموذج موجودة.
    """

    required_files = {
        "model": MODEL_PATH,
        "metadata": METADATA_PATH,
        "comparison": COMPARISON_PATH
    }

    missing_files = []

    for name, path in required_files.items():

        if not path.exists():

            missing_files.append(
                f"{name}: {path}"
            )

    if missing_files:

        missing_text = "\n".join(
            missing_files
        )

        raise FileNotFoundError(
            "بعض ملفات النموذج غير موجودة:\n"
            f"{missing_text}"
        )


# =========================================================
# تحميل النموذج
# =========================================================

def load_model():
    """
    تحميل Pipeline النموذج النهائي من ملف joblib.
    """

    validate_model_files()

    model = joblib.load(
        MODEL_PATH
    )

    return model


# =========================================================
# تحميل Metadata
# =========================================================

def load_metadata():
    """
    تحميل معلومات النموذج من ملف JSON.
    """

    validate_model_files()

    with open(
        METADATA_PATH,
        "r",
        encoding="utf-8"
    ) as file:

        metadata = json.load(
            file
        )

    return metadata


# =========================================================
# تحميل نتائج مقارنة النماذج
# =========================================================

def load_model_comparison():
    """
    تحميل نتائج مقارنة النماذج الثلاثة.
    """

    validate_model_files()

    with open(
        COMPARISON_PATH,
        "r",
        encoding="utf-8"
    ) as file:

        comparison = json.load(
            file
        )

    return comparison


# =========================================================
# تحميل جميع الملفات مرة واحدة
# =========================================================

def load_all_model_resources():
    """
    تحميل النموذج وجميع الملفات المرافقة له.
    """

    validate_model_files()

    model = joblib.load(
        MODEL_PATH
    )

    with open(
        METADATA_PATH,
        "r",
        encoding="utf-8"
    ) as file:

        metadata = json.load(
            file
        )

    with open(
        COMPARISON_PATH,
        "r",
        encoding="utf-8"
    ) as file:

        comparison = json.load(
            file
        )

    return (
        model,
        metadata,
        comparison
    )