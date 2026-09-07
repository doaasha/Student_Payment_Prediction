const API_BASE_URL = "";


// =========================================================
// DOM READY
// =========================================================

document.addEventListener(
    "DOMContentLoaded",
    async function () {


        // =====================================================
        // ELEMENTS
        // =====================================================

        const studentForm =
            document.getElementById(
                "studentForm"
            );


        const formSteps =
            Array.from(
                document.querySelectorAll(
                    ".form-step"
                )
            );


        const sidebarSteps =
            Array.from(
                document.querySelectorAll(
                    ".sidebar-step"
                )
            );


        const previousButton =
            document.getElementById(
                "previousButton"
            );


        const nextButton =
            document.getElementById(
                "nextButton"
            );


        const predictButton =
            document.getElementById(
                "predictButton"
            );


        const buttonText =
            document.getElementById(
                "buttonText"
            );


        const errorMessage =
            document.getElementById(
                "errorMessage"
            );


        const completionPercent =
            document.getElementById(
                "completionPercent"
            );


        const completionFields =
            document.getElementById(
                "completionFields"
            );


        const sidebarProgressRing =
            document.getElementById(
                "sidebarProgressRing"
            );


        const ringPercentage =
            document.getElementById(
                "ringPercentage"
            );


        const panelTitle =
            document.getElementById(
                "panelTitle"
            );


        const panelDescription =
            document.getElementById(
                "panelDescription"
            );


        const panelStepNumber =
            document.getElementById(
                "panelStepNumber"
            );


        const actionStepText =
            document.getElementById(
                "actionStepText"
            );


        const apiStatusDot =
            document.getElementById(
                "apiStatusDot"
            );


        const apiStatusText =
            document.getElementById(
                "apiStatusText"
            );


        const heroModelName =
            document.getElementById(
                "heroModelName"
            );



        // Modal

        const resultModal =
            document.getElementById(
                "resultModal"
            );


        const modalLoading =
            document.getElementById(
                "modalLoading"
            );


        const modalResultContent =
            document.getElementById(
                "modalResultContent"
            );


        const closeModalButton =
            document.getElementById(
                "closeModalButton"
            );


        const closeResultButton =
            document.getElementById(
                "closeResultButton"
            );


        const newPredictionButton =
            document.getElementById(
                "newPredictionButton"
            );



        // Delay fields

        const previousPaymentDelay =
            document.getElementById(
                "previous_payment_delay"
            );


        const delayCount =
            document.getElementById(
                "delay_count"
            );


        const maxDelayDays =
            document.getElementById(
                "max_delay_days"
            );



        // =====================================================
        // VERIFY ELEMENTS
        // =====================================================

        if (
            !studentForm ||
            !nextButton ||
            !previousButton ||
            !predictButton
        ) {

            console.error(
                "Required frontend elements were not found."
            );

            return;

        }



        // =====================================================
        // STATE
        // =====================================================

        let currentStep = 1;

        const totalSteps = 4;


        const RING_RADIUS = 29;

        const RING_CIRCUMFERENCE =
            2 *
            Math.PI *
            RING_RADIUS;



        // =====================================================
        // STEP INFO
        // =====================================================

        const stepInformation = {

            1: {

                title:
                    "البيانات الأكاديمية",

                description:
                    "أدخل بيانات الدراسة والأداء الأكاديمي للطالب."

            },


            2: {

                title:
                    "البيانات المالية والأسرية",

                description:
                    "أدخل معلومات القسط والدخل والوضع المالي للأسرة."

            },


            3: {

                title:
                    "سجل سداد الأقساط",

                description:
                    "أدخل تاريخ الالتزام بالسداد وحالات التأخر السابقة."

            },


            4: {

                title:
                    "السكن والموقع",

                description:
                    "أدخل معلومات المحافظة والسكن والمسافة عن الجامعة."

            }

        };



        // =====================================================
        // ERROR
        // =====================================================

        function showError(
            message
        ) {

            errorMessage.textContent =
                message;


            errorMessage.classList.remove(
                "hidden"
            );

        }



        function hideError() {

            errorMessage.textContent =
                "";


            errorMessage.classList.add(
                "hidden"
            );

        }



        // =====================================================
        // HEALTH
        // =====================================================

        async function checkAPIHealth() {

            try {

                const response =
                    await fetch(
                        `${API_BASE_URL}/health`
                    );


                if (!response.ok) {

                    throw new Error(
                        "API unavailable"
                    );

                }


                const data =
                    await response.json();


                if (
                    data.status === "healthy"
                    &&
                    data.model_loaded
                ) {

                    apiStatusDot.classList.add(
                        "online"
                    );


                    apiStatusDot.classList.remove(
                        "offline"
                    );


                    apiStatusText.textContent =
                        "النظام جاهز";


                    heroModelName.textContent =
                        data.model_name;

                }

                else {

                    throw new Error(
                        "Model unavailable"
                    );

                }

            }

            catch (error) {

                apiStatusDot.classList.remove(
                    "online"
                );


                apiStatusDot.classList.add(
                    "offline"
                );


                apiStatusText.textContent =
                    "النظام غير متاح";


                heroModelName.textContent =
                    "غير متاح";


                console.error(
                    error
                );

            }

        }



        // =====================================================
        // SHOW STEP
        // =====================================================

        function showStep(
            stepNumber
        ) {

            currentStep =
                stepNumber;


            formSteps.forEach(
                step => {

                    const stepValue =
                        Number(
                            step.dataset.step
                        );


                    step.classList.toggle(
                        "active",
                        stepValue === currentStep
                    );

                }
            );


            sidebarSteps.forEach(
                (
                    step,
                    index
                ) => {

                    const stepValue =
                        index + 1;


                    step.classList.remove(
                        "active",
                        "completed"
                    );


                    const status =
                        step.querySelector(
                            ".sidebar-step-status"
                        );


                    if (
                        stepValue <
                        currentStep
                    ) {

                        step.classList.add(
                            "completed"
                        );


                        status.textContent =
                            "مكتملة";

                    }

                    else if (
                        stepValue ===
                        currentStep
                    ) {

                        step.classList.add(
                            "active"
                        );


                        status.textContent =
                            "الحالية";

                    }

                    else {

                        status.textContent =
                            "";

                    }

                }
            );


            panelTitle.textContent =
                stepInformation[
                    currentStep
                ].title;


            panelDescription.textContent =
                stepInformation[
                    currentStep
                ].description;


            panelStepNumber.textContent =
                String(
                    currentStep
                ).padStart(
                    2,
                    "0"
                );


            actionStepText.textContent =
                `${currentStep} / ${totalSteps}`;


            previousButton.classList.toggle(
                "hidden",
                currentStep === 1
            );


            nextButton.classList.toggle(
                "hidden",
                currentStep === totalSteps
            );


            predictButton.classList.toggle(
                "hidden",
                currentStep !== totalSteps
            );


            hideError();

        }



        // =====================================================
        // FIELD VALIDATION
        // =====================================================

        function isFieldValid(
            field
        ) {

            if (field.disabled) {

                return true;

            }


            if (
                field.hasAttribute(
                    "required"
                )
                &&
                field.value.trim() === ""
            ) {

                return false;

            }


            return field.checkValidity();

        }



        function validateStep(
            stepNumber
        ) {

            const section =
                document.querySelector(
                    `.form-step[data-step="${stepNumber}"]`
                );


            if (!section) {

                return false;

            }


            const fields =
                Array.from(
                    section.querySelectorAll(
                        "input, select"
                    )
                );


            fields.forEach(
                field => {

                    field.classList.remove(
                        "field-error"
                    );

                }
            );


            const invalidField =
                fields.find(
                    field =>
                        !isFieldValid(
                            field
                        )
                );


            if (invalidField) {

                invalidField.classList.add(
                    "field-error"
                );


                showError(
                    "يرجى إكمال جميع بيانات هذه المرحلة بشكل صحيح قبل الانتقال."
                );


                invalidField.focus();


                return false;

            }


            hideError();

            return true;

        }



        function validateCurrentStep() {

            return validateStep(
                currentStep
            );

        }



        function validateAllSteps() {

            for (
                let stepNumber = 1;
                stepNumber <= totalSteps;
                stepNumber++
            ) {

                if (
                    !validateStep(
                        stepNumber
                    )
                ) {

                    showStep(
                        stepNumber
                    );


                    showError(
                        "يوجد حقل ناقص أو غير صحيح. يرجى مراجعة المرحلة المحددة."
                    );


                    const section =
                        document.querySelector(
                            `.form-step[data-step="${stepNumber}"]`
                        );


                    const invalidField =
                        Array.from(
                            section.querySelectorAll(
                                "input, select"
                            )
                        ).find(
                            field =>
                                !isFieldValid(
                                    field
                                )
                        );


                    if (invalidField) {

                        invalidField.classList.add(
                            "field-error"
                        );


                        invalidField.focus();

                    }


                    return false;

                }

            }


            hideError();

            return true;

        }



        // =====================================================
        // COMPLETION
        // =====================================================

        function updateCompletionProgress() {

            const fields =
                Array.from(
                    studentForm.querySelectorAll(
                        "input[required], select[required]"
                    )
                );


            let completed = 0;


            fields.forEach(
                field => {

                    if (
                        field.disabled
                    ) {

                        /*
                         * الحقل المعطل ناتج عن اختيار
                         * "لم يسبق التأخر"، وقيمته تكون 0.
                         */

                        if (
                            field.value !== ""
                        ) {

                            completed++;

                        }

                        return;

                    }


                    if (
                        field.value !== ""
                        &&
                        field.checkValidity()
                    ) {

                        completed++;

                    }

                }
            );


            const percentage =
                fields.length
                ?
                Math.round(
                    (
                        completed /
                        fields.length
                    )
                    *
                    100
                )
                :
                0;


            completionPercent.textContent =
                `${percentage}%`;


            ringPercentage.textContent =
                `${percentage}%`;


            completionFields.textContent =
                `${completed} من ${fields.length}`;


            const offset =
                RING_CIRCUMFERENCE
                -
                (
                    percentage /
                    100
                )
                *
                RING_CIRCUMFERENCE;


            sidebarProgressRing.style.strokeDasharray =
                RING_CIRCUMFERENCE;


            sidebarProgressRing.style.strokeDashoffset =
                offset;

        }



        // =====================================================
        // NEXT BUTTON
        // =====================================================

        nextButton.addEventListener(
            "click",
            function (
                event
            ) {

                event.preventDefault();


                hideError();


                if (
                    !validateCurrentStep()
                ) {

                    return;

                }


                if (
                    currentStep <
                    totalSteps
                ) {

                    showStep(
                        currentStep + 1
                    );

                }

            }
        );



        // =====================================================
        // PREVIOUS BUTTON
        // =====================================================

        previousButton.addEventListener(
            "click",
            function (
                event
            ) {

                event.preventDefault();


                if (
                    currentStep > 1
                ) {

                    showStep(
                        currentStep - 1
                    );

                }

            }
        );



        // =====================================================
        // FIELD EVENTS
        // =====================================================

        studentForm.addEventListener(
            "input",
            function (
                event
            ) {

                const field =
                    event.target;


                field.classList.remove(
                    "field-error"
                );


                updateCompletionProgress();

            }
        );


        studentForm.addEventListener(
            "change",
            function (
                event
            ) {

                const field =
                    event.target;


                field.classList.remove(
                    "field-error"
                );


                updateCompletionProgress();

            }
        );



        // =====================================================
        // DELAY FIELDS
        // =====================================================

        function updateDelayFields() {

            if (
                previousPaymentDelay.value ===
                "لا"
            ) {

                delayCount.value =
                    0;


                maxDelayDays.value =
                    0;


                delayCount.disabled =
                    true;


                maxDelayDays.disabled =
                    true;


                delayCount.classList.remove(
                    "field-error"
                );


                maxDelayDays.classList.remove(
                    "field-error"
                );

            }

            else {

                delayCount.disabled =
                    false;


                maxDelayDays.disabled =
                    false;

            }


            updateCompletionProgress();

        }



        previousPaymentDelay.addEventListener(
            "change",
            updateDelayFields
        );



        // =====================================================
        // STUDENT DATA
        // =====================================================

        function getStudentData() {

            return {

                branch:
                    document.getElementById(
                        "branch"
                    ).value,


                approx_installment_value:
                    Number(
                        document.getElementById(
                            "approx_installment_value"
                        ).value
                    ),


                payment_responsible:
                    document.getElementById(
                        "payment_responsible"
                    ).value,


                works_while_studying:
                    document.getElementById(
                        "works_while_studying"
                    ).value,


                governorate:
                    document.getElementById(
                        "governorate"
                    ).value,


                registered_hours:
                    Number(
                        document.getElementById(
                            "registered_hours"
                        ).value
                    ),


                previous_payment_delay:
                    previousPaymentDelay.value,


                gpa:
                    Number(
                        document.getElementById(
                            "gpa"
                        ).value
                    ),


                attendance_rate:
                    Number(
                        document.getElementById(
                            "attendance_rate"
                        ).value
                    ),


                delay_count:
                    Number(
                        delayCount.value
                    ),


                max_delay_days:
                    Number(
                        maxDelayDays.value
                    ),


                on_time_payment_count:
                    Number(
                        document.getElementById(
                            "on_time_payment_count"
                        ).value
                    ),


                family_monthly_income:
                    document.getElementById(
                        "family_monthly_income"
                    ).value,


                private_university_siblings:
                    Number(
                        document.getElementById(
                            "private_university_siblings"
                        ).value
                    ),


                semester_fee:
                    Number(
                        document.getElementById(
                            "semester_fee"
                        ).value
                    ),


                study_year:
                    document.getElementById(
                        "study_year"
                    ).value,


                working_family_members:
                    Number(
                        document.getElementById(
                            "working_family_members"
                        ).value
                    ),


                previous_unpaid_fees:
                    document.getElementById(
                        "previous_unpaid_fees"
                    ).value,


                housing:
                    document.getElementById(
                        "housing"
                    ).value,


                distance_from_university:
                    Number(
                        document.getElementById(
                            "distance_from_university"
                        ).value
                    )

            };

        }



        // =====================================================
        // PREDICTION API
        // =====================================================

        async function predictStudent(
            studentData
        ) {

            const response =
                await fetch(
                    `${API_BASE_URL}/predict`,
                    {

                        method:
                            "POST",

                        headers: {

                            "Content-Type":
                                "application/json"

                        },

                        body:
                            JSON.stringify(
                                studentData
                            )

                    }
                );


            if (!response.ok) {

                let errorData = null;


                try {

                    errorData =
                        await response.json();

                }

                catch {

                    errorData =
                        null;

                }


                console.error(
                    errorData
                );


                if (
                    response.status === 422
                ) {

                    throw new Error(
                        "بعض البيانات المدخلة لا تطابق القيم المطلوبة للنموذج."
                    );

                }


                throw new Error(
                    errorData?.detail
                    ||
                    "حدث خطأ أثناء تنفيذ التنبؤ."
                );

            }


            return await response.json();

        }



        // =====================================================
        // COMPARISON API
        // =====================================================

        async function getModelComparison() {

            const response =
                await fetch(
                    `${API_BASE_URL}/model-comparison`
                );


            if (!response.ok) {

                throw new Error(
                    "تعذر تحميل نتائج مقارنة النماذج."
                );

            }


            return await response.json();

        }



        // =====================================================
        // MODAL
        // =====================================================

        function openModal() {

            resultModal.classList.add(
                "open"
            );


            resultModal.setAttribute(
                "aria-hidden",
                "false"
            );


            document.body.classList.add(
                "modal-open"
            );


            const modalContainer =
                resultModal.querySelector(
                    ".result-modal"
                );


            if (modalContainer) {

                modalContainer.scrollTop =
                    0;

            }

        }



        function closeModal() {

            resultModal.classList.remove(
                "open"
            );


            resultModal.setAttribute(
                "aria-hidden",
                "true"
            );


            document.body.classList.remove(
                "modal-open"
            );

        }



        // =====================================================
        // DISPLAY PREDICTION
        // =====================================================

        function displayPrediction(
            result
        ) {

            const latePercentage =
                result.late_probability
                *
                100;


            const onTimePercentage =
                result.on_time_probability
                *
                100;


            const resultHero =
                document.getElementById(
                    "resultHero"
                );


            const resultTitle =
                document.getElementById(
                    "resultTitle"
                );


            const resultDescription =
                document.getElementById(
                    "resultDescription"
                );


            const resultStateIcon =
                document.getElementById(
                    "resultStateIcon"
                );


            resultHero.classList.remove(
                "late-result",
                "on-time-result"
            );


            let mainProbability =
                0;


            if (
                result.prediction ===
                "late"
            ) {

                resultHero.classList.add(
                    "late-result"
                );


                resultStateIcon.textContent =
                    "!";


                resultStateIcon.style.color =
                    "var(--danger)";


                resultTitle.textContent =
                    "الطالب معرض للتأخر في سداد القسط";


                resultDescription.textContent =
                    "تشير البيانات المدخلة إلى أن احتمال التأخر في السداد هو الاحتمال الأعلى وفق النموذج.";


                mainProbability =
                    latePercentage;

            }

            else {

                resultHero.classList.add(
                    "on-time-result"
                );


                resultStateIcon.textContent =
                    "✓";


                resultStateIcon.style.color =
                    "var(--success)";


                resultTitle.textContent =
                    "من المتوقع سداد القسط في الموعد";


                resultDescription.textContent =
                    "تشير البيانات المدخلة إلى أن احتمال السداد في الموعد هو الاحتمال الأعلى وفق النموذج.";


                mainProbability =
                    onTimePercentage;

            }


            document.getElementById(
                "usedModel"
            ).textContent =
                result.model;


            document.getElementById(
                "onTimeMetric"
            ).textContent =
                `${onTimePercentage.toFixed(1)}%`;


            document.getElementById(
                "lateMetric"
            ).textContent =
                `${latePercentage.toFixed(1)}%`;


            document.getElementById(
                "mainProbability"
            ).textContent =
                `${mainProbability.toFixed(1)}%`;


            const ring =
                document.getElementById(
                    "probabilityRing"
                );


            ring.style.setProperty(
                "--ring-value",
                `${mainProbability * 3.6}deg`
            );


            const onTimeBar =
                document.getElementById(
                    "onTimeBar"
                );


            const lateBar =
                document.getElementById(
                    "lateBar"
                );


            onTimeBar.style.width =
                "0%";


            lateBar.style.width =
                "0%";


            requestAnimationFrame(
                () => {

                    onTimeBar.style.width =
                        `${onTimePercentage}%`;


                    lateBar.style.width =
                        `${latePercentage}%`;

                }
            );

        }



        // =====================================================
        // DISPLAY COMPARISON
        // =====================================================

        function displayComparison(
            comparison
        ) {

            const barsContainer =
                document.getElementById(
                    "comparisonBars"
                );


            const tableBody =
                document.getElementById(
                    "comparisonTableBody"
                );


            barsContainer.innerHTML =
                "";


            tableBody.innerHTML =
                "";


            comparison.models.forEach(
                model => {


                    // -----------------------------------------
                    // BAR
                    // -----------------------------------------

                    const item =
                        document.createElement(
                            "div"
                        );


                    item.className =
                        "comparison-item";


                    const name =
                        document.createElement(
                            "div"
                        );


                    name.className =
                        "comparison-name";


                    if (
                        model.is_best
                    ) {

                        name.classList.add(
                            "best"
                        );

                    }


                    name.textContent =
                        model.name;


                    const track =
                        document.createElement(
                            "div"
                        );


                    track.className =
                        "comparison-track";


                    const fill =
                        document.createElement(
                            "div"
                        );


                    fill.className =
                        "comparison-fill";


                    if (
                        model.is_best
                    ) {

                        fill.classList.add(
                            "best"
                        );

                    }


                    fill.style.width =
                        `${model.f1 * 100}%`;


                    track.appendChild(
                        fill
                    );


                    const value =
                        document.createElement(
                            "div"
                        );


                    value.className =
                        "comparison-value";


                    value.textContent =
                        `${(
                            model.f1 *
                            100
                        ).toFixed(1)}%`;


                    item.appendChild(
                        name
                    );


                    item.appendChild(
                        track
                    );


                    item.appendChild(
                        value
                    );


                    barsContainer.appendChild(
                        item
                    );



                    // -----------------------------------------
                    // TABLE
                    // -----------------------------------------

                    const row =
                        document.createElement(
                            "tr"
                        );


                    if (
                        model.is_best
                    ) {

                        row.classList.add(
                            "best-model-row"
                        );

                    }


                    const nameCell =
                        document.createElement(
                            "td"
                        );


                    nameCell.textContent =
                        model.name;


                    if (
                        model.is_best
                    ) {

                        const badge =
                            document.createElement(
                                "span"
                            );


                        badge.className =
                            "best-badge";


                        badge.textContent =
                            "الأفضل";


                        nameCell.appendChild(
                            badge
                        );

                    }


                    const accuracyCell =
                        document.createElement(
                            "td"
                        );


                    accuracyCell.textContent =
                        `${(
                            model.accuracy *
                            100
                        ).toFixed(1)}%`;


                    const precisionCell =
                        document.createElement(
                            "td"
                        );


                    precisionCell.textContent =
                        `${(
                            model.precision *
                            100
                        ).toFixed(1)}%`;


                    const recallCell =
                        document.createElement(
                            "td"
                        );


                    recallCell.textContent =
                        `${(
                            model.recall *
                            100
                        ).toFixed(1)}%`;


                    const f1Cell =
                        document.createElement(
                            "td"
                        );


                    f1Cell.textContent =
                        `${(
                            model.f1 *
                            100
                        ).toFixed(1)}%`;


                    row.appendChild(
                        nameCell
                    );


                    row.appendChild(
                        accuracyCell
                    );


                    row.appendChild(
                        precisionCell
                    );


                    row.appendChild(
                        recallCell
                    );


                    row.appendChild(
                        f1Cell
                    );


                    tableBody.appendChild(
                        row
                    );

                }
            );

        }



        // =====================================================
        // SUBMIT
        // =====================================================

        studentForm.addEventListener(
            "submit",
            async function (
                event
            ) {

                event.preventDefault();


                hideError();


                if (
                    !validateAllSteps()
                ) {

                    return;

                }


                predictButton.disabled =
                    true;


                buttonText.textContent =
                    "جاري التحليل...";


                modalResultContent.classList.add(
                    "hidden"
                );


                modalLoading.classList.remove(
                    "hidden"
                );


                openModal();


                try {

                    const studentData =
                        getStudentData();


                    console.log(
                        "Student data:",
                        studentData
                    );


                    const [
                        predictionResult,
                        modelComparison
                    ] =
                        await Promise.all([

                            predictStudent(
                                studentData
                            ),

                            getModelComparison()

                        ]);


                    displayPrediction(
                        predictionResult
                    );


                    displayComparison(
                        modelComparison
                    );


                    modalLoading.classList.add(
                        "hidden"
                    );


                    modalResultContent.classList.remove(
                        "hidden"
                    );

                }

                catch (error) {

                    console.error(
                        error
                    );


                    closeModal();


                    showError(
                        error.message
                    );

                }

                finally {

                    predictButton.disabled =
                        false;


                    buttonText.textContent =
                        "تنفيذ التنبؤ";

                }

            }
        );



        // =====================================================
        // MODAL CONTROLS
        // =====================================================

        closeModalButton.addEventListener(
            "click",
            closeModal
        );


        closeResultButton.addEventListener(
            "click",
            closeModal
        );


        resultModal.addEventListener(
            "click",
            function (
                event
            ) {

                if (
                    event.target ===
                    resultModal
                ) {

                    closeModal();

                }

            }
        );


        document.addEventListener(
            "keydown",
            function (
                event
            ) {

                if (
                    event.key === "Escape"
                    &&
                    resultModal.classList.contains(
                        "open"
                    )
                ) {

                    closeModal();

                }

            }
        );



        // =====================================================
        // NEW PREDICTION
        // =====================================================

        newPredictionButton.addEventListener(
            "click",
            function () {

                closeModal();


                studentForm.reset();


                delayCount.disabled =
                    false;


                maxDelayDays.disabled =
                    false;


                studentForm
                    .querySelectorAll(
                        ".field-error"
                    )
                    .forEach(
                        field => {

                            field.classList.remove(
                                "field-error"
                            );

                        }
                    );


                showStep(
                    1
                );


                updateCompletionProgress();


                document.querySelector(
                    ".wizard-workspace"
                ).scrollIntoView({

                    behavior:
                        "smooth",

                    block:
                        "start"

                });

            }
        );



        // =====================================================
        // STARTUP
        // =====================================================

        sidebarProgressRing.style.strokeDasharray =
            RING_CIRCUMFERENCE;


        sidebarProgressRing.style.strokeDashoffset =
            RING_CIRCUMFERENCE;


        showStep(
            1
        );


        updateDelayFields();


        updateCompletionProgress();


        await checkAPIHealth();


        console.log(
            "Frontend loaded successfully - v7"
        );

    }
);