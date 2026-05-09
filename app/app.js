(function () {
  /* ── Mermaid initialization ───────────────────────────── */
  if (window.mermaid) {
    mermaid.initialize({
      startOnLoad: false,
      theme: "base",
      themeVariables: {
        background:          "#06101f",
        primaryColor:        "#162440",
        primaryBorderColor:  "#3a9fff",
        primaryTextColor:    "#d9ebff",
        secondaryColor:      "#0f1b34",
        tertiaryColor:       "#1d3255",
        lineColor:           "#5bb8ff",
        edgeLabelBackground: "#0d1a2e",
        clusterBkg:          "#0a1525",
        clusterBorder:       "#3a9fff",
        titleColor:          "#8fd3ff",
        fontFamily:          "'Plus Jakarta Sans', 'Noto Sans JP', system-ui, sans-serif",
        fontSize:            "14px",
      },
    });
  }

  const bank = window.SNOWFLAKE_ATLAS_BANK;
  const storageKey = "snowflake-atlas-v1";
  const articlesBySlug = Object.fromEntries(bank.articles.map((a) => [a.slug, a]));
  const urlParams = new URLSearchParams(window.location.search);
  const initialArticleSlug = urlParams.get("article");
  const initialSectionId = urlParams.get("section");

  const state = {
    search: "",
    currentArticleSlug: articlesBySlug[initialArticleSlug] ? initialArticleSlug : bank.articles[0]?.slug || "",
    currentSectionId: initialSectionId || "",
    progress: loadProgress(),
  };

  let scrollSpyObserver = null;

  const els = {
    appShell:             document.getElementById("app-shell"),
    sidebarToggle:        document.getElementById("sidebar-toggle"),
    articleList:          document.getElementById("article-list"),
    sectionList:          document.getElementById("section-list"),
    searchInput:          document.getElementById("search-input"),
    currentArticleTitle:  document.getElementById("current-article-title"),
    currentArticleMeta:   document.getElementById("current-article-meta"),
    completedCount:       document.getElementById("completed-count"),
    bookmarkCount:        document.getElementById("bookmark-count"),
    articleCount:         document.getElementById("article-count"),
    sectionPosition:      document.getElementById("section-position"),
    articlePosition:      document.getElementById("article-position"),
    articleHeading:       document.getElementById("article-heading"),
    articleContent:       document.getElementById("article-content"),
    statusBadge:          document.getElementById("status-badge"),
    userNote:             document.getElementById("user-note"),
    toggleCompleteButton: document.getElementById("toggle-complete-button"),
    toggleBookmarkButton: document.getElementById("toggle-bookmark-button"),
    prevArticleButton:    document.getElementById("prev-article-button"),
    nextArticleButton:    document.getElementById("next-article-button"),
    metaPanel:            document.getElementById("article-meta-panel"),
    currentAnchorLink:    document.getElementById("current-anchor-link"),
    resetProgressButton:  document.getElementById("reset-progress-button"),
    progressFill:         document.getElementById("q-progress-fill"),
  };

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

  function getArticleProgress(slug) {
    return state.progress[slug] || { completed: false, bookmarked: false, note: "" };
  }

  function getArticleMetadata(article) {
    const classification = [
      article.track ? `Track: ${article.track}` : "",
      article.level ? `Level: ${article.level}` : "",
      article.depth ? `Depth: ${article.depth}` : "",
      article.contentType ? `Type: ${article.contentType}` : "",
    ].filter(Boolean);
    return [...classification, ...article.metadata.filter((item) => !item.startsWith("レベル:"))];
  }

  /* ── helpers ─────────────────────────────────────────── */
  function getVisibleArticles() {
    const term = state.search.trim().toLowerCase();
    return bank.articles.filter(
      (a) => !term || a.title.toLowerCase().includes(term) || a.searchText.toLowerCase().includes(term)
    );
  }

  function getCurrentArticle() {
    const visible = getVisibleArticles();
    return visible.find((a) => a.slug === state.currentArticleSlug) || visible[0] || bank.articles[0];
  }

  function ensureCurrentArticle() {
    const current = getCurrentArticle();
    if (current) {
      state.currentArticleSlug = current.slug;
      state.currentSectionId = current.sections[0]?.id || "";
    }
  }

  function persistCurrentNote() {
    const article = getCurrentArticle();
    if (!article) return;
    state.progress[article.slug] = { ...getArticleProgress(article.slug), note: els.userNote.value };
    saveProgress();
  }

  /* ── stats ───────────────────────────────────────────── */
  function updateStats() {
    const items = bank.articles.map((a) => getArticleProgress(a.slug));
    const completed  = items.filter((i) => i.completed).length;
    const bookmarked = items.filter((i) => i.bookmarked).length;
    const current = getCurrentArticle();
    const currentIndex = bank.articles.findIndex((a) => a.slug === current.slug);

    els.completedCount.textContent  = String(completed);
    els.bookmarkCount.textContent   = String(bookmarked);
    els.articleCount.textContent    = String(bank.articleCount);
    els.sectionPosition.textContent = `${currentIndex + 1}/${bank.articleCount}`;
  }

  function updateProgressBar() {
    const currentIndex = bank.articles.findIndex((a) => a.slug === state.currentArticleSlug);
    const pct = currentIndex >= 0 ? ((currentIndex + 1) / bank.articleCount) * 100 : 0;
    els.progressFill.style.width = `${pct}%`;
  }

  /* ── render: article list ────────────────────────────── */
  function renderArticleList() {
    const visibleSlugs = new Set(getVisibleArticles().map((a) => a.slug));
    els.articleList.innerHTML = "";
    for (const article of bank.articles) {
      const progress = getArticleProgress(article.slug);
      const button = document.createElement("button");
      button.type = "button";
      button.className = `article-card${article.slug === state.currentArticleSlug ? " is-active" : ""}`;
      if (!visibleSlugs.has(article.slug)) button.hidden = true;

      const stateLabel = progress.completed
        ? "学習済み"
        : progress.bookmarked
        ? "ブックマーク"
        : "未学習";
      const classification = [article.level, article.depth, article.contentType].filter(Boolean).join(" / ");
      button.innerHTML = `<h3>${article.title}</h3><p>${classification || stateLabel}</p><p>${stateLabel}</p>`;

      button.addEventListener("click", () => {
        state.currentArticleSlug = article.slug;
        state.currentSectionId = article.sections[0]?.id || "";
        render();
      });
      els.articleList.appendChild(button);
    }
  }

  /* ── render: section list ────────────────────────────── */
  function renderSectionList(article) {
    els.sectionList.innerHTML = "";
    for (const section of article.sections) {
      const button = document.createElement("button");
      button.type = "button";
      button.className = `section-card level-${section.level}${section.id === state.currentSectionId ? " is-active" : ""}`;
      button.dataset.sectionId = section.id;
      button.innerHTML = `<h3>${section.title}</h3>`;
      button.addEventListener("click", () => {
        state.currentSectionId = section.id;
        renderSectionFocus();
      });
      els.sectionList.appendChild(button);
    }
  }

  /* ── render: meta panel ──────────────────────────────── */
  function renderMeta(article) {
    const progress = getArticleProgress(article.slug);
    const items = [
      `ソース: ${article.fileName}`,
      `見出し数: ${article.sections.length}`,
      progress.completed ? "状態: 学習済み ✓" : "状態: 未学習",
      ...getArticleMetadata(article),
    ];
    els.metaPanel.innerHTML = items.map((item) => `<div class="meta-pill">${item}</div>`).join("");
  }

  /* ── render: status & action buttons ────────────────── */
  function renderStatus(article) {
    const progress = getArticleProgress(article.slug);

    /* status badge */
    els.statusBadge.className = "status-badge";
    if (progress.completed) {
      els.statusBadge.classList.add("is-complete");
      els.statusBadge.textContent = "学習済み";
    } else if (progress.bookmarked) {
      els.statusBadge.classList.add("is-bookmarked");
      els.statusBadge.textContent = "要再読";
    } else {
      els.statusBadge.textContent = "未学習";
    }

    /* complete button */
    els.toggleCompleteButton.classList.toggle("is-active", progress.completed);
    els.toggleCompleteButton.textContent = progress.completed ? "学習済みを解除" : "学習済みにする";

    /* bookmark button */
    els.toggleBookmarkButton.classList.toggle("is-active", progress.bookmarked);
    const bookmarkSpan = els.toggleBookmarkButton.querySelector("span");
    if (bookmarkSpan) bookmarkSpan.textContent = progress.bookmarked ? "Bookmarked" : "Bookmark";
  }

  /* ── scroll spy ──────────────────────────────────────── */
  function setupScrollSpy(article) {
    if (scrollSpyObserver) {
      scrollSpyObserver.disconnect();
      scrollSpyObserver = null;
    }
    const sectionIds = new Set(article.sections.map((s) => s.id));
    if (!sectionIds.size) return;

    scrollSpyObserver = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter((e) => e.isIntersecting && sectionIds.has(e.target.id))
          .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
        if (!visible.length) return;

        const id = visible[0].target.id;
        state.currentSectionId = id;
        els.sectionList.querySelectorAll(".section-card").forEach((node) => {
          node.classList.toggle("is-active", node.dataset.sectionId === id);
        });
        if (els.currentAnchorLink) els.currentAnchorLink.setAttribute("href", `#${id}`);
      },
      { rootMargin: "-8% 0px -65% 0px", threshold: 0 }
    );

    for (const id of sectionIds) {
      const el = document.getElementById(id);
      if (el) scrollSpyObserver.observe(el);
    }
  }

  /* ── render: section focus ───────────────────────────── */
  function renderSectionFocus() {
    const article = getCurrentArticle();
    const targetId = state.currentSectionId || article.sections[0]?.id;
    if (!targetId) return;

    const target = document.getElementById(targetId);
    els.sectionList.querySelectorAll(".section-card").forEach((node) => {
      node.classList.toggle("is-active", node.dataset.sectionId === targetId);
    });
    if (target) {
      target.scrollIntoView({ behavior: "smooth", block: "start" });
      if (els.currentAnchorLink) els.currentAnchorLink.setAttribute("href", `#${targetId}`);
    }
  }

  /* ── bind inline article links ───────────────────────── */
  function bindInlineArticleLinks() {
    els.articleContent.querySelectorAll("[data-article-link]").forEach((anchor) => {
      anchor.addEventListener("click", (event) => {
        event.preventDefault();
        const slug = anchor.getAttribute("data-article-link");
        if (!articlesBySlug[slug]) return;
        state.currentArticleSlug = slug;
        state.currentSectionId = articlesBySlug[slug].sections[0]?.id || "";
        render();
      });
    });
  }

  function decodeDiagramPayload(value) {
    try {
      return decodeURIComponent(escape(window.atob(value)));
    } catch {
      return window.atob(value);
    }
  }

  function isFlowLike(raw) {
    return /[→←▶↓]/.test(raw) || /^\s*\[.+\]/m.test(raw) || /^\s*┌/.test(raw);
  }

  function normalizeDiagramText(text) {
    return text
      .replace(/[│┌┐└┘├┤┬┴]/g, " ")
      .replace(/\s+/g, " ")
      .trim();
  }

  function isThreeLayerArchitectureDiagram(raw) {
    return (
      raw.includes("Cloud Services Layer") &&
      raw.includes("Query Processing Layer") &&
      raw.includes("Database Storage Layer")
    );
  }

  function isCacheArchitectureDiagram(raw) {
    return (
      raw.includes("Result Cache") &&
      raw.includes("Local Disk Cache") &&
      raw.includes("Metadata Cache")
    );
  }

  function isObjectHierarchyDiagram(raw) {
    return (
      raw.includes("Organization") &&
      raw.includes("Account") &&
      raw.includes("Schema") &&
      raw.includes("Warehouse")
    );
  }

  function isMultiClusterDiagram(raw) {
    return (
      raw.includes("通常時") &&
      raw.includes("繁忙時") &&
      raw.includes("Snap Back") &&
      raw.includes("クラスタ1")
    );
  }

  function isCertificationPathDiagram(raw) {
    return raw.includes("SnowPro Associate") && raw.includes("SnowPro Core");
  }

  function isWarehouseNodesDiagram(raw) {
    return raw.includes("Virtual Warehouse") && raw.includes("ノード1") && raw.includes("ノード16");
  }

  function isPartitionPruningDiagram(raw) {
    return raw.includes("パーティション1:") && raw.includes("スキャン ✓");
  }

  function isClusteringComparisonDiagram(raw) {
    return raw.includes("クラスタリング前") && raw.includes("クラスタリング後");
  }

  function isNotebookCellsDiagram(raw) {
    return raw.includes("[Markdown]") && raw.includes("[SQL]") && raw.includes("[Python]");
  }

  function isWorksheetDashboardDiagram(raw) {
    return raw.includes("Add to Dashboard") && raw.includes("ワークシート");
  }

  function isQueryProfileDiagram(raw) {
    return raw.includes("クエリプロファイルの構造例");
  }

  function isLoadPipelineDiagram(raw) {
    return raw.includes("外部データ") && raw.includes("Snowflakeテーブル");
  }

  function isLoadDecisionDiagram(raw) {
    return raw.includes("データロード方法の選択フローチャート");
  }

  function isStageTypesDiagram(raw) {
    return raw.includes("Internal Stage") && raw.includes("External Stage");
  }

  function isSnowpipeFlowDiagram(raw) {
    return raw.includes("Snowpipe") && raw.includes("自動でCOPY INTO実行");
  }

  function isTableTypeDecisionDiagram(raw) {
    return raw.includes("テーブル種類の選択");
  }

  function isPipeTransformDiagram(raw) {
    return raw.includes("ステージ上のファイル") && raw.includes("REPLACE()");
  }

  function isStreamTaskComparisonDiagram(raw) {
    return raw.includes("全行スキャン型タスク") && raw.includes("ストリーム＋タスク型");
  }

  function isNetworkPolicyDiagram(raw) {
    return raw.includes("Network Policy") && raw.includes("許可: 社内IP");
  }

  function isEncryptionDiagram(raw) {
    return raw.includes("End-to-End Encryption");
  }

  function isKeyHierarchyDiagram(raw) {
    return raw.includes("Root Key") && raw.includes("File Key");
  }

  function isResourceMonitorDiagram(raw) {
    return raw.includes("Resource Monitor") && raw.includes("75%到達");
  }

  function isPolicyInheritanceDiagram(raw) {
    return raw.includes("Account（アカウント）") && raw.includes("Session（セッション）");
  }

  function isAuthenticationFlowDiagram(raw) {
    return raw.includes("ログイン時の流れ") && raw.includes("Authentication");
  }

  function isPrincipalRoleObjectDiagram(raw) {
    return raw.includes("ユーザー（John）") && raw.includes("analyst_role");
  }

  function isSystemRoleHierarchyDiagram(raw) {
    return raw.includes("ACCOUNTADMIN") && raw.includes("SYSADMIN") && raw.includes("SECURITYADMIN");
  }

  function isOwnershipRoleDiagram(raw) {
    return raw.includes("data_owner_role") && raw.includes("analyst_role");
  }

  function isMaskingPolicyDiagram(raw) {
    return raw.includes("admin_role") && raw.includes("***@***.***");
  }

  function isCortexArchitectureDiagram(raw) {
    return raw.includes("Snowflake Cortex") && raw.includes("Your Data");
  }

  function isEmbeddingSimilarityDiagram(raw) {
    return raw.includes("犬") && raw.includes("猫") && raw.includes("車");
  }

  function isTraditionalVsCortexDiagram(raw) {
    return raw.includes("従来のAI利用") && raw.includes("Cortex利用");
  }

  function isTimeTravelTimelineDiagram(raw) {
    return raw.includes("現在時刻") && raw.includes("Time Travel範囲");
  }

  function isTimeTravelVsFailSafeDiagram(raw) {
    return raw.includes("Time Travel期間") && raw.includes("Fail-safe");
  }

  function isZeroCopyCloneDiagram(raw) {
    return raw.includes("元テーブル") && raw.includes("クローン") && raw.includes("[A][B][C][D]");
  }

  function isSharingDiagram(raw) {
    return raw.includes("Provider Account") && raw.includes("Consumer Account");
  }

  function isDataTypeCatalogDiagram(raw) {
    return raw.includes("数値型") && raw.includes("半構造化型") && raw.includes("VARIANT");
  }

  function isRankingDiagram(raw) {
    return raw.includes("RANK():") && raw.includes("DENSE_RANK():") && raw.includes("ROW_NUMBER():");
  }

  function isOneToManyDiagram(raw) {
    return raw.includes("BOOKテーブル") && raw.includes("AUTHORテーブル") && !raw.includes("BOOK_AUTHORテーブル");
  }

  function isManyToManyDiagram(raw) {
    return raw.includes("BOOK_AUTHORテーブル");
  }

  function isExternalTablePipelineDiagram(raw) {
    return raw.includes("External Table") && raw.includes("AUTO_REFRESH");
  }

  function renderDiagramHeader(kicker, title, copy) {
    return `
      <div class="diagram-header-block">
        <p class="architecture-kicker">${kicker}</p>
        <h4>${title}</h4>
        <p class="architecture-copy">${copy}</p>
      </div>
    `;
  }

  function renderTimelineGraphic({ kicker, title, copy, steps, note, className = "" }) {
    const wrapper = document.createElement("section");
    wrapper.className = `diagram-graphic diagram-graphic-journey ${className}`.trim();
    wrapper.innerHTML = `
      ${renderDiagramHeader(kicker, title, copy)}
      <div class="journey-steps">
        ${steps
          .map(
            (step, index) => `
              <article class="journey-step">
                <div class="journey-index">${index + 1}</div>
                <div class="journey-body">
                  <h5>${step.title}</h5>
                  <p>${step.text}</p>
                </div>
              </article>
            `
          )
          .join("")}
      </div>
      ${note ? `<div class="architecture-note"><strong>理解ポイント</strong><span>${note}</span></div>` : ""}
    `;
    return wrapper;
  }

  function renderPipelineGraphic({ kicker, title, copy, nodes, note, className = "" }) {
    const wrapper = document.createElement("section");
    wrapper.className = `diagram-graphic diagram-graphic-pipeline ${className}`.trim();
    wrapper.innerHTML = `
      ${renderDiagramHeader(kicker, title, copy)}
      <div class="pipeline-row">
        ${nodes
          .map(
            (node, index) => `
              <div class="pipeline-segment">
                <article class="pipeline-node ${node.tone || ""}">
                  <h5>${node.title}</h5>
                  <p>${node.text || ""}</p>
                </article>
                ${index < nodes.length - 1 ? `<div class="pipeline-arrow">${node.arrow || "→"}</div>` : ""}
              </div>
            `
          )
          .join("")}
      </div>
      ${note ? `<div class="architecture-note"><strong>理解ポイント</strong><span>${note}</span></div>` : ""}
    `;
    return wrapper;
  }

  function renderComparisonGraphic({ kicker, title, copy, columns, note, className = "" }) {
    const wrapper = document.createElement("section");
    wrapper.className = `diagram-graphic diagram-graphic-compare ${className}`.trim();
    wrapper.innerHTML = `
      ${renderDiagramHeader(kicker, title, copy)}
      <div class="comparison-grid">
        ${columns
          .map(
            (column) => `
              <article class="comparison-card ${column.tone || ""}">
                <div class="comparison-head">
                  <h5>${column.title}</h5>
                  ${column.badge ? `<span class="comparison-badge">${column.badge}</span>` : ""}
                </div>
                <p>${column.text || ""}</p>
                ${
                  column.points?.length
                    ? `<ul class="comparison-points">${column.points.map((point) => `<li>${point}</li>`).join("")}</ul>`
                    : ""
                }
              </article>
            `
          )
          .join("")}
      </div>
      ${note ? `<div class="architecture-note"><strong>理解ポイント</strong><span>${note}</span></div>` : ""}
    `;
    return wrapper;
  }

  function renderThreeLayerArchitectureDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-architecture";
    wrapper.innerHTML = `
      <div class="architecture-header">
        <p class="architecture-kicker">Snowflake Architecture</p>
        <h4>3つの層が独立して役割分担する</h4>
        <p class="architecture-copy">保存、実行、制御を分けることで、必要な場所だけをスケールできる構造です。</p>
      </div>
      <div class="architecture-stack">
        <article class="architecture-layer layer-cloud">
          <div class="layer-rail">
            <span class="layer-chip">頭脳</span>
            <span class="layer-icon">Control</span>
          </div>
          <div class="layer-body">
            <h5>Cloud Services Layer</h5>
            <p>認証、メタデータ管理、クエリ最適化を担当し、全体を制御します。</p>
          </div>
        </article>
        <div class="architecture-connector"><span>↓</span></div>
        <article class="architecture-layer layer-compute">
          <div class="layer-rail">
            <span class="layer-chip">作業者</span>
            <span class="layer-icon">Compute</span>
          </div>
          <div class="layer-body">
            <h5>Query Processing Layer</h5>
            <p>Virtual Warehouse がクエリ実行や計算処理を担います。</p>
          </div>
        </article>
        <div class="architecture-connector"><span>↓</span></div>
        <article class="architecture-layer layer-storage">
          <div class="layer-rail">
            <span class="layer-chip">倉庫</span>
            <span class="layer-icon">Storage</span>
          </div>
          <div class="layer-body">
            <h5>Database Storage Layer</h5>
            <p>クラウドストレージにデータを保存し、安全に保管します。</p>
          </div>
        </article>
      </div>
      <div class="architecture-footer">
        <div class="architecture-note">
          <strong>理解ポイント</strong>
          <span>Compute だけ増やしても Storage コストは連動せず、逆も同様です。</span>
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderCacheArchitectureDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-cache";
    wrapper.innerHTML = `
      <div class="cache-header">
        <p class="architecture-kicker">Caching Strategy</p>
        <h4>3種類のキャッシュが速度とコストを支える</h4>
        <p class="architecture-copy">何を保存するかと、Warehouse が必要かどうかを分けて覚えると整理しやすいです。</p>
      </div>
      <div class="cache-layers">
        <div class="cache-band band-cloud">
          <div class="cache-band-label">Cloud Services層</div>
          <article class="cache-card cache-result">
            <div class="cache-card-head">
              <h5>Result Cache</h5>
              <span class="cache-chip">Warehouse不要</span>
            </div>
            <p>クエリ結果そのものを保存し、同じクエリなら即座に返します。</p>
            <ul class="cache-points">
              <li>保存対象: 実行結果</li>
              <li>保持: 24時間</li>
              <li>効果: 再実行コストをほぼゼロ化</li>
            </ul>
          </article>
        </div>
        <div class="cache-band band-compute">
          <div class="cache-band-label">Compute層</div>
          <article class="cache-card cache-local">
            <div class="cache-card-head">
              <h5>Local Disk Cache</h5>
              <span class="cache-chip">Warehouse依存</span>
            </div>
            <p>Warehouse の SSD にデータを置き、よく使うデータを高速読み込みします。</p>
            <ul class="cache-points">
              <li>保存対象: データ本体</li>
              <li>保持: Warehouse稼働中のみ</li>
              <li>効果: 同じ Warehouse の繰り返し処理を高速化</li>
            </ul>
          </article>
        </div>
        <div class="cache-band band-cloud">
          <div class="cache-band-label">Cloud Services層</div>
          <article class="cache-card cache-meta">
            <div class="cache-card-head">
              <h5>Metadata Cache</h5>
              <span class="cache-chip">統計情報</span>
            </div>
            <p>テーブル統計を保存し、COUNT(*) などを素早く返します。</p>
            <ul class="cache-points">
              <li>保存対象: 行数・最小値・最大値など</li>
              <li>保持: 管理メタデータとして継続利用</li>
              <li>効果: メタデータ参照系の即応答</li>
            </ul>
          </article>
        </div>
      </div>
      <div class="cache-footer">
        <div class="cache-legend">
          <span class="legend-dot legend-cloud"></span><span>Cloud Services は管理・結果・統計を担当</span>
        </div>
        <div class="cache-legend">
          <span class="legend-dot legend-compute"></span><span>Compute は実データを近くに置いて読む速度を上げる</span>
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderObjectHierarchyDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-hierarchy";
    wrapper.innerHTML = `
      <div class="hierarchy-header">
        <p class="architecture-kicker">Snowflake Object Hierarchy</p>
        <h4>上から下へ、管理の単位が細かくなる</h4>
        <p class="architecture-copy">契約単位から実際のオブジェクトまで、どこに何が属するかを線ではなく段構造で理解する図です。</p>
      </div>
      <div class="hierarchy-stack">
        <article class="hierarchy-node level-org">
          <div class="hierarchy-main">
            <h5>Organization</h5>
            <p>オプション。複数アカウントを持つ大企業向けの上位単位。</p>
          </div>
        </article>
        <div class="hierarchy-connector">↓</div>
        <article class="hierarchy-node level-account">
          <div class="hierarchy-main">
            <h5>Account</h5>
            <p>Snowflake の基本契約単位。ここにユーザー、ロール、Warehouse、Database がぶら下がります。</p>
          </div>
          <div class="hierarchy-children four-cols">
            <div class="hierarchy-leaf">User<br><span>ログイン主体</span></div>
            <div class="hierarchy-leaf">Role<br><span>権限のまとまり</span></div>
            <div class="hierarchy-leaf">Warehouse<br><span>コンピュート資源</span></div>
            <div class="hierarchy-leaf is-active">Database<br><span>論理データのまとまり</span></div>
          </div>
        </article>
        <div class="hierarchy-connector">↓</div>
        <article class="hierarchy-node level-database">
          <div class="hierarchy-main">
            <h5>Database</h5>
            <p>データベースの中に Schema があり、その下に実際のオブジェクトが配置されます。</p>
          </div>
        </article>
        <div class="hierarchy-connector">↓</div>
        <article class="hierarchy-node level-schema">
          <div class="hierarchy-main">
            <h5>Schema</h5>
            <p>テーブルやビューなどのオブジェクトを用途別にグループ化する単位。</p>
          </div>
          <div class="hierarchy-children object-grid">
            <div class="hierarchy-leaf">Table</div>
            <div class="hierarchy-leaf">View</div>
            <div class="hierarchy-leaf">Stage<br><span>ロード用一時領域</span></div>
            <div class="hierarchy-leaf">File Format</div>
            <div class="hierarchy-leaf">Stored Procedure</div>
            <div class="hierarchy-leaf">UDF</div>
            <div class="hierarchy-leaf">Stream</div>
            <div class="hierarchy-leaf">Task</div>
          </div>
        </article>
      </div>
      <div class="hierarchy-footer">
        <div class="architecture-note">
          <strong>覚え方</strong>
          <span>「契約単位(Account)の中に、実行資源(Warehouse)とデータ構造(Database→Schema→Object)がある」と整理すると混乱しにくいです。</span>
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderMultiClusterDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-multicluster";
    wrapper.innerHTML = `
      <div class="multicluster-header">
        <p class="architecture-kicker">Multi-Cluster Warehouse</p>
        <h4>負荷が増えると増設し、落ち着くと戻る</h4>
        <p class="architecture-copy">クエリ待ちを減らすためにクラスタを自動追加し、不要になれば自動で縮退する流れです。</p>
      </div>
      <div class="multicluster-flow">
        <article class="multicluster-stage">
          <div class="stage-title">通常時</div>
          <div class="cluster-row single">
            <div class="cluster-card">クラスタ1<span>全クエリを処理</span></div>
          </div>
        </article>
        <div class="stage-arrow">→</div>
        <article class="multicluster-stage is-busy">
          <div class="stage-title">繁忙時</div>
          <div class="cluster-grid">
            <div class="cluster-card">クラスタ1<span>クエリA, B</span></div>
            <div class="cluster-card is-new">クラスタ2<span>クエリC, D / 自動追加</span></div>
            <div class="cluster-card is-new">クラスタ3<span>クエリE, F / 自動追加</span></div>
          </div>
        </article>
        <div class="stage-arrow">→</div>
        <article class="multicluster-stage">
          <div class="stage-title">需要減（Snap Back）</div>
          <div class="cluster-row single">
            <div class="cluster-card">クラスタ1<span>クラスタ2, 3は自動削除</span></div>
          </div>
        </article>
      </div>
      <div class="multicluster-footer">
        <div class="architecture-note">
          <strong>理解ポイント</strong>
          <span>サイズ変更ではなく、クラスタ数を増減して同時実行をさばくのがマルチクラスタです。</span>
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderCertificationPathDiagram() {
    return renderTimelineGraphic({
      kicker: "Certification Path",
      title: "今いる位置と次に広がる学習ルート",
      copy: "Associate から Core に進み、その先で専門分野に枝分かれする流れを視覚化しています。",
      className: "is-certification",
      steps: [
        { title: "SnowPro Associate", text: "現在の学習ターゲット。まず基礎知識を固める段階です。" },
        { title: "SnowPro Core", text: "資格体系の土台。基礎運用や共通知識を横断的に押さえます。" },
        { title: "Advanced: Architect", text: "設計・アーキテクチャ寄りに深めるルートです。" },
        { title: "Advanced: Data Engineer", text: "データ基盤・パイプライン寄りに深めるルートです。" },
      ],
      note: "今の章がどの資格群につながるかを先に意識すると、用語の重み付けがしやすくなります。",
    });
  }

  function renderWarehouseNodesDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-cluster";
    wrapper.innerHTML = `
      ${renderDiagramHeader("Warehouse Structure", "1つの Warehouse は複数ノードでできている", "サイズを上げると、計算資源がノード単位で増えるイメージです。")}
      <div class="node-cluster">
        <div class="node-cluster-lead">
          <h5>Virtual Warehouse</h5>
          <p>X-Large のようなサイズ指定の裏では、複数ノードが並列に動いています。</p>
        </div>
        <div class="node-grid">
          ${["ノード1", "ノード2", "ノード3", "ノード4", "…", "ノード16"].map((label) => `
            <div class="node-card">
              <strong>${label}</strong>
              <span>CPU / メモリ / SSD</span>
            </div>
          `).join("")}
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderPartitionPruningDiagram() {
    const columns = [
      { title: "パーティション1", badge: "Skip", text: "2026-01-01 〜 2026-01-31", tone: "is-muted" },
      { title: "パーティション2", badge: "Skip", text: "2026-02-01 〜 2026-02-28", tone: "is-muted" },
      { title: "パーティション3", badge: "Scan", text: "2026-03-01 〜 2026-03-31", tone: "is-good" },
      { title: "パーティション4", badge: "Skip", text: "2026-04-01 〜 2026-04-30", tone: "is-muted" },
    ];
    return renderComparisonGraphic({
      kicker: "Micro-Partition Pruning",
      title: "必要な範囲だけを読んで、他は飛ばす",
      copy: "WHERE 条件に合うマイクロパーティションだけを読むので、全件スキャンを避けられます。",
      columns,
      note: "4つのうち 1 つだけ読めばよい状況が、Snowflake の高速化の基本です。",
      className: "is-pruning",
    });
  }

  function renderClusteringComparisonDiagram() {
    return renderComparisonGraphic({
      kicker: "Clustering Effect",
      title: "クラスタリングで読む量が 100% から 5% へ縮む",
      copy: "同じ REGION のデータを近くに集めると、対象パーティションが一気に減ります。",
      columns: [
        { title: "クラスタリング前", badge: "全体分散", text: "Tokyo のデータが 1,000 パーティションに散らばる", points: ["スキャン率 100%", "毎回ほぼ全体を読む"], tone: "is-warn" },
        { title: "クラスタリング後", badge: "集約", text: "Tokyo のデータが 50 パーティションにまとまる", points: ["スキャン率 5%", "必要部分だけに集中"], tone: "is-good" },
      ],
      note: "クラスタリングの価値は、保存の見た目ではなく検索時の読む量削減にあります。",
    });
  }

  function renderNotebookCellsDiagram() {
    return renderTimelineGraphic({
      kicker: "Notebook Flow",
      title: "Markdown・SQL・Python を1つのノートで往復する",
      copy: "説明、抽出、分析、可視化をセル単位で積み重ねるのが Notebooks の強みです。",
      steps: [
        { title: "Markdown", text: "分析の目的や前提を書く" },
        { title: "SQL", text: "必要なデータを Snowflake から取得する" },
        { title: "Python", text: "Pandas で集計・統計処理する" },
        { title: "Visualization", text: "グラフ化してレポートにまとめる" },
      ],
      note: "説明とコードが同じ流れに並ぶので、後から読み返しても分析意図を失いにくい構成です。",
    });
  }

  function renderWorksheetDashboardDiagram() {
    return renderTimelineGraphic({
      kicker: "Dashboard Workflow",
      title: "ワークシートの結果をそのままダッシュボードへ載せる",
      copy: "クエリ、可視化、配置、共有までが一直線につながる流れです。",
      steps: [
        { title: "1. Query", text: "ワークシートでクエリを実行する" },
        { title: "2. Chart", text: "実行結果をチャート化する" },
        { title: "3. Add", text: "Add to Dashboard で部品として追加する" },
        { title: "4. Layout", text: "レイアウトを並べ替える" },
        { title: "5. Share", text: "共有設定で他ユーザーへ公開する" },
      ],
    });
  }

  function renderQueryProfileDiagram() {
    return renderPipelineGraphic({
      kicker: "Query Profile",
      title: "クエリがどの順で処理されたかを追う",
      copy: "スキャン、フィルタ、集計のどこが重いかを段階ごとに見られます。",
      nodes: [
        { title: "Table Scan", text: "customers を 100万行スキャン", tone: "is-scan" },
        { title: "Filter", text: "region = 'APAC' で 10万行に絞る" },
        { title: "Aggregate", text: "SUM(amount) を計算" },
        { title: "Result", text: "1行の集計結果を返す", tone: "is-good" },
      ],
      note: "最初の Scan が大きすぎるなら、絞り込み条件やクラスタリングの見直し候補です。",
    });
  }

  function renderLoadPipelineDiagram() {
    return renderPipelineGraphic({
      kicker: "Data Loading",
      title: "外部データを Snowflake テーブルへ取り込む最短イメージ",
      copy: "CSV や JSON などの外部ファイルは、ロード処理を通じてテーブルに入ります。",
      nodes: [
        { title: "外部データ", text: "CSV / JSON / Parquet", tone: "is-source" },
        { title: "ロード処理", text: "COPY INTO や Snowpipe が実行", tone: "is-busy" },
        { title: "Snowflake テーブル", text: "分析可能な状態で保存", tone: "is-good" },
      ],
    });
  }

  function renderLoadDecisionDiagram() {
    return renderTimelineGraphic({
      kicker: "Load Method Selection",
      title: "データ量と更新頻度でロード方法を選ぶ",
      copy: "単発少量なのか、大量バッチなのか、継続到着なのかで最適解が変わります。",
      steps: [
        { title: "少量", text: "No の場合は INSERT または Web UI" },
        { title: "大量だが非継続", text: "Yes → No の場合は COPY INTO でバッチ処理" },
        { title: "継続到着", text: "Yes → Yes の場合は Snowpipe で自動ロード" },
      ],
    });
  }

  function renderStageTypesDiagram() {
    return renderComparisonGraphic({
      kicker: "Stage Types",
      title: "Internal と External で置き場所が違う",
      copy: "Snowflake の内側に置くか、既存クラウドストレージを参照するかで整理します。",
      columns: [
        { title: "Internal Stage", badge: "Snowflake内", text: "Snowflake 内部ストレージにファイルを置く", points: ["User Stage: @~", "Table Stage: @%", "Named Stage: @stage_name"] },
        { title: "External Stage", badge: "外部参照", text: "既存クラウドストレージを参照する", points: ["S3", "Azure Blob", "GCS"] },
      ],
      note: "試験では `@~` と `@%` の区別、External Stage が実体をコピーしない点が頻出です。",
    });
  }

  function renderSnowpipeFlowDiagram() {
    return renderPipelineGraphic({
      kicker: "Snowpipe",
      title: "ファイル到着を検知して自動で COPY INTO する",
      copy: "外部システムからのアップロードをきっかけに、継続的な取り込みを自動化します。",
      nodes: [
        { title: "外部システム", text: "ファイルを継続送信", tone: "is-source" },
        { title: "S3 / Azure", text: "到着ファイルを置くステージ", tone: "is-busy" },
        { title: "Snowpipe", text: "イベント検知 + COPY INTO 実行" },
        { title: "テーブル", text: "即時に取り込み完了", tone: "is-good" },
      ],
      note: "Snowpipe 自体がデータ変換するのではなく、到着検知と自動ロードを担います。",
    });
  }

  function renderTableTypeDecisionDiagram() {
    return renderComparisonGraphic({
      kicker: "Table Type Selection",
      title: "用途で Permanent / Temporary / Transient を分ける",
      copy: "永続性とコスト、復元性のバランスで選ぶ図です。",
      columns: [
        { title: "Permanent", badge: "本番", text: "本番データを長期保存する標準形", tone: "is-good" },
        { title: "Temporary", badge: "一時", text: "セッション内だけの一時データ", tone: "is-muted" },
        { title: "Transient", badge: "中間", text: "ETL ステージングや中間処理向け", tone: "is-warn" },
      ],
    });
  }

  function renderPipeTransformDiagram() {
    return renderTimelineGraphic({
      kicker: "Stage Transformation",
      title: "ステージ上のファイルを、その場で整形して読む",
      copy: "ロード前にファイルフォーマット適用、列参照、軽いクレンジングをかけられます。",
      steps: [
        { title: "Stage File", text: "ステージ上の元ファイルを参照する" },
        { title: "Format", text: "ファイルフォーマットを適用する" },
        { title: "Column Access", text: "$1, $2 ... で列を参照する" },
        { title: "Clean", text: "REPLACE(), TRIM() で整形する" },
        { title: "View", text: "ビューとして公開し SELECT できる形にする" },
      ],
    });
  }

  function renderStreamTaskComparisonDiagram() {
    return renderComparisonGraphic({
      kicker: "CDC Pattern",
      title: "全件比較より、変更差分だけを処理する",
      copy: "Stream + Task の価値は、データ量増加に対して処理量が膨らみにくいことです。",
      columns: [
        { title: "全行スキャン型", badge: "非効率", text: "毎回ターゲット全件とソース全件を比較", points: ["データ増加とともに遅くなる", "毎回重い比較が走る"], tone: "is-warn" },
        { title: "Stream + Task", badge: "効率的", text: "前回以降の変更分だけを取得して処理", points: ["常に差分だけ", "CDC に向く"], tone: "is-good" },
      ],
    });
  }

  function renderNetworkPolicyDiagram() {
    return renderPipelineGraphic({
      kicker: "Network Policy",
      title: "IP アドレスで入口を絞る",
      copy: "まず接続元 IP を判定し、許可された通信だけが Snowflake に到達します。",
      nodes: [
        { title: "インターネット", text: "さまざまな接続元", tone: "is-source" },
        { title: "Network Policy", text: "社内IPは許可、それ以外は拒否", tone: "is-busy" },
        { title: "Snowflake", text: "許可済みの接続だけ通す", tone: "is-good" },
      ],
    });
  }

  function renderEncryptionDiagram() {
    return renderComparisonGraphic({
      kicker: "Encryption",
      title: "通信中も保存時も、どちらも自動で暗号化される",
      copy: "Snowflake は転送中と保存時の両方を標準で保護します。",
      columns: [
        { title: "In Transit", badge: "TLS 1.2+", text: "すべての通信を暗号化", points: ["設定不要", "送受信時の盗聴対策"] },
        { title: "At Rest", badge: "AES-256", text: "保存データを自動暗号化", points: ["設定不要", "ストレージ上の保護"] },
      ],
    });
  }

  function renderKeyHierarchyDiagram() {
    return renderTimelineGraphic({
      kicker: "Encryption Key Hierarchy",
      title: "上位キーから下位キーへ守備範囲が細かくなる",
      copy: "Snowflake の暗号化は、多段のキー階層でデータを守ります。",
      steps: [
        { title: "Root Key", text: "最上位のルートキー" },
        { title: "Account Master Key", text: "アカウント全体を保護" },
        { title: "Table Master Key", text: "各テーブル単位で保護" },
        { title: "File Key", text: "各マイクロパーティションを保護" },
      ],
    });
  }

  function renderResourceMonitorDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-monitor";
    wrapper.innerHTML = `
      ${renderDiagramHeader("Cost Control", "Resource Monitor で使用量しきい値を監視する", "通知と停止条件を段階的に設定して、クレジット超過を防ぎます。")}
      <div class="monitor-card">
        <div class="monitor-metrics">
          <div><strong>上限</strong><span>1000 credits / 月</span></div>
          <div><strong>現在</strong><span>750 credits</span></div>
        </div>
        <div class="monitor-bar"><span style="width: 75%"></span></div>
        <div class="monitor-thresholds">
          <div>75%: 通知メール</div>
          <div>90%: 警告メール</div>
          <div>100%: Warehouse停止</div>
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderPolicyInheritanceDiagram() {
    return renderTimelineGraphic({
      kicker: "Policy Scope",
      title: "設定は Account → User → Session の順で細かくなる",
      copy: "上位で広く効かせ、必要なら下位で個別上書きするイメージです。",
      steps: [
        { title: "Account", text: "全ユーザーへ影響する全体設定" },
        { title: "User", text: "特定ユーザーへ限定して適用" },
        { title: "Session", text: "現在の接続だけに反映" },
      ],
    });
  }

  function renderAuthenticationFlowDiagram() {
    return renderTimelineGraphic({
      kicker: "Authentication vs Authorization",
      title: "まず本人確認、その後に権限確認",
      copy: "認証と認可を順番で分けると、似た言葉でも役割を混同しにくくなります。",
      steps: [
        { title: "Step 1", text: "ユーザー名 + パスワードで本人確認 = Authentication" },
        { title: "Step 2", text: "持っているロールと権限を確認 = Authorization" },
        { title: "Access", text: "確認が通ればオブジェクトへのアクセス開始" },
      ],
    });
  }

  function renderPrincipalRoleObjectDiagram() {
    return renderPipelineGraphic({
      kicker: "RBAC Basic Flow",
      title: "ユーザーはロールを通してオブジェクトへ届く",
      copy: "権限は直接ユーザーに貼るのではなく、通常はロール経由で管理します。",
      nodes: [
        { title: "User", text: "John", tone: "is-source" },
        { title: "Role", text: "analyst_role", tone: "is-busy" },
        { title: "Object", text: "Table / Warehouse など", tone: "is-good" },
      ],
      note: "SELECT や USAGE の付与先はロール側と覚えると、権限設計が整理しやすくなります。",
    });
  }

  function renderSystemRoleHierarchyDiagram() {
    return renderTimelineGraphic({
      kicker: "System Roles",
      title: "ACCOUNTADMIN 配下で役割ごとに責務が分かれる",
      copy: "最強権限を常用せず、作業内容に応じて下位ロールへ分担する考え方です。",
      steps: [
        { title: "ORGADMIN", text: "複数アカウントを持つ組織の上位管理" },
        { title: "ACCOUNTADMIN", text: "アカウント全体の最強権限" },
        { title: "SYSADMIN", text: "オブジェクト作成や運用を担当" },
        { title: "SECURITYADMIN", text: "権限管理を担当" },
        { title: "USERADMIN", text: "ユーザー / ロール作成を担当" },
        { title: "PUBLIC", text: "全ユーザーへ自動付与される既定ロール" },
      ],
    });
  }

  function renderOwnershipRoleDiagram() {
    return renderComparisonGraphic({
      kicker: "Ownership Design",
      title: "所有ロールを分けると権限委譲が整理しやすい",
      copy: "所有権と利用権を分離すると、運用ロールの責務がぶれにくくなります。",
      columns: [
        { title: "data_owner_role", badge: "所有", text: "テーブルを所有し、上位の管理責務を持つ", tone: "is-good" },
        { title: "analyst_role", badge: "参照", text: "SELECT のみを持つ", tone: "is-muted" },
        { title: "developer_role", badge: "更新", text: "SELECT / INSERT / UPDATE を持つ", tone: "is-busy" },
      ],
    });
  }

  function renderMaskingPolicyDiagram() {
    return renderComparisonGraphic({
      kicker: "Masking Policy",
      title: "同じ列でもロールによって見える値が変わる",
      copy: "生データを見せる相手と、マスクして見せる相手をロールで切り替えます。",
      columns: [
        { title: "admin_role", badge: "実データ", text: "john@example.com がそのまま見える", tone: "is-good" },
        { title: "analyst_role", badge: "マスク", text: "***@***.*** のように隠して見せる", tone: "is-warn" },
      ],
    });
  }

  function renderCortexArchitectureDiagram() {
    return renderPipelineGraphic({
      kicker: "Snowflake Cortex",
      title: "Snowflake 内のデータを、そのまま AI 機能へつなぐ",
      copy: "LLM 関数、ML 関数、Copilot を Snowflake 内部で呼べる構成です。",
      nodes: [
        { title: "Your Data", text: "Snowflake テーブル", tone: "is-source" },
        { title: "Snowflake Cortex", text: "LLM / ML / Copilot", tone: "is-busy" },
        { title: "Result", text: "外へ出さずに結果を返す", tone: "is-good" },
      ],
      note: "試験では『データが Snowflake 外に出ない』点が差別化ポイントです。",
    });
  }

  function renderEmbeddingSimilarityDiagram() {
    return renderComparisonGraphic({
      kicker: "Embeddings",
      title: "ベクトル空間では、近い意味ほど近い値になる",
      copy: "犬と猫は近く、犬と車は遠いという意味距離を数値化します。",
      columns: [
        { title: "犬", badge: "基準", text: "[0.23, 0.45, 0.12, ...]" },
        { title: "猫", badge: "近い", text: "[0.25, 0.43, 0.14, ...]", tone: "is-good" },
        { title: "車", badge: "遠い", text: "[0.78, 0.11, 0.56, ...]", tone: "is-warn" },
      ],
      note: "数値そのものを覚える必要はなく、『似た意味は近いベクトルになる』理解が重要です。",
    });
  }

  function renderTraditionalVsCortexDiagram() {
    return renderComparisonGraphic({
      kicker: "AI Usage Model",
      title: "外部へ送る従来型と、内部完結の Cortex を対比する",
      copy: "データ移動の有無が、セキュリティと運用負荷の差になります。",
      columns: [
        { title: "従来のAI利用", badge: "外部送信", text: "ユーザー → データ送信 → 外部AI → 結果受信", points: ["外部送信が発生", "セキュリティリスク"], tone: "is-warn" },
        { title: "Cortex利用", badge: "内部完結", text: "ユーザー → Snowflake内でAI処理 → 結果取得", points: ["データは外に出ない", "管理が単純"], tone: "is-good" },
      ],
    });
  }

  function renderTimeTravelTimelineDiagram() {
    return renderTimelineGraphic({
      kicker: "Time Travel",
      title: "過去の時点へ巻き戻して参照できる",
      copy: "現在時刻から遡って、保存された各時点の状態へアクセスできます。",
      steps: [
        { title: "現在 15:00", text: "今ここから参照を始める" },
        { title: "14:00", text: "1時間前の状態を参照可能" },
        { title: "13:00", text: "さらに前の状態も参照可能" },
        { title: "12:00 以前", text: "保持期間内なら任意時点へ戻れる" },
      ],
      note: "削除や更新ミスの復旧だけでなく、過去時点の検証にも使えます。",
    });
  }

  function renderTimeTravelVsFailSafeDiagram() {
    return renderComparisonGraphic({
      kicker: "Recovery Window",
      title: "Time Travel と Fail-safe は復元主体が違う",
      copy: "どちらも過去を扱いますが、誰が戻せるかと用途が異なります。",
      columns: [
        { title: "Time Travel", badge: "0-90日", text: "ユーザー自身が復元・参照できる期間", tone: "is-good" },
        { title: "Fail-safe", badge: "7日固定", text: "Snowflake 側のみ復元可能な最終保護", tone: "is-warn" },
      ],
    });
  }

  function renderZeroCopyCloneDiagram() {
    return renderComparisonGraphic({
      kicker: "Zero-Copy Clone",
      title: "最初は参照だけ、変更分だけが新しく増える",
      copy: "クローン直後は同じマイクロパーティションを共有し、変更時だけ差分を持ちます。",
      columns: [
        { title: "クローン直後", badge: "共有", text: "元テーブル [A][B][C][D] をそのまま参照", points: ["コピーではなく参照", "即時作成"], tone: "is-good" },
        { title: "変更後", badge: "差分課金", text: "クローン側の [B'] だけ新規ストレージ消費", points: ["元データはそのまま", "変更部分だけ増える"], tone: "is-busy" },
      ],
    });
  }

  function renderSharingDiagram() {
    return renderComparisonGraphic({
      kicker: "Secure Data Sharing",
      title: "原本は Provider 側、計算コストは Consumer 側",
      copy: "データコピーなしで共有しつつ、各自が自分の Warehouse でクエリします。",
      columns: [
        { title: "Provider Account", badge: "原本保持", text: "自分の Database を共有に出す", points: ["原本を保持", "データ提供者"] },
        { title: "Consumer Account", badge: "読取専用", text: "共有 Database を読み取り専用で使う", points: ["自分の Warehouse を使う", "クエリコストは Consumer 負担"] },
      ],
    });
  }

  function renderDataTypeCatalogDiagram() {
    return renderComparisonGraphic({
      kicker: "Data Type Catalog",
      title: "Snowflake の主要データ型を6カテゴリで整理する",
      copy: "試験では型名の丸暗記より、どのカテゴリに属するかの整理が効きます。",
      columns: [
        { title: "数値型", text: "NUMBER / INT / FLOAT" },
        { title: "文字列型", text: "VARCHAR / STRING / TEXT / CHAR" },
        { title: "日付・時刻型", text: "DATE / TIME / TIMESTAMP_*" },
        { title: "ブール型", text: "BOOLEAN" },
        { title: "半構造化型", text: "VARIANT / OBJECT / ARRAY" },
        { title: "バイナリ型", text: "BINARY / VARBINARY" },
      ],
      className: "is-six-grid",
    });
  }

  function renderRankingDiagram() {
    const wrapper = document.createElement("section");
    wrapper.className = "diagram-graphic diagram-graphic-ranking";
    wrapper.innerHTML = `
      ${renderDiagramHeader("Window Functions", "同点の扱いで RANK / DENSE_RANK / ROW_NUMBER が分かれる", "100, 90, 90, 80 を並べたときの順位の付き方を比較します。")}
      <div class="ranking-grid">
        <div class="ranking-card">
          <h5>RANK()</h5>
          <p>1, 2, 2, 4</p>
          <span>同順位の次を飛ばす</span>
        </div>
        <div class="ranking-card">
          <h5>DENSE_RANK()</h5>
          <p>1, 2, 2, 3</p>
          <span>同順位でも詰めて数える</span>
        </div>
        <div class="ranking-card">
          <h5>ROW_NUMBER()</h5>
          <p>1, 2, 3, 4</p>
          <span>同値でも一意な連番</span>
        </div>
      </div>
    `;
    return wrapper;
  }

  function renderOneToManyDiagram() {
    return renderComparisonGraphic({
      kicker: "One-to-Many Image",
      title: "BOOK と AUTHOR が独立して存在する基本形",
      copy: "まずは主テーブルが別々にある構造を押さえ、その後に中間表の必要性を理解します。",
      columns: [
        { title: "BOOK", text: "book_uid (PK) / title / ..." },
        { title: "AUTHOR", text: "author_uid (PK) / first_name / last_name" },
      ],
    });
  }

  function renderManyToManyDiagram() {
    return renderPipelineGraphic({
      kicker: "Many-to-Many",
      title: "中間テーブルが両者をつなぐ",
      copy: "BOOK と AUTHOR を直接つなぐのではなく、BOOK_AUTHOR が両方の UID を持ちます。",
      nodes: [
        { title: "BOOK", text: "book_uid / title", tone: "is-source" },
        { title: "BOOK_AUTHOR", text: "book_uid (FK) / author_uid (FK)", tone: "is-busy" },
        { title: "AUTHOR", text: "author_uid / first_name / last_name", tone: "is-good" },
      ],
      note: "多対多は、中間テーブルを挟む設計に言い換えられるかが重要です。",
    });
  }

  function renderExternalTablePipelineDiagram() {
    return renderTimelineGraphic({
      kicker: "External Table Stack",
      title: "Parquet 参照から高速クエリ応答までの積み上げ",
      copy: "外部ファイルをそのまま参照しつつ、更新検知や結果キャッシュを重ねます。",
      steps: [
        { title: "Stage", text: "Parquet ファイルを置く / 参照する" },
        { title: "External Table", text: "AUTO_REFRESH で変更検知" },
        { title: "SMV", text: "セキュアマテリアライズドビューで結果をキャッシュ" },
        { title: "User Query", text: "高速に問い合わせへ応答" },
      ],
    });
  }

  /* ── Connector Tree ──────────────────────────────────── */
  function parseConnectorTree(raw) {
    const nodes = [];
    const lines = raw.split("\n");
    for (const line of lines) {
      if (!line.trim() || /^\s*│\s*$/.test(line)) continue;
      const hasConnector = /[├└]──/.test(line);
      if (!hasConnector) {
        // depth-0 root line (no ├/└ prefix)
        const content = line.trim();
        if (!content) continue;
        const ai = content.indexOf("←");
        const label = ai !== -1 ? content.slice(0, ai).trim() : content;
        const annotation = ai !== -1 ? content.slice(ai + 1).trim() : "";
        nodes.push({ depth: 0, isLast: true, label, annotation });
        continue;
      }
      // Count leading │ characters (each represents one depth level)
      const prefix = line.match(/^([\s│]*)/)?.[1] ?? "";
      const pipeCount = (prefix.match(/│/g) || []).length;
      const depth = pipeCount + 1;
      const isLast = /└──/.test(line.replace(/^[\s│]*/, ""));
      let content = line.replace(/^[\s│]*[├└]──\s*/, "").trim();
      if (!content) continue;
      const ai = content.indexOf("←");
      const label = ai !== -1 ? content.slice(0, ai).trim() : content;
      const annotation = ai !== -1 ? content.slice(ai + 1).trim() : "";
      nodes.push({ depth, isLast, label, annotation });
    }
    return nodes;
  }

  function renderConnectorTree(raw) {
    const nodes = parseConnectorTree(raw);
    if (!nodes.length) return null;

    // For item i and column c: is there a depth-c node after i with no depth<c in between?
    function hasActiveLine(i, c) {
      for (let j = i + 1; j < nodes.length; j++) {
        if (nodes[j].depth < c) return false;
        if (nodes[j].depth === c) return true;
      }
      return false;
    }

    const wrapper = document.createElement("div");
    wrapper.className = "diagram-ctree";

    nodes.forEach((node, i) => {
      const item = document.createElement("div");
      item.className = "ctree-item";
      if (node.depth === 0) item.classList.add("ctree-root");

      const connArea = document.createElement("div");
      connArea.className = "ctree-connectors";

      if (node.depth === 0) {
        const marker = document.createElement("span");
        marker.className = "ctree-root-marker";
        connArea.appendChild(marker);
      } else {
        // Ancestor columns (depth 1 … depth-1)
        for (let col = 1; col < node.depth; col++) {
          const span = document.createElement("span");
          span.className = "ctree-col";
          if (hasActiveLine(i, col)) span.classList.add("active");
          connArea.appendChild(span);
        }
        // Own connector column (├── or └──)
        const own = document.createElement("span");
        own.className = `ctree-col connector${node.isLast ? "" : " has-sibling"}`;
        connArea.appendChild(own);
      }

      item.appendChild(connArea);

      const labelEl = document.createElement("span");
      labelEl.className = "ctree-label";
      labelEl.textContent = node.label;
      item.appendChild(labelEl);

      if (node.annotation) {
        const badge = document.createElement("span");
        badge.className = "ctree-badge";
        badge.textContent = node.annotation;
        item.appendChild(badge);
      }

      wrapper.appendChild(item);
    });

    return wrapper;
  }

  /* ── Mermaid helpers ─────────────────────────────────── */
  function makeMermaidBlock(code) {
    const wrapper = document.createElement("div");
    wrapper.className = "diagram-mermaid";
    const inner = document.createElement("div");
    inner.className = "mermaid";
    inner.textContent = code;
    wrapper.appendChild(inner);
    return wrapper;
  }

  // 03: PUT → ステージ → テーブル パイプライン
  function mermaidLoadPipeline() {
    return makeMermaidBlock(`flowchart LR
    A["🗂 ローカルファイル\n(CSV, JSON, Parquet...)"]
    B["📦 ステージ\n(一時置き場)"]
    C["🗄 Snowflakeテーブル"]
    A -->|"PUT コマンド\n(内部ステージへ転送)"| B
    B -->|"COPY INTO コマンド\n(テーブルへロード)"| C
    style A fill:#0f1b34,stroke:#5bb8ff,color:#d9ebff
    style B fill:#1a2e50,stroke:#3a9fff,color:#d9ebff,stroke-width:2px
    style C fill:#0f2a1a,stroke:#00cc7a,color:#d9ebff`);
  }

  // 03: データロード方法の選択フローチャート
  function mermaidLoadDecision() {
    return makeMermaidBlock(`flowchart TD
    S([データロード方法の選択])
    S --> Q1{データ量は多い？}
    Q1 -->|No| R1["INSERT\nまたは Web UI"]
    Q1 -->|Yes| Q2{継続的に更新される？}
    Q2 -->|No| R2["COPY INTO\nバッチ処理"]
    Q2 -->|Yes| R3["Snowpipe\n自動ロード"]
    style S fill:#162440,stroke:#5bb8ff,color:#8fd3ff
    style Q1 fill:#1d3255,stroke:#3a9fff,color:#d9ebff
    style Q2 fill:#1d3255,stroke:#3a9fff,color:#d9ebff
    style R1 fill:#0f2a1a,stroke:#00cc7a,color:#afffda
    style R2 fill:#0f1b34,stroke:#5bb8ff,color:#bde4ff
    style R3 fill:#2a1a40,stroke:#a78bfa,color:#ddd6fe`);
  }

  // 03: Snowpipe 自動ロードフロー
  function mermaidSnowpipeFlow() {
    return makeMermaidBlock(`flowchart LR
    A["🌐 外部システム"]
    B["☁ S3 / Azure Blob"]
    C["⚙ Snowpipe\n(自動検知)"]
    D["🗄 Snowflakeテーブル"]
    A -->|"ファイルアップロード"| B
    B -->|"イベント通知"| C
    C -->|"自動 COPY INTO"| D
    style A fill:#0f1b34,stroke:#5bb8ff,color:#d9ebff
    style B fill:#1d3255,stroke:#3a9fff,color:#d9ebff
    style C fill:#2a1a40,stroke:#a78bfa,color:#ddd6fe,stroke-width:2px
    style D fill:#0f2a1a,stroke:#00cc7a,color:#afffda`);
  }

  // 03: テーブル種類の選択フローチャート
  function mermaidTableTypeDecision() {
    return makeMermaidBlock(`flowchart TD
    S([テーブル種類の選択])
    S --> Q1{"本番データとして\n永続化が必要？"}
    Q1 -->|Yes| R1["Permanent\n（デフォルト）\nTime Travel: 0-90日\nFail-safe: 7日"]
    Q1 -->|No| Q2{"セッション内だけの\n一時データ？"}
    Q2 -->|Yes| R2["Temporary\nセッション終了で自動削除\nFail-safe なし"]
    Q2 -->|No| R3["Transient\n中間処理・ETLステージング\nFail-safe なし"]
    style S fill:#162440,stroke:#5bb8ff,color:#8fd3ff
    style Q1 fill:#1d3255,stroke:#3a9fff,color:#d9ebff
    style Q2 fill:#1d3255,stroke:#3a9fff,color:#d9ebff
    style R1 fill:#0f2a1a,stroke:#00cc7a,color:#afffda
    style R2 fill:#2a1a10,stroke:#ffb340,color:#ffe8b0
    style R3 fill:#0f1b34,stroke:#5bb8ff,color:#bde4ff`);
  }

  // 04: 暗号化キー階層
  function mermaidKeyHierarchy() {
    return makeMermaidBlock(`flowchart TD
    A["🔑 Root Key\n（ルートキー）\nSnowflakeが管理"]
    B["🔐 Account Master Key\n（アカウントマスターキー）\nアカウント全体を保護"]
    C["🗝 Table Master Key\n（テーブルマスターキー）\n各テーブルを保護"]
    D["🔒 File Key\n（ファイルキー）\n各マイクロパーティションを保護"]
    A --> B
    B --> C
    C --> D
    style A fill:#2a1a10,stroke:#ffb340,color:#ffe8b0
    style B fill:#1d3255,stroke:#3a9fff,color:#d9ebff
    style C fill:#162440,stroke:#5bb8ff,color:#bde4ff
    style D fill:#0f1b34,stroke:#5bb8ff,color:#bde4ff`);
  }

  // 04: Network Policy フロー
  function mermaidNetworkPolicy() {
    return makeMermaidBlock(`flowchart TD
    A["🌐 インターネット\n（外部からのアクセス）"]
    B{"Network Policy\nIPアドレスをチェック"}
    C["✅ Snowflake\n（処理を実行）"]
    D["❌ ブロック\n（アクセス拒否）"]
    A --> B
    B -->|"許可リスト\n（社内IP等）"| C
    B -->|"許可されていないIP"| D
    style A fill:#0f1b34,stroke:#5bb8ff,color:#d9ebff
    style B fill:#1d3255,stroke:#ffb340,color:#ffe8b0,stroke-width:2px
    style C fill:#0f2a1a,stroke:#00cc7a,color:#afffda
    style D fill:#2a0f0f,stroke:#ff5f70,color:#ffb0b6`);
  }

  // 04: アカウント→ユーザー→セッションの継承
  function mermaidPolicyInheritance() {
    return makeMermaidBlock(`flowchart TD
    A["🏢 Account（アカウント）\n全ユーザーに影響"]
    B["👤 User（ユーザー）\n特定ユーザーに影響"]
    C["💻 Session（セッション）\n現在の接続のみに影響"]
    A -->|"継承"| B
    B -->|"継承"| C
    style A fill:#2a1a40,stroke:#a78bfa,color:#ddd6fe,stroke-width:2px
    style B fill:#162440,stroke:#5bb8ff,color:#d9ebff
    style C fill:#0f1b34,stroke:#3a9fff,color:#bde4ff`);
  }

  function renderDiagramRows(raw) {
    // ── Mermaid優先チェック ──────────────────────────────
    if (window.mermaid) {
      if (isLoadDecisionDiagram(raw))       return mermaidLoadDecision();
      if (isTableTypeDecisionDiagram(raw))  return mermaidTableTypeDecision();
      if (isKeyHierarchyDiagram(raw))       return mermaidKeyHierarchy();
      if (isNetworkPolicyDiagram(raw))      return mermaidNetworkPolicy();
      if (isPolicyInheritanceDiagram(raw))  return mermaidPolicyInheritance();
      if (isSnowpipeFlowDiagram(raw))       return mermaidSnowpipeFlow();
      // PUT→ステージ→COPY INTO パイプライン（3ステップ）
      if (raw.includes("ローカルファイル") && raw.includes("PUT") && raw.includes("COPY INTO")) {
        return mermaidLoadPipeline();
      }
    }

    if (isCertificationPathDiagram(raw)) {
      return renderCertificationPathDiagram();
    }
    if (isThreeLayerArchitectureDiagram(raw)) {
      return renderThreeLayerArchitectureDiagram();
    }
    if (isWarehouseNodesDiagram(raw)) {
      return renderWarehouseNodesDiagram();
    }
    if (isCacheArchitectureDiagram(raw)) {
      return renderCacheArchitectureDiagram();
    }
    if (isPartitionPruningDiagram(raw)) {
      return renderPartitionPruningDiagram();
    }
    if (isClusteringComparisonDiagram(raw)) {
      return renderClusteringComparisonDiagram();
    }
    if (isObjectHierarchyDiagram(raw)) {
      return renderObjectHierarchyDiagram();
    }
    if (isMultiClusterDiagram(raw)) {
      return renderMultiClusterDiagram();
    }
    if (isNotebookCellsDiagram(raw)) {
      return renderNotebookCellsDiagram();
    }
    if (isWorksheetDashboardDiagram(raw)) {
      return renderWorksheetDashboardDiagram();
    }
    if (isQueryProfileDiagram(raw)) {
      return renderQueryProfileDiagram();
    }
    if (isLoadPipelineDiagram(raw)) {
      return renderLoadPipelineDiagram();
    }
    if (isLoadDecisionDiagram(raw)) {
      return renderLoadDecisionDiagram();
    }
    if (isStageTypesDiagram(raw)) {
      return renderStageTypesDiagram();
    }
    if (isSnowpipeFlowDiagram(raw)) {
      return renderSnowpipeFlowDiagram();
    }
    if (isTableTypeDecisionDiagram(raw)) {
      return renderTableTypeDecisionDiagram();
    }
    if (isPipeTransformDiagram(raw)) {
      return renderPipeTransformDiagram();
    }
    if (isStreamTaskComparisonDiagram(raw)) {
      return renderStreamTaskComparisonDiagram();
    }
    if (isNetworkPolicyDiagram(raw)) {
      return renderNetworkPolicyDiagram();
    }
    if (isEncryptionDiagram(raw)) {
      return renderEncryptionDiagram();
    }
    if (isKeyHierarchyDiagram(raw)) {
      return renderKeyHierarchyDiagram();
    }
    if (isResourceMonitorDiagram(raw)) {
      return renderResourceMonitorDiagram();
    }
    if (isPolicyInheritanceDiagram(raw)) {
      return renderPolicyInheritanceDiagram();
    }
    if (isAuthenticationFlowDiagram(raw)) {
      return renderAuthenticationFlowDiagram();
    }
    if (isPrincipalRoleObjectDiagram(raw)) {
      return renderPrincipalRoleObjectDiagram();
    }
    if (isSystemRoleHierarchyDiagram(raw)) {
      return renderSystemRoleHierarchyDiagram();
    }
    if (isOwnershipRoleDiagram(raw)) {
      return renderOwnershipRoleDiagram();
    }
    if (isMaskingPolicyDiagram(raw)) {
      return renderMaskingPolicyDiagram();
    }
    if (isCortexArchitectureDiagram(raw)) {
      return renderCortexArchitectureDiagram();
    }
    if (isEmbeddingSimilarityDiagram(raw)) {
      return renderEmbeddingSimilarityDiagram();
    }
    if (isTraditionalVsCortexDiagram(raw)) {
      return renderTraditionalVsCortexDiagram();
    }
    if (isTimeTravelTimelineDiagram(raw)) {
      return renderTimeTravelTimelineDiagram();
    }
    if (isTimeTravelVsFailSafeDiagram(raw)) {
      return renderTimeTravelVsFailSafeDiagram();
    }
    if (isZeroCopyCloneDiagram(raw)) {
      return renderZeroCopyCloneDiagram();
    }
    if (isSharingDiagram(raw)) {
      return renderSharingDiagram();
    }
    if (isDataTypeCatalogDiagram(raw)) {
      return renderDataTypeCatalogDiagram();
    }
    if (isRankingDiagram(raw)) {
      return renderRankingDiagram();
    }
    if (isOneToManyDiagram(raw)) {
      return renderOneToManyDiagram();
    }
    if (isManyToManyDiagram(raw)) {
      return renderManyToManyDiagram();
    }
    if (isExternalTablePipelineDiagram(raw)) {
      return renderExternalTablePipelineDiagram();
    }


    const wrapper = document.createElement("div");
    wrapper.className = "diagram-graphic";
    const lines = raw.split("\n").map((line) => line.replace(/\s+$/, "")).filter((line) => line.trim());

    if (lines.some((line) => /[├└]──/.test(line))) {
      return renderConnectorTree(raw) || wrapper;
    }

    if (isFlowLike(raw)) {
      wrapper.classList.add("is-flow");
      lines.forEach((line) => {
        const row = document.createElement("div");
        row.className = "diagram-flow-row";
        const cells = line
          .split(/(?:──▶|──>|→|←|▶|↓)/)
          .map((part) => normalizeDiagramText(part))
          .filter(Boolean);

        if (cells.length <= 1 && /│/.test(line)) {
          normalizeDiagramText(line)
            .split(/\s{2,}/)
            .filter(Boolean)
            .forEach((part) => {
              const card = document.createElement("div");
              card.className = "diagram-card";
              card.textContent = part;
              row.appendChild(card);
            });
        } else {
          cells.forEach((cell, index) => {
            const card = document.createElement("div");
            card.className = "diagram-card";
            card.textContent = cell;
            row.appendChild(card);
            if (index < cells.length - 1) {
              const arrow = document.createElement("span");
              arrow.className = "diagram-arrow";
              arrow.textContent = /←/.test(line) ? "←" : /↓/.test(line) ? "↓" : "→";
              row.appendChild(arrow);
            }
          });
        }

        if (!row.childNodes.length) {
          const fallback = document.createElement("div");
          fallback.className = "diagram-card is-wide";
          fallback.textContent = normalizeDiagramText(line);
          row.appendChild(fallback);
        }

        wrapper.appendChild(row);
      });
      return wrapper;
    }

    wrapper.classList.add("is-stack");
    lines.forEach((line) => {
      const row = document.createElement("div");
      row.className = "diagram-stack-row";
      const card = document.createElement("div");
      card.className = "diagram-card is-wide";
      card.textContent = normalizeDiagramText(line);
      row.appendChild(card);
      wrapper.appendChild(row);
    });
    return wrapper;
  }

  function renderDiagramBlocks() {
    els.articleContent.querySelectorAll(".diagram-raw").forEach((node) => {
      const raw = decodeDiagramPayload(node.dataset.diagram || "");
      const graphic = renderDiagramRows(raw);
      node.replaceWith(graphic);
    });
    if (window.mermaid) {
      const mermaidNodes = els.articleContent.querySelectorAll(".mermaid:not([data-processed='true'])");
      if (mermaidNodes.length > 0) {
        setTimeout(() => mermaid.run({ nodes: mermaidNodes }).catch(() => {}), 0);
      }
    }
  }

  /* ── blockquote classification ───────────────────────── */
  function classifyBlockquotes() {
    els.articleContent.querySelectorAll("blockquote").forEach((bq, idx) => {
      const text = bq.textContent || "";
      const firstStrong = bq.querySelector("strong");
      const strongText = firstStrong ? firstStrong.textContent.trim() : "";

      // ファイルヘッダー（最初のblockquoteかつSOL-C01/比率/最終更新を含む）
      if (idx === 0 && (text.includes("SOL-C01") || text.includes("出題比率") || text.includes("最終更新"))) {
        bq.classList.add("bq-meta");
        return;
      }
      // 試験ポイント
      if (/試験/.test(strongText) || /試験/.test(text.slice(0, 30))) {
        bq.classList.add("bq-exam");
        return;
      }
      // 重要
      if (/重要/.test(strongText)) {
        bq.classList.add("bq-important");
        return;
      }
      // 注意 / Warning
      if (/注意|Warning/.test(strongText)) {
        bq.classList.add("bq-warning");
        return;
      }
      // ポイント / Tip
      if (/ポイント|Tip/.test(strongText)) {
        bq.classList.add("bq-tip");
        return;
      }
      // Note / ノート
      if (/^Note$|^ノート$/.test(strongText)) {
        bq.classList.add("bq-note");
        return;
      }
      // 「〜とは？」「なぜ〜」「〜について」形式の説明ブロック
      if (/とは[？?]|なぜ|について$/.test(text.slice(0, 40)) || strongText.endsWith("とは")) {
        bq.classList.add("bq-explain");
        return;
      }
      // 検証SQL / 🔗
      if (text.includes("🔗") || text.includes("検証SQL") || text.includes("verification/")) {
        bq.classList.add("bq-link");
        return;
      }
      // デフォルト
      bq.classList.add("bq-info");
    });
  }

  /* ── render: article ─────────────────────────────────── */
  function renderArticle(article) {
    const currentIndex = bank.articles.findIndex((a) => a.slug === article.slug);
    els.currentArticleTitle.textContent = article.title;
    els.currentArticleMeta.textContent  = getArticleMetadata(article).join(" / ");
    els.articlePosition.textContent     = `${currentIndex + 1} / ${bank.articleCount}`;
    els.articleHeading.textContent      = article.title;
    els.articleContent.innerHTML        = article.html;
    renderDiagramBlocks();
    classifyBlockquotes();
    els.userNote.value                  = getArticleProgress(article.slug).note || "";
    renderMeta(article);
    renderStatus(article);
    bindInlineArticleLinks();
    setupScrollSpy(article);
    setTimeout(renderSectionFocus, 0);
  }

  /* ── navigation ──────────────────────────────────────── */
  function moveArticle(step) {
    const visible = getVisibleArticles();
    const currentIndex = visible.findIndex((a) => a.slug === state.currentArticleSlug);
    const next = visible[currentIndex + step];
    if (!next) return;
    state.currentArticleSlug = next.slug;
    state.currentSectionId = next.sections[0]?.id || "";
    render();
  }

  /* ── toggle actions ──────────────────────────────────── */
  function toggleCompleted() {
    const article = getCurrentArticle();
    const progress = getArticleProgress(article.slug);
    state.progress[article.slug] = { ...progress, completed: !progress.completed, note: els.userNote.value };
    saveProgress();
    render();
  }

  function toggleBookmarked() {
    const article = getCurrentArticle();
    const progress = getArticleProgress(article.slug);
    state.progress[article.slug] = { ...progress, bookmarked: !progress.bookmarked, note: els.userNote.value };
    saveProgress();
    render();
  }

  function resetProgress() {
    if (!confirm("まとめアプリの進捗とメモをすべてリセットしますか？")) return;
    state.progress = {};
    saveProgress();
    render();
  }

  /* ── event binding ───────────────────────────────────── */
  function bindEvents() {
    els.sidebarToggle.addEventListener("click", () => {
      els.appShell.classList.toggle("sidebar-collapsed");
    });

    els.searchInput.addEventListener("input", (e) => {
      state.search = e.target.value;
      ensureCurrentArticle();
      render();
    });

    els.userNote.addEventListener("input", persistCurrentNote);
    els.toggleCompleteButton.addEventListener("click", toggleCompleted);
    els.toggleBookmarkButton.addEventListener("click", toggleBookmarked);
    els.prevArticleButton.addEventListener("click", () => moveArticle(-1));
    els.nextArticleButton.addEventListener("click", () => moveArticle(1));
    els.resetProgressButton.addEventListener("click", resetProgress);

    window.addEventListener("keydown", (event) => {
      if (event.target && ["INPUT", "TEXTAREA"].includes(event.target.tagName)) return;
      if (event.key === "ArrowRight")        moveArticle(1);
      else if (event.key === "ArrowLeft")    moveArticle(-1);
      else if (event.key.toLowerCase() === "c") toggleCompleted();
      else if (event.key.toLowerCase() === "b") toggleBookmarked();
    });
  }

  /* ── main render ─────────────────────────────────────── */
  function render() {
    ensureCurrentArticle();
    const article = getCurrentArticle();
    renderArticleList();
    renderSectionList(article);
    renderArticle(article);
    updateStats();
    updateProgressBar();
  }

  bindEvents();
  render();
})();
