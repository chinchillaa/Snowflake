(function () {
  const bank = window.SNOWPRO_QUESTION_BANK;
  const storageKey = "snowpro-core-signal-studio-v1";

  const state = {
    selectedExam: bank.exams[0]?.slug || "",
    filter: "all",
    search: "",
    currentQuestionId: "",
    progress: loadProgress(),
    revealed: false,
    draftSelection: [],
  };

  const els = {
    appShell:                document.getElementById("app-shell"),
    sidebarToggle:           document.getElementById("sidebar-toggle"),
    examList:                document.getElementById("exam-list"),
    filterList:              document.getElementById("filter-list"),
    questionMap:             document.getElementById("question-map"),
    searchInput:             document.getElementById("search-input"),
    currentExamTitle:        document.getElementById("current-exam-title"),
    currentExamMeta:         document.getElementById("current-exam-meta"),
    answeredCount:           document.getElementById("answered-count"),
    accuracyRate:            document.getElementById("accuracy-rate"),
    bookmarkCount:           document.getElementById("bookmark-count"),
    questionCount:           document.getElementById("question-count"),
    questionPosition:        document.getElementById("question-position"),
    questionTitle:           document.getElementById("question-title"),
    selectModeBadge:         document.getElementById("select-mode-badge"),
    questionStem:            document.getElementById("question-stem"),
    optionsGrid:             document.getElementById("options-grid"),
    userNote:                document.getElementById("user-note"),
    sourceAnswer:            document.getElementById("source-answer"),
    bookmarkButton:          document.getElementById("bookmark-button"),
    checkAnswerButton:       document.getElementById("check-answer-button"),
    toggleExplanationButton: document.getElementById("toggle-explanation-button"),
    prevQuestionButton:      document.getElementById("prev-question-button"),
    nextQuestionButton:      document.getElementById("next-question-button"),
    resultChip:              document.getElementById("result-chip"),
    selectedAnswerText:      document.getElementById("selected-answer-text"),
    correctAnswerText:       document.getElementById("correct-answer-text"),
    explanationContent:      document.getElementById("explanation-content"),
    practiceWrap:            document.getElementById("practice-wrap"),
    practiceContent:         document.getElementById("practice-content"),
    exportProgressButton:    document.getElementById("export-progress-button"),
    importProgressButton:    document.getElementById("import-progress-button"),
    importProgressFile:      document.getElementById("import-progress-file"),
    resetProgressButton:     document.getElementById("reset-progress-button"),
    progressFill:            document.getElementById("q-progress-fill"),
  };

  const filters = [
    { id: "all",        label: "All"      },
    { id: "unanswered", label: "未回答"   },
    { id: "incorrect",  label: "要復習"   },
    { id: "bookmarked", label: "Bookmark" },
  ];

  const examsBySlug = Object.fromEntries(bank.exams.map((exam) => [exam.slug, exam]));
  const validQuestionIds = new Set(
    bank.exams.flatMap((exam) => exam.questions.map((question) => questionId(exam.slug, question.order)))
  );

  /* ── persistence ─────────────────────────────────────── */
  function loadProgress() {
    try {
      return JSON.parse(localStorage.getItem(storageKey) || "{}");
    } catch {
      return {};
    }
  }

  function saveProgress() {
    localStorage.setItem(storageKey, JSON.stringify(state.progress));
  }

  function sanitizeProgress(rawProgress) {
    if (!rawProgress || typeof rawProgress !== "object" || Array.isArray(rawProgress)) {
      throw new Error("進捗データの形式が正しくありません。");
    }

    const clean = {};
    for (const [id, item] of Object.entries(rawProgress)) {
      if (!validQuestionIds.has(id) || !item || typeof item !== "object" || Array.isArray(item)) continue;
      const selected = Array.isArray(item.selected)
        ? item.selected.filter((value) => typeof value === "string")
        : [];
      clean[id] = {
        selected,
        note: typeof item.note === "string" ? item.note : "",
        bookmarked: item.bookmarked === true,
        checked: item.checked === true,
        correct: typeof item.correct === "boolean" ? item.correct : null,
      };
    }
    return clean;
  }

  function exportProgress() {
    const payload = {
      app: "SnowPro Core Signal Studio",
      version: 1,
      exportedAt: new Date().toISOString(),
      storageKey,
      progress: state.progress,
    };
    const blob = new Blob([JSON.stringify(payload, null, 2)], { type: "application/json" });
    if (window.navigator.msSaveOrOpenBlob) {
      window.navigator.msSaveOrOpenBlob(blob, "snowpro-core-progress.json");
      return;
    }

    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    const stamp = new Date().toISOString().slice(0, 19).replace(/[:T]/g, "-");
    link.href = url;
    link.download = `snowpro-core-progress-${stamp}.json`;
    link.style.display = "none";
    document.body.appendChild(link);
    link.click();
    setTimeout(() => {
      link.remove();
      URL.revokeObjectURL(url);
    }, 1000);
  }

  function importProgressFile(file) {
    if (!file) return;
    const reader = new FileReader();
    reader.addEventListener("load", () => {
      try {
        const parsed = JSON.parse(String(reader.result || "{}"));
        const rawProgress = parsed.progress || parsed;
        const nextProgress = sanitizeProgress(rawProgress);
        if (!confirm("現在の進捗をインポートした内容で置き換えますか？")) return;
        state.progress = nextProgress;
        state.revealed = false;
        saveProgress();
        render();
        alert("進捗をインポートしました。");
      } catch (error) {
        alert(error instanceof Error ? error.message : "進捗データを読み込めませんでした。");
      } finally {
        els.importProgressFile.value = "";
      }
    });
    reader.addEventListener("error", () => {
      alert("進捗ファイルを読み込めませんでした。");
      els.importProgressFile.value = "";
    });
    reader.readAsText(file);
  }

  /* ── helpers ─────────────────────────────────────────── */
  function questionId(examSlug, questionOrder) {
    return `${examSlug}::${questionOrder}`;
  }

  function getExam() {
    return examsBySlug[state.selectedExam];
  }

  function getQuestionProgress(id) {
    return state.progress[id] || { selected: [], note: "", bookmarked: false, checked: false, correct: null };
  }

  function getVisibleQuestions() {
    const exam = getExam();
    const term = state.search.trim().toLowerCase();
    return exam.questions.filter((question) => {
      const id = questionId(exam.slug, question.order);
      const progress = getQuestionProgress(id);
      const matchesFilter =
        state.filter === "all" ||
        (state.filter === "unanswered" && !progress.checked) ||
        (state.filter === "incorrect" && progress.checked && progress.correct === false) ||
        (state.filter === "bookmarked" && progress.bookmarked);
      const matchesSearch =
        !term ||
        question.title.toLowerCase().includes(term) ||
        question.options.some((option) => option.label.toLowerCase().includes(term)) ||
        question.stemHtml.toLowerCase().includes(term);
      return matchesFilter && matchesSearch;
    });
  }

  function getCurrentQuestion() {
    const visible = getVisibleQuestions();
    return visible.find((q) => questionId(getExam().slug, q.order) === state.currentQuestionId) || visible[0];
  }

  function ensureCurrentQuestion() {
    const current = getCurrentQuestion();
    if (current) {
      state.currentQuestionId = questionId(getExam().slug, current.order);
    }
  }

  function compareSelections(actual, expected) {
    return [...actual].sort().join(",") === [...expected].sort().join(",");
  }

  /* ── stats ───────────────────────────────────────────── */
  function updateStats() {
    const items = Object.entries(state.progress).filter(([id]) => id.startsWith(`${state.selectedExam}::`));
    const answered  = items.filter(([, item]) => item.checked).length;
    const correct   = items.filter(([, item]) => item.correct).length;
    const bookmarked = items.filter(([, item]) => item.bookmarked).length;
    const exam = getExam();

    els.answeredCount.textContent  = String(answered);
    els.accuracyRate.textContent   = answered ? `${Math.round((correct / answered) * 100)}%` : "0%";
    els.bookmarkCount.textContent  = String(bookmarked);
    els.questionCount.textContent  = String(exam.questionCount);
  }

  /* ── progress bar ────────────────────────────────────── */
  function updateProgressBar() {
    if (!els.progressFill) return;
    const exam = getExam();
    const total = exam.questionCount;
    if (total === 0) return;
    const allQuestions = exam.questions;
    const currentIndex = allQuestions.findIndex(
      (q) => questionId(exam.slug, q.order) === state.currentQuestionId
    );
    const pct = currentIndex >= 0 ? ((currentIndex + 1) / total) * 100 : 0;
    els.progressFill.style.width = `${pct}%`;
  }

  /* ── render: exam list ───────────────────────────────── */
  function renderExamList() {
    els.examList.innerHTML = "";
    for (const exam of bank.exams) {
      const button = document.createElement("button");
      button.type = "button";
      button.className = `exam-card${exam.slug === state.selectedExam ? " is-active" : ""}`;
      const answered = exam.questions.filter(
        (q) => getQuestionProgress(questionId(exam.slug, q.order)).checked
      ).length;
      button.innerHTML = `<h3>${exam.title}</h3><p>${exam.questionCount}問 / 回答済み ${answered}問</p>`;
      button.addEventListener("click", () => {
        state.selectedExam = exam.slug;
        state.filter = "all";
        state.search = "";
        state.revealed = false;
        els.searchInput.value = "";
        ensureCurrentQuestion();
        render();
      });
      els.examList.appendChild(button);
    }
  }

  /* ── render: filters ─────────────────────────────────── */
  function renderFilters() {
    els.filterList.innerHTML = "";
    for (const filter of filters) {
      const button = document.createElement("button");
      button.type = "button";
      button.className = `filter-chip${filter.id === state.filter ? " is-active" : ""}`;
      button.textContent = filter.label;
      button.addEventListener("click", () => {
        state.filter = filter.id;
        ensureCurrentQuestion();
        render();
      });
      els.filterList.appendChild(button);
    }
  }

  /* ── render: question map ────────────────────────────── */
  function renderQuestionMap() {
    const exam = getExam();
    const visibleIds = new Set(getVisibleQuestions().map((q) => questionId(exam.slug, q.order)));
    els.questionMap.innerHTML = "";
    for (const question of exam.questions) {
      const id = questionId(exam.slug, question.order);
      const progress = getQuestionProgress(id);
      const button = document.createElement("button");
      button.type = "button";
      button.className = "question-dot";
      if (id === state.currentQuestionId)                button.classList.add("is-current");
      if (progress.checked && progress.correct === true)  button.classList.add("is-correct");
      if (progress.checked && progress.correct === false) button.classList.add("is-incorrect");
      if (progress.bookmarked)                             button.classList.add("is-bookmarked");
      if (!visibleIds.has(id)) button.style.opacity = "0.28";
      button.textContent = question.order;
      button.addEventListener("click", () => {
        state.currentQuestionId = id;
        state.revealed = false;
        render();
      });
      els.questionMap.appendChild(button);
    }
  }

  /* ── render: source answer ───────────────────────────── */
  function renderSourceAnswer(question) {
    const source = question.sourceAnswer;
    const lines = [];
    if (source.selected.length)           lines.push(`元の選択: ${source.selected.join(", ")}`);
    if (source.memo)                       lines.push(`元メモ:\n${source.memo}`);
    if (source.originalCorrect === true)   lines.push("元ノート判定: 正解できた");
    if (source.originalCorrect === false)  lines.push("元ノート判定: 間違えた");
    if (source.reviewPoint)                lines.push(`復習ポイント: ${source.reviewPoint}`);
    els.sourceAnswer.textContent = lines.length ? lines.join("\n\n") : "元ノートの回答メモは未記入です。";
  }

  /* ── render: options ─────────────────────────────────── */
  function renderOptions(question, progress) {
    els.optionsGrid.innerHTML = "";
    for (const option of question.options) {
      const button = document.createElement("button");
      button.type = "button";
      button.className = "option-card";
      const isSelected = state.draftSelection.includes(option.key);
      if (isSelected)                                                             button.classList.add("is-selected");
      if (progress.checked && question.correctAnswers.includes(option.key))      button.classList.add("is-correct");
      if (progress.checked && isSelected && !question.correctAnswers.includes(option.key)) button.classList.add("is-wrong");
      button.innerHTML = `
        <span class="badge">${option.key}</span>
        <div class="option-label">${option.label}</div>
      `;
      button.addEventListener("click", () => {
        if (question.multiSelect) {
          state.draftSelection = state.draftSelection.includes(option.key)
            ? state.draftSelection.filter((v) => v !== option.key)
            : [...state.draftSelection, option.key];
        } else {
          state.draftSelection = [option.key];
        }
        persistDraft(question);
        render();
      });
      els.optionsGrid.appendChild(button);
    }
  }

  /* ── render: result / insight ────────────────────────── */
  function renderResult(question, progress) {
    els.correctAnswerText.textContent  = (progress.checked || state.revealed)
      ? question.correctAnswers.join(", ")
      : "採点後に表示";
    els.selectedAnswerText.textContent = progress.selected.length ? progress.selected.join(", ") : "未選択";
    els.explanationContent.innerHTML   = state.revealed || progress.checked
      ? question.explanationHtml
      : "<p>採点後に解説を表示できます。</p>";

    if (question.practiceHtml) {
      els.practiceWrap.hidden     = !(state.revealed || progress.checked);
      els.practiceContent.innerHTML = question.practiceHtml;
    } else {
      els.practiceWrap.hidden     = true;
      els.practiceContent.innerHTML = "";
    }

    els.resultChip.className = "result-chip";
    if (!progress.checked) {
      els.resultChip.classList.add("state-idle");
      els.resultChip.textContent = "未採点";
    } else if (progress.correct) {
      els.resultChip.classList.add("state-correct");
      els.resultChip.textContent = "✓ 正解";
    } else {
      els.resultChip.classList.add("state-wrong");
      els.resultChip.textContent = "✕ 要復習";
    }

    els.toggleExplanationButton.textContent = state.revealed ? "解説を閉じる" : "解説を開く";
  }

  /* ── render: question ────────────────────────────────── */
  function renderQuestion(question) {
    const exam = getExam();
    const id   = questionId(exam.slug, question.order);
    const progress = getQuestionProgress(id);
    state.draftSelection = [...progress.selected];

    els.currentExamTitle.textContent = exam.title;
    els.currentExamMeta.textContent  = exam.metadata.join(" / ");
    els.questionPosition.textContent = `${question.order} / ${exam.questionCount}`;
    els.questionTitle.textContent    = question.title;
    els.selectModeBadge.textContent  = question.multiSelect ? "複数選択" : "単一選択";
    els.questionStem.innerHTML       = question.stemHtml;
    els.userNote.value               = progress.note || "";

    renderSourceAnswer(question);

    const bookmarkSpan = els.bookmarkButton.querySelector("span");
    els.bookmarkButton.classList.toggle("is-active", !!progress.bookmarked);
    if (bookmarkSpan) bookmarkSpan.textContent = progress.bookmarked ? "Bookmarked" : "Bookmark";

    renderOptions(question, progress);
    renderResult(question, progress);
  }

  /* ── persist ─────────────────────────────────────────── */
  function persistDraft(question) {
    const id = questionId(getExam().slug, question.order);
    state.progress[id] = {
      ...getQuestionProgress(id),
      selected: [...state.draftSelection],
      note:     els.userNote.value,
    };
    saveProgress();
  }

  /* ── check answer ────────────────────────────────────── */
  function checkAnswer() {
    const question = getCurrentQuestion();
    if (!question) return;
    if (state.draftSelection.length === 0) return;
    const id = questionId(getExam().slug, question.order);
    const correct = compareSelections(state.draftSelection, question.correctAnswers);
    state.progress[id] = {
      ...getQuestionProgress(id),
      selected: [...state.draftSelection],
      note:     els.userNote.value,
      checked:  true,
      correct,
    };
    state.revealed = true;
    saveProgress();
    render();
  }

  /* ── bookmark ────────────────────────────────────────── */
  function toggleBookmark() {
    const question = getCurrentQuestion();
    if (!question) return;
    const id = questionId(getExam().slug, question.order);
    const progress = getQuestionProgress(id);
    state.progress[id] = {
      ...progress,
      bookmarked: !progress.bookmarked,
      selected:   [...state.draftSelection],
      note:       els.userNote.value,
    };
    saveProgress();
    render();
  }

  /* ── navigation ──────────────────────────────────────── */
  function moveQuestion(step) {
    const visible = getVisibleQuestions();
    const currentIndex = visible.findIndex(
      (q) => questionId(getExam().slug, q.order) === state.currentQuestionId
    );
    const next = visible[currentIndex + step];
    if (next) {
      state.currentQuestionId = questionId(getExam().slug, next.order);
      state.revealed = false;
      render();
    }
  }

  /* ── reset progress ──────────────────────────────────── */
  function resetExamProgress() {
    if (!confirm("このセットの進捗をすべてリセットしますか？")) return;
    const exam = getExam();
    for (const question of exam.questions) {
      delete state.progress[questionId(exam.slug, question.order)];
    }
    saveProgress();
    state.revealed = false;
    render();
  }

  /* ── sidebar toggle ──────────────────────────────────── */
  function bindSidebarToggle() {
    els.sidebarToggle.addEventListener("click", () => {
      els.appShell.classList.toggle("sidebar-collapsed");
    });
  }

  /* ── event binding ───────────────────────────────────── */
  function bindEvents() {
    els.searchInput.addEventListener("input", (e) => {
      state.search = e.target.value;
      ensureCurrentQuestion();
      render();
    });

    els.userNote.addEventListener("input", () => {
      const question = getCurrentQuestion();
      if (!question) return;
      persistDraft(question);
      updateStats();
    });

    els.checkAnswerButton.addEventListener("click",       checkAnswer);
    els.toggleExplanationButton.addEventListener("click", () => {
      state.revealed = !state.revealed;
      render();
    });
    els.bookmarkButton.addEventListener("click",     toggleBookmark);
    els.prevQuestionButton.addEventListener("click", () => moveQuestion(-1));
    els.nextQuestionButton.addEventListener("click", () => moveQuestion(1));
    els.exportProgressButton.addEventListener("click", exportProgress);
    els.importProgressButton.addEventListener("click", () => els.importProgressFile.click());
    els.importProgressFile.addEventListener("change", (e) => importProgressFile(e.target.files[0]));
    els.resetProgressButton.addEventListener("click", resetExamProgress);

    window.addEventListener("keydown", (e) => {
      const question = getCurrentQuestion();
      if (!question) return;
      if (e.target && ["INPUT", "TEXTAREA"].includes(e.target.tagName)) return;

      const key = e.key.toUpperCase();

      if (/^[A-E]$/.test(key) && question.options.some((o) => o.key === key)) {
        if (question.multiSelect) {
          state.draftSelection = state.draftSelection.includes(key)
            ? state.draftSelection.filter((v) => v !== key)
            : [...state.draftSelection, key];
        } else {
          state.draftSelection = [key];
        }
        persistDraft(question);
        render();
      } else if (e.key === "Enter") {
        e.preventDefault();
        checkAnswer();
      } else if (e.key === " ") {
        e.preventDefault();
        state.revealed = !state.revealed;
        render();
      } else if (e.key === "ArrowRight") {
        moveQuestion(1);
      } else if (e.key === "ArrowLeft") {
        moveQuestion(-1);
      }
    });
  }

  /* ── main render ─────────────────────────────────────── */
  function render() {
    ensureCurrentQuestion();
    const current = getCurrentQuestion();
    renderExamList();
    renderFilters();
    updateStats();
    if (!current) return;
    renderQuestionMap();
    renderQuestion(current);
    updateProgressBar();
  }

  bindSidebarToggle();
  bindEvents();
  ensureCurrentQuestion();
  render();
})();
