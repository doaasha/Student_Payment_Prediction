const API_BASE_URL = "";

document.addEventListener("DOMContentLoaded", () => {
  const $ = (id) => document.getElementById(id);
  const pages = [...document.querySelectorAll(".page")];
  const navItems = [...document.querySelectorAll(".nav-item")];
  const form = $("studentForm");
  const formSteps = [...document.querySelectorAll(".form-step")];
  const stepIndicators = [...document.querySelectorAll(".step[data-step-indicator]")];
  const dots = [...document.querySelectorAll(".dots i")];

  const previousButton = $("previousButton");
  const nextButton = $("nextButton");
  const predictButton = $("predictButton");
  const buttonText = $("buttonText");
  const errorMessage = $("errorMessage");
  const completionPercent = $("completionPercent");
  const completionFields = $("completionFields");
  const ringPercentage = $("ringPercentage");
  const sidebarProgressRing = $("sidebarProgressRing");
  const actionStepText = $("actionStepText");

  const resultModal = $("resultModal");
  const modalLoading = $("modalLoading");
  const modalResultContent = $("modalResultContent");
  const closeModalButton = $("closeModalButton");
  const closeResultButton = $("closeResultButton");
  const newPredictionButton = $("newPredictionButton");

  const previousPaymentDelay = $("previous_payment_delay");
  const delayCount = $("delay_count");
  const maxDelayDays = $("max_delay_days");

  const totalSteps = 4;
  const ringCircumference = 2 * Math.PI * 49;
  let currentStep = 1;
  let comparisonCache = null;
  let modelInfoCache = null;
  let healthCache = null;
  let comparisonLoading = null;
  let systemLoading = null;

  function setActivePage(pageId) {
    const target = $(pageId) || $("home");
    pages.forEach((page) => page.classList.toggle("active", page === target));
    navItems.forEach((item) => item.classList.toggle("active", item.dataset.page === target.id));

    if (target.id === "models") loadComparisonPage();
    if (target.id === "system-info") loadSystemInfo();
  }

  function navigate(pageId, updateHash = true) {
    setActivePage(pageId);
    if (pageId === "prediction") showStep(1);
    if (updateHash) history.replaceState(null, "", `#${pageId}`);
    window.scrollTo({ top: 0, behavior: "auto" });
  }

  navItems.forEach((item) => {
    item.addEventListener("click", (event) => {
      event.preventDefault();
      navigate(item.dataset.page || "home");
    });
  });

  window.addEventListener("hashchange", () => {
    const hash = location.hash.slice(1);
    setActivePage($(hash) ? hash : "home");
  });

  function showStep(step) {
    currentStep = Math.min(totalSteps, Math.max(1, step));

    formSteps.forEach((section) => {
      section.classList.toggle("active", Number(section.dataset.step) === currentStep);
    });

    stepIndicators.forEach((indicator) => {
      const number = Number(indicator.dataset.stepIndicator);
      indicator.classList.toggle("active", number === currentStep);
      indicator.classList.toggle("completed", number < currentStep);
    });

    previousButton?.classList.toggle("hidden", currentStep === 1);
    nextButton?.classList.toggle("hidden", currentStep === totalSteps);
    predictButton?.classList.toggle("hidden", currentStep !== totalSteps);

    if (actionStepText) actionStepText.textContent = `${currentStep} / ${totalSteps}`;
    dots.forEach((dot, index) => dot.classList.toggle("active", index === currentStep - 1));

    hideError();
    updateProgress();
  }

  function isValidField(field) {
    return field.disabled || (field.value.trim() !== "" && field.checkValidity());
  }

  function validateStep(stepNumber) {
    const section = document.querySelector(`.form-step[data-step="${stepNumber}"]`);
    if (!section) return false;

    const fields = [...section.querySelectorAll("input, select")];
    fields.forEach((field) => field.classList.remove("field-error"));

    const invalid = fields.find((field) => !isValidField(field));
    if (!invalid) {
      hideError();
      return true;
    }

    invalid.classList.add("field-error");
    showError("يرجى إكمال جميع بيانات هذه المرحلة بشكل صحيح قبل الانتقال.");
    invalid.focus();
    return false;
  }

  function validateAllSteps() {
    for (let step = 1; step <= totalSteps; step += 1) {
      if (!validateStep(step)) {
        showStep(step);
        return false;
      }
    }
    return true;
  }

  function updateProgress() {
    const percentage = Math.round((currentStep / totalSteps) * 100);
    if (completionPercent) completionPercent.textContent = `${percentage}%`;
    if (ringPercentage) ringPercentage.textContent = `${percentage}%`;
    if (completionFields) completionFields.textContent = `${currentStep} من ${totalSteps}`;

    if (sidebarProgressRing) {
      sidebarProgressRing.style.strokeDasharray = String(ringCircumference);
      sidebarProgressRing.style.strokeDashoffset = String(
        ringCircumference - (percentage / 100) * ringCircumference
      );
    }
  }

  function updateDelayFields() {
    const disabled = previousPaymentDelay?.value === "لا";
    if (!delayCount || !maxDelayDays) return;

    if (disabled) {
      delayCount.value = "0";
      maxDelayDays.value = "0";
    }

    delayCount.disabled = disabled;
    maxDelayDays.disabled = disabled;
  }

  function showError(message) {
    if (!errorMessage) return;
    errorMessage.textContent = message;
    errorMessage.classList.remove("hidden");
  }

  function hideError() {
    if (!errorMessage) return;
    errorMessage.textContent = "";
    errorMessage.classList.add("hidden");
  }

  function getStudentData() {
    return {
      branch: $("branch").value,
      approx_installment_value: Number($("approx_installment_value").value),
      payment_responsible: $("payment_responsible").value,
      works_while_studying: $("works_while_studying").value,
      governorate: $("governorate").value,
      registered_hours: Number($("registered_hours").value),
      previous_payment_delay: $("previous_payment_delay").value,
      gpa: Number($("gpa").value),
      attendance_rate: Number($("attendance_rate").value),
      delay_count: Number($("delay_count").value),
      max_delay_days: Number($("max_delay_days").value),
      on_time_payment_count: Number($("on_time_payment_count").value),
      family_monthly_income: $("family_monthly_income").value,
      private_university_siblings: Number($("private_university_siblings").value),
      semester_fee: Number($("semester_fee").value),
      study_year: $("study_year").value,
      working_family_members: Number($("working_family_members").value),
      previous_unpaid_fees: $("previous_unpaid_fees").value,
      housing: $("housing").value,
      distance_from_university: Number($("distance_from_university").value)
    };
  }

  async function requestJSON(url, options = {}) {
    const response = await fetch(`${API_BASE_URL}${url}`, options);
    let data = null;
    try { data = await response.json(); } catch (_) {}

    if (!response.ok) {
      const detail = data?.detail;
      const message = typeof detail === "string"
        ? detail
        : detail
          ? JSON.stringify(detail)
          : "حدث خطأ أثناء الاتصال بالنظام.";
      throw new Error(message);
    }
    return data;
  }

  const predictStudent = (data) => requestJSON("/predict", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data)
  });

  const getComparison = async () => {
    if (comparisonCache) return comparisonCache;
    comparisonCache = await requestJSON("/model-comparison");
    return comparisonCache;
  };

  const getModelInfo = async () => {
    if (modelInfoCache) return modelInfoCache;
    modelInfoCache = await requestJSON("/model-info");
    return modelInfoCache;
  };

  const getHealth = async () => {
    if (healthCache) return healthCache;
    healthCache = await requestJSON("/health");
    return healthCache;
  };

  function normalizeModels(data) {
    if (Array.isArray(data)) return data;
    if (Array.isArray(data?.models)) return data.models;
    if (Array.isArray(data?.results)) return data.results;
    return [];
  }

  function metric(model, key) {
    const value = Number(model?.[key] ?? 0);
    return value > 1 ? value / 100 : value;
  }

  function renderComparison(data, containerId) {
    const container = $(containerId);
    if (!container) return;

    const fragment = document.createDocumentFragment();
    normalizeModels(data).forEach((model) => {
      const f1 = metric(model, "f1");
      const row = document.createElement("div");
      row.className = "comparison-item";

      const name = document.createElement("div");
      name.className = `comparison-name${model.is_best ? " best" : ""}`;
      name.textContent = model.name || model.model || "Model";

      const track = document.createElement("div");
      track.className = "comparison-track";
      const fill = document.createElement("div");
      fill.className = `comparison-fill${model.is_best ? " best" : ""}`;
      fill.style.width = `${Math.max(0, Math.min(100, f1 * 100))}%`;
      track.appendChild(fill);

      const value = document.createElement("div");
      value.className = "comparison-value";
      value.textContent = `${(f1 * 100).toFixed(1)}%`;

      row.append(name, track, value);
      fragment.appendChild(row);
    });

    container.replaceChildren(fragment);
  }

  function renderTable(data) {
    const body = $("comparisonTableBody");
    if (!body) return;

    const fragment = document.createDocumentFragment();
    normalizeModels(data).forEach((model) => {
      const row = document.createElement("tr");
      if (model.is_best) row.classList.add("best-model-row");

      const name = document.createElement("td");
      name.textContent = model.name || model.model || "Model";
      if (model.is_best) {
        const badge = document.createElement("span");
        badge.className = "best-badge";
        badge.textContent = "الأفضل";
        name.appendChild(badge);
      }
      row.appendChild(name);

      ["accuracy", "precision", "recall", "f1"].forEach((key) => {
        const td = document.createElement("td");
        td.textContent = `${(metric(model, key) * 100).toFixed(1)}%`;
        row.appendChild(td);
      });

      fragment.appendChild(row);
    });
    body.replaceChildren(fragment);
  }

  async function loadComparisonPage() {
    if (comparisonLoading) return comparisonLoading;
    comparisonLoading = (async () => {
      try {
        const [data, info] = await Promise.all([getComparison(), getModelInfo()]);
        const models = normalizeModels(data);
        const best = models.find((m) => m.is_best) || models[0];
        $("bestModelName").textContent = best?.name || best?.model || "غير متاح";
        $("selectionMetric").textContent = info?.selection_metric || "F1";
        $("modelsStatus").textContent = "جاهز";
        renderComparison(data, "modelsComparisonBars");
        renderTable(data);
      } catch (_) {
        $("bestModelName").textContent = "غير متاح";
        $("modelsStatus").textContent = "غير متاح";
      } finally {
        comparisonLoading = null;
      }
    })();
    return comparisonLoading;
  }

  async function loadSystemInfo() {
    if (systemLoading) return systemLoading;
    systemLoading = (async () => {
      try {
        const [health, info] = await Promise.all([getHealth(), getModelInfo()]);
        $("systemState").textContent = health?.status === "healthy" && health?.model_loaded
          ? "النظام جاهز للعمل"
          : "النظام غير متاح";
        $("systemModel").textContent = info?.model_name || health?.model_name || "غير متاح";
      } catch (_) {
        $("systemState").textContent = "النظام غير متاح";
        $("systemModel").textContent = "غير متاح";
      } finally {
        systemLoading = null;
      }
    })();
    return systemLoading;
  }

  function displayPrediction(result, comparison) {
    const late = Number(result?.late_probability || 0) * 100;
    const onTime = Number(result?.on_time_probability || 0) * 100;
    const isLate = result?.prediction === "late";
    const hero = $("resultHero");
    const icon = $("resultStateIcon");

    hero?.classList.toggle("late-result", isLate);
    icon?.classList.toggle("late-result-icon", isLate);
    if (icon) icon.textContent = isLate ? "!" : "✓";

    $("resultTitle").textContent = isLate
      ? "من المتوقع تأخر سداد القسط"
      : "من المتوقع سداد القسط في الموعد";

    $("resultDescription").textContent = isLate
      ? "تشير البيانات المدخلة إلى أن احتمال التأخر هو الاحتمال الأعلى وفق النموذج."
      : "تشير البيانات المدخلة إلى أن احتمال السداد في الموعد هو الاحتمال الأعلى وفق النموذج.";

    $("onTimeMetric").textContent = `${onTime.toFixed(1)}%`;
    $("lateMetric").textContent = `${late.toFixed(1)}%`;
    $("usedModel").textContent = result?.model || "غير متاح";
    renderComparison(comparison, "comparisonBars");
  }

  function openModal() {
    resultModal?.classList.remove("hidden");
    document.body.style.overflow = "hidden";
  }

  function closeModal() {
    resultModal?.classList.add("hidden");
    document.body.style.overflow = "";
  }

  nextButton?.addEventListener("click", () => {
    if (validateStep(currentStep) && currentStep < totalSteps) showStep(currentStep + 1);
  });

  previousButton?.addEventListener("click", () => {
    if (currentStep > 1) showStep(currentStep - 1);
  });

  form?.addEventListener("input", (event) => {
    event.target.classList.remove("field-error");
  });

  form?.addEventListener("change", (event) => {
    event.target.classList.remove("field-error");
    if (event.target === previousPaymentDelay) updateDelayFields();
  });

  form?.addEventListener("submit", async (event) => {
    event.preventDefault();
    if (!validateAllSteps()) return;

    predictButton.disabled = true;
    buttonText.textContent = "جاري التحليل...";
    modalLoading?.classList.remove("hidden");
    modalResultContent?.classList.add("hidden");
    openModal();

    try {
      const [prediction, comparison] = await Promise.all([
        predictStudent(getStudentData()),
        getComparison()
      ]);
      displayPrediction(prediction, comparison);
      modalLoading?.classList.add("hidden");
      modalResultContent?.classList.remove("hidden");
    } catch (error) {
      modalLoading?.classList.add("hidden");
      modalResultContent?.classList.add("hidden");
      closeModal();
      showError(error.message);
    } finally {
      predictButton.disabled = false;
      buttonText.textContent = "تنفيذ التنبؤ";
    }
  });

  closeModalButton?.addEventListener("click", closeModal);
  closeResultButton?.addEventListener("click", closeModal);
  document.querySelector(".modal-backdrop")?.addEventListener("click", closeModal);

  newPredictionButton?.addEventListener("click", () => {
    form?.reset();
    if (delayCount) delayCount.disabled = false;
    if (maxDelayDays) maxDelayDays.disabled = false;
    showStep(1);
    closeModal();
    navigate("prediction");
  });

  updateDelayFields();
  showStep(1);

  const initialHash = location.hash.slice(1);
  setActivePage($(initialHash) ? initialHash : "home");

  // اتصال خفيف عند البداية، بدون تعطيل الواجهة في حال فشل الـAPI.
  getHealth().catch(() => {});
});
