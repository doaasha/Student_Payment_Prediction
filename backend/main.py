from pathlib import Path

import pandas as pd

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

from backend.schemas import (
    StudentInput,
    PredictionResponse,
    ModelComparisonResponse,
    ModelInfoResponse
)

from backend.model_loader import (
    load_all_model_resources
)


# =========================================================
# مسارات المشروع
# =========================================================

BACKEND_DIR = Path(__file__).resolve().parent

PROJECT_ROOT = BACKEND_DIR.parent

FRONTEND_DIR = PROJECT_ROOT / "frontend"


# =========================================================
# التأكد من وجود مجلد الواجهة
# =========================================================

if not FRONTEND_DIR.exists():

    raise FileNotFoundError(
        f"Frontend directory was not found: {FRONTEND_DIR}"
    )


# =========================================================
# تحميل النموذج وملفاته
# =========================================================

MODEL_LOADED = False

MODEL_LOAD_ERROR = None

model = None

metadata = None

comparison = None


try:

    model, metadata, comparison = (
        load_all_model_resources()
    )

    MODEL_LOADED = True


except Exception as error:

    MODEL_LOAD_ERROR = str(error)

    print(
        "Model loading error:"
    )

    print(
        MODEL_LOAD_ERROR
    )


# =========================================================
# إنشاء FastAPI
# =========================================================

app = FastAPI(

    title="Student Payment Prediction API",

    description=(
        "نظام للتنبؤ باحتمالية تأخر الطالب "
        "في سداد القسط الدراسي"
    ),

    version="1.0.0"
)


# =========================================================
# ملفات الواجهة الثابتة
# =========================================================

app.mount(

    "/static",

    StaticFiles(
        directory=FRONTEND_DIR
    ),

    name="static"
)


# =========================================================
# الصفحة الرئيسية
# =========================================================

@app.get(
    "/",
    include_in_schema=False
)
def frontend():

    index_path = (
        FRONTEND_DIR
        / "index.html"
    )


    if not index_path.exists():

        raise HTTPException(

            status_code=404,

            detail=(
                "Frontend index.html was not found"
            )

        )


    return FileResponse(
        index_path
    )


# =========================================================
# Health Check
# =========================================================

@app.get(
    "/health"
)
def health_check():

    if not MODEL_LOADED:

        return {

            "status":
                "error",

            "model_loaded":
                False,

            "error":
                MODEL_LOAD_ERROR

        }


    return {

        "status":
            "healthy",

        "model_loaded":
            True,

        "model_name":
            metadata[
                "model_name"
            ]

    }


# =========================================================
# معلومات النموذج
# =========================================================

@app.get(
    "/model-info",
    response_model=ModelInfoResponse
)
def get_model_info():

    if not MODEL_LOADED:

        raise HTTPException(

            status_code=503,

            detail=(
                "Model is not available"
            )

        )


    return {

        "model_name":
            metadata[
                "model_name"
            ],

        "selection_metric":
            metadata[
                "selection_metric"
            ],

        "features":
            metadata[
                "features"
            ],

        "categorical_features":
            metadata[
                "categorical_features"
            ],

        "numeric_features":
            metadata[
                "numeric_features"
            ],

        "test_metrics":
            metadata[
                "test_metrics"
            ]

    }


# =========================================================
# مقارنة النماذج
# =========================================================

@app.get(
    "/model-comparison",
    response_model=ModelComparisonResponse
)
def get_model_comparison():

    if not MODEL_LOADED:

        raise HTTPException(

            status_code=503,

            detail=(
                "Model resources are not available"
            )

        )


    return comparison


# =========================================================
# Prediction
# =========================================================

@app.post(
    "/predict",
    response_model=PredictionResponse
)
def predict_student_payment(
    student: StudentInput
):

    if not MODEL_LOADED:

        raise HTTPException(

            status_code=503,

            detail=(
                "Model is not available"
            )

        )


    try:

        # -----------------------------------------
        # تحويل بيانات Pydantic إلى Dictionary
        # -----------------------------------------

        student_dict = (
            student.model_dump()
        )


        # -----------------------------------------
        # تحويل البيانات إلى DataFrame
        # -----------------------------------------

        student_df = pd.DataFrame(
            [
                student_dict
            ]
        )


        # -----------------------------------------
        # ترتيب Features بنفس ترتيب التدريب
        # -----------------------------------------

        expected_features = (
            metadata[
                "features"
            ]
        )


        student_df = student_df[
            expected_features
        ]


        # -----------------------------------------
        # تنفيذ التنبؤ
        # -----------------------------------------

        predicted_class = int(

            model.predict(
                student_df
            )[0]

        )


        # -----------------------------------------
        # احتمالات الفئات
        # -----------------------------------------

        probabilities = (

            model.predict_proba(
                student_df
            )[0]

        )


        classes = list(
            model.classes_
        )


        late_index = (
            classes.index(
                1
            )
        )


        on_time_index = (
            classes.index(
                0
            )
        )


        late_probability = float(

            probabilities[
                late_index
            ]

        )


        on_time_probability = float(

            probabilities[
                on_time_index
            ]

        )


        # -----------------------------------------
        # تحويل النتيجة إلى نص
        # -----------------------------------------

        if predicted_class == 1:

            prediction = "late"

        else:

            prediction = "on_time"


        # -----------------------------------------
        # Response
        # -----------------------------------------

        return {

            "prediction":
                prediction,

            "late_probability":
                late_probability,

            "on_time_probability":
                on_time_probability,

            "model":
                metadata[
                    "model_name"
                ]

        }


    except HTTPException:

        raise


    except Exception as error:

        raise HTTPException(

            status_code=500,

            detail=(
                f"Prediction failed: {str(error)}"
            )

        )