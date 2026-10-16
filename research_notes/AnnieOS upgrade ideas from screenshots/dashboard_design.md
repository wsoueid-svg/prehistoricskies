# Dashboard Design Best Practices Applied to the AnnieOS Owner Dashboard (as of 2026-10-16)

Method note: WebFetch could not resolve any host (DNS failure) in this session, so everything below comes from WebSearch result summaries only. No primary page (NN/g, Perceptual Edge, W3C, Apple HIG, Material) was read in full. Where a claim is attributed to an authority but the source is secondary, that is stated. The uiux.build Instagram post itself was not found; the seven rules are taken from the assignment text.

## 1. Do the 7 rules hold up against authoritative literature, and what does the post miss?

### Takeaway
The seven rules are mainstream and consistent with Few, Tufte, Grafana and general UX guidance (key metrics first, group, limit visuals, trends, restrained interaction). They are a visual-layout checklist and miss accessibility, data trust (freshness, empty/error states), honest scaling, and explainability. One tension: Few says a dashboard fits one screen with no scrolling or paging, while rule 6 ("filters and drill-down") can push people toward interaction-heavy designs; for non-technical owners keep filters minimal.

### Cited Findings
- The uiux.build post was not findable via search; I could not verify its wording beyond the assignment text. — [search results](https://www.clearpeaks.com/how-to-design-better-dashboards-ui-ux-tips-best-practices/) (closest generic equivalents only)
- Rule 1 (key metrics first): secondary guides recommend 3-7 headline metrics per main view with drill-down for the rest, and putting the most important items top-left where attention lands first. — [AuFaitUX](https://www.aufaitux.com/blog/good-dashboard-design/); [UX Magazine, four cognitive design guidelines](https://uxmag.com/articles/four-cognitive-design-guidelines-for-effective-information-dashboards)
- Cognitive load framing: one secondary article attributes to NN/g a definition of cognitive load as the intimidation users feel facing a lot of data at once (not verified at nngroup.com). — [insightsoftware](https://insightsoftware.com/blog/a-ux-roadmap-for-effective-dashboard-design-guest-post/)
- Recognition over recall: a dashboard should show what the user needs on screen instead of making them hold it in memory. — [UX Magazine](https://uxmag.com/articles/four-cognitive-design-guidelines-for-effective-information-dashboards)
- Stephen Few's "13 common mistakes" (from Information Dashboard Design and a ProClarity white paper) begin with exceeding a single screen (no scrolling or switching), and include inadequate context, excessive detail or precision, poor arrangement, and misuse/overuse of colour. Secondary summaries only; full list not read. — [UXmatters book review](https://uxmatters.com/mt/archives/2007/04/book-review-information-dashboard-design.php); [Data School summary](https://www.thedataschool.co.uk/anh-vu/are-you-making-these-13-dashboard-design-mistakes/)
- Rules 3-4 (consistency, avoid chart overload) match Tufte: maximise data-ink ratio, delete non-data ink, avoid chartjunk (heavy grids, fake 3D, unnecessary colour). — [IEEE Spectrum, Tufteisms](https://spectrum.ieee.org/tufteisms); [summary of Tufte lessons](https://www.antoinebuteau.com/lessons-from-edward-tufte/)
- Rule 5 (trends): Tufte's sparklines ("small, intense, simple, word-sized graphics") and small multiples are the compact way to show trend next to a KPI. The 1.05/0.95 "lie factor" threshold appears only on a secondary site; verify before citing. — [Tufte summary](https://www.antoinebuteau.com/lessons-from-edward-tufte/)
- Grafana: ask whether a viewer can tell what each graph shows without thinking; use thresholds for colour meaning; normalise axes (percent not raw); order rows by data flow; USE method (utilization, saturation, errors) for hardware, RED (rate, errors, duration) for services; alert on RED symptoms. Directly relevant to the model/GPU health panel. — [Grafana best practices](https://grafana.com/docs/grafana/latest/best-practices/); [Grafana v7.2 best practices](https://grafana.com/docs/grafana/v7.2/best-practices/best-practices-for-creating-dashboards)
- Missed by the post: colour must not be the sole carrier of meaning; use patterns, textures or labels; also give a text summary and a data table alternative for charts. — [Material blog, data viz accessibility](https://m2.material.io/blog/data-visualization-accessibility); [Smashing Magazine, accessibility-first charts](https://smashingmagazine.com/2022/07/accessibility-first-approach-chart-visual-design/); [Highcharts blog](https://www.highcharts.com/blog/?p=20675)
- Material's data-viz guidance was written by the Google Cloud dataviz team, who later said it was "not as inclusive as we had hoped" (so treat the original Material chart palettes with caution). — [Smashing Magazine](https://smashingmagazine.com/2022/07/accessibility-first-approach-chart-visual-design/)
- WCAG 2.2: 2.5.8 Target Size (Minimum, AA) requires 24x24 CSS px targets (exceptions: 24px spacing offset, inline links, essential presentation); 1.4.11 Non-text Contrast (AA) requires 3:1 for graphical objects and UI components needed to understand content; 4.5:1 for normal text. Platform touch-target guidance is larger (44pt iOS, 48dp Android), per a Visa design page (secondary). — [DAISY KB on 2.5.8](https://kb.daisy.org/publishing/docs/wcag/target-size-minimum.html); [Visa accessibility requirements](https://design.visa.com/global-accessibility-requirements/mobile/visual/)
- Apple: the Audio Graphs API lets VoiceOver users hear a chart (time on x, pitch on y) with a computed summary of trend and outliers; testing requires a physical device. HIG chart page itself not retrieved. — [Apple Audio Graphs docs](https://developer.apple.com/documentation/accessibility/audio-graphs.md); [WWDC21 10122](https://developer.apple.com/wwdc21/10122)
- Data freshness: a guide recommends ensuring data is fresh and flagging limitations or anomalies; stale data is a common cause of poor decisions. — [search summary of dashboard guides](https://www.aufaitux.com/blog/dashboard-design-principles-for-user-engagement/)

### Inferences
- Add rules 8-12 to the post's seven: (8) accessible colour (colour-blind-safe palette plus icon/label/pattern redundancy, 3:1 non-text contrast, 4.5:1 text, 24px minimum targets but design for 44-48px on phone); (9) honest charts (zero-based bars, no dual axes, no 3D); (10) every number carries "as of" time and source; (11) designed empty, loading, partial-failure and error states (a connector disconnected must show as "WhatsApp not connected since 09:12", not as zero messages); (12) every number is explainable (click to see the underlying items).
- For AnnieOS, resolve the single-screen vs. filters tension by one "Today" screen with 4-5 KPI cards and no filters, and a separate "Activity" view that has search and a simple date/connector filter.
- Also note this is a controlled audience (non-technical owners): Few's "at a glance" outweighs rich drill-down; hide anything an owner cannot act on (token counts, GPU memory) behind an "Advanced/Health" tab.

### Gaps
- No primary NN/g dashboard article, Perceptual Edge text, Apple HIG chart page, Material charts page, Tableau or Power BI design docs were read (fetch failed; searches returned only secondary summaries).
- The uiux.build post could not be located.
- WCAG 1.4.1 (Use of Color) wording was not retrieved; it is well known but unsourced here.

## 2. What should an AI-assistant dashboard show that a BI dashboard does not?

### Takeaway
Trust, not analysis, is the job: show an action trail (what Annie did), an approval queue with reversibility cues, evidence/confidence on each item, undo, and per-connector permissions, plus a small system-health panel. Sources agree that approval gates should be risk-based to avoid approval fatigue.

### Cited Findings
- Reversibility is the "fundamental safety net": design undo before the action; tag each proposed action by reversibility (draft = fully reversible; sent email or charged card = irreversible) so approval effort matches risk. — [AI UX Playground, Reversibility Marking](https://www.aiuxplayground.com/pattern/reversibility-marking); [Agentic UX framework](https://www.aiuxplayground.com/frameworks/agentic)
- Action trail: a chronological, human-readable log of what the agent did, with inputs, outputs and side effects per step; visible undo plus this record is described as close to a universal trust mechanism. — [AI UX Playground, agent patterns](https://aiuxplayground.com/patterns/agents); [Towards AI, 8 UX patterns that build trust](https://pub.towardsai.net/designing-for-ai-agents-8-ux-patterns-that-build-trust-in-2026-713a0c926933)
- Trust patterns: citations/source browser, explicit uncertainty, scores, human handoff, cost transparency, auditability. Pre-action visibility: show intent, scope, tools and data touched, how to stop or undo; dry-run preview. — [AI UX Playground, trust patterns](https://www.aiuxplayground.com/patterns/trust)
- Approval design: irreversible operations nearly always need approval, read-only rarely; reduce unnecessary approvals, explain why an item was escalated, and show evidence to avoid rubber-stamping. — [vp0 approval swipe UI](https://vp0.com/blogs/human-in-the-loop-approval-swipe-ui); [The Skins Factory on approval fatigue](https://www.theskinsfactory.com/uiux-design-questions-answers/how-do-you-design-human-in-the-loop-ai-without-creating-approval-fatigue)
- Research (arXiv preprint, business context): raising agent transparency from low to high raised preference by about 38 percentage points; a low-confidence warning added about 22 points; the ability to pause added about 5. Preprint, not peer-reviewed as far as verified. — [arXiv 2606.18716](https://arxiv.org/pdf/2606.18716)
- Zapier Agents/Human in the Loop: approve, decline or edit before the workflow continues; requests arrive via email or Slack with a link to the step; approvals are recorded in the account audit log with actor and timestamp. — [Zapier help: approval steps](https://help.zapier.com/hc/en-us/articles/41776074420493); [Zapier audit log](https://help.zapier.com/hc/en-us/articles/13295074298125); [Zapier HITL guide](https://zapier.com/blog/human-in-the-loop-guide/)
- Lindy: docs describe manual approval steps and recommend starting with heavy oversight and loosening as confidence grows. UI details not found. — [Lindy docs](https://docs.lindy.ai/testing/human-in-the-loop.md)
- n8n executions view: list with timestamp, status and duration; opening one replays the run with each node's input/output. Good model for an "Open the log" detail drawer. — [n8n execution history guide (third party)](https://seo.rapidevelopers.com/n8n-tutorial/how-to-view-execution-history-in-n8n)
- Langfuse: trace = tree of observations per interaction, each with prompt, response, tokens, latency, model; self-hostable (free); Helicone is reported in maintenance mode after acquisition by Mintlify per Langfuse's docs (vendor-adjacent claim). — [Langfuse/Helicone integration page](https://langfuse.com/integrations/gateways/helicone.md); [comparison](https://www.premai.io/blog/llm-observability-setting-up-langfuse-langsmith-helicone-phoenix/)
- Home Assistant: hierarchy of dashboards > views > cards where a card represents the state of an entity and allows interaction; a model for per-connector status cards. — [Luis Llamas HA guide](https://www.luisllamas.es/en/creating-dashboards-home-assistant-lovelace/)

### Inferences
- Recommended AnnieOS panels, in priority order: (1) "Needs your OK" approval queue (top; each card: what, to whom, why Annie suggests it, source snippet, reversibility badge, Approve/Edit/Reject); (2) "What Annie did today" feed (human sentences, with undo where possible and a link to the raw trace); (3) 4-5 value KPIs; (4) connector cards with status, last sync time and permission toggles (read / draft / send); (5) "What Annie learned" (new preferences/facts, each editable or deletable); (6) Advanced: model used, latency, GPU/RAM using USE/RED-style panels, hidden by default.
- Risk-tier the approvals: auto-run read-only and drafts; ask for sending external email/WhatsApp, payments, deleting; allow "always allow this kind" after N approvals (matches Lindy advice to loosen over time).
- Do not embed Langfuse for the owner; use it (or a SQLite trace table) behind the scenes and surface only owner-language summaries.

### Gaps
- No direct examination of Claude/ChatGPT agent UIs, Notion AI, Rewind, or Open WebUI admin screens (search returned nothing usable); only Zapier, Lindy docs, n8n and pattern libraries were covered.
- Pattern-library sources are practitioner/vendor content rather than empirical research; only one preprint offers quantitative evidence.

## 3. ROI/value metrics small-business owners respond to, and honest measurement

### Takeaway
Owners respond to hours saved and money/revenue effects, but survey figures are self-reported and often vendor-run. Measure with per-task baselines, count only completed and accepted work, show ranges, and distinguish "time saved" from "value captured".

### Cited Findings
- Adobe survey of 431 small-business owners: top tasks were social content (~175 h/yr saved) and summarising reports (~152 h/yr); dollar values derived from average owner income; 47% reported a revenue boost (avg 21%); Adobe notes self-report bias. — [Adobe study](https://www.adobe.com/acrobat/resources/small-business-superpower-study.html); [PPC Land summary](https://ppc.land/adobe-study-smbs-using-ai-content-tools-save-6k-and-gain-revenue/)
- Bluehost: 21% reclaim 8+ hours a week; firms saving 16+ h/week are 3.7x more likely to report revenue increases (correlation only). — [Bluehost](https://www.bluehost.com/state-of-small-business-ai-confidence/the-roi-picture)
- Local Impact: 96% estimate at least 1 h/week saved; 37% say 3-5 h/week. — [Local Impact](https://localimpact.com/blog/state-of-small-business-ai-adoption)
- Chain Store Age: 92% of AI users say it saves time; 70% say they need more training. — [Chain Store Age](https://chainstoreage.com/survey-small-businesses-cite-cost-and-time-savings-top-ai-benefits)
- Practitioner poll (~60 owners, informal): about two-thirds felt time was freed but fewer than a third could say what they did with it. — [Bushe](https://bushe.co/answers/how-much-time-does-ai-save-the-average-small-business-owner/)
- Standard advice: time a task for a week before automation to set a baseline. — [Martech Zone](https://martech.zone/how-small-businesses-are-turning-ai-into-real-roi/)

### Inferences
- Candidate KPI cards (Spanish labels first): "Horas ahorradas esta semana" (sum over accepted tasks of baseline minutes x count, shown with an "estimado" tag and editable assumptions); "Correos redactados / enviados sin cambios" (edit-distance acceptance rate is an honest quality signal); "Facturas procesadas"; "Tiempo medio de respuesta" (before/after Annie, from message timestamps); "Cobros pendientes recuperados" (EUR, only when an invoice marked paid follows an Annie reminder); "Ahorro vs. suscripciones" (user-entered SaaS prices replaced; label as owner-entered).
- Honest measurement rules: count only outputs the owner accepted or that were sent; subtract time the owner spent editing; use conservative per-task baselines the owner can change; show last 7/30 days with prior-period comparison; never invent revenue attribution (use "followed by", not "caused by"); log every metric's formula in the explain drawer.
- Add a weekly "time reinvested" nudge? (prompt owner to note what they did with saved hours), motivated by the practitioner poll; unvalidated idea.

### Gaps
- No Spain/EU-specific small-business ROI survey found; all surveys are US/vendor and self-reported.
- No source validating per-task baseline minutes (e.g. minutes per email draft); those need a pilot with real owners.

## 4. Practical tech choices

### Takeaway
shadcn/ui + Recharts (via shadcn chart) or Tremor on Next.js (or Vite) gives the fastest owner-facing UI; use Grafana only for the admin/health view. PWA over Tailscale Serve HTTPS is viable for install; web push over that setup is unconfirmed and must be tested.

### Cited Findings
- shadcn chart component wraps Recharts; theme applied through CSS variables (--color-*); config supplies labels/colours; needs a client component in Next.js because Recharts uses browser APIs. — [shadcn charts docs](https://ui-v4.shadcn.com/docs/components/chart); [shadcn dashboard tutorial](https://designrevision.com/blog/shadcn-dashboard-tutorial.md)
- Tremor is a copy-paste analytics component library; Tremor Blocks reported free and open source; roundup suggests Tremor for KPI dashboards, shadcn charts if already on shadcn. — [shadcn.io chart page / roundup](https://www.shadcn.io/ui/chart)
- Tailscale Serve (`tailscale serve --bg localhost:PORT`) proxies HTTPS from the tailnet to a local port without opening ports to the internet; HTTPS is what makes PWA install work; iOS uses Safari "Add to Home Screen"; may require an admin to enable HTTPS certificates first. — [Open WebUI Tailscale docs](https://docs.openwebui.com/ecosystem/computer/phone-and-remote/tailscale); [Happier guide](https://guides.happier.dev/how-to-access-happier-from-your-phone-over-tailscale)
- Service workers and push require HTTPS with a trusted certificate (user report, not official). — [Node-RED forum](https://discourse.nodered.org/t/when-is-it-advisable-to-use-https-with-tailscale/95251)
- Grafana v12-13 docs still recommend USE/RED layouts for health dashboards. — [Grafana best practices](https://grafana.com/docs/grafana/next/visualizations/dashboards/build-dashboards/best-practices/)

### Inferences
- Suggested stack: Next.js (App Router) or Vite + React, shadcn/ui, shadcn charts/Recharts (sparklines in KPI cards only; one line/area chart per section), next-themes for light/dark (follow system), SQLite for event log, a single typed `events` table feeding all metrics. For Spanish-first i18n use a message-catalogue library (next-intl is the common choice, but I found no source confirming current compatibility; verify). Use `Intl.NumberFormat('es-ES')` and `es-ES` date formats (EUR, 1.234,56, 24h time, DD/MM) in all charts and tooltips.
- Streamlit/Grafana are faster for dev-facing screens but harder to make touch-friendly and Spanish-polished for owners; reserve Grafana for a hidden "Salud del sistema" link if wanted.
- Accessibility build checklist: colour-blind-safe palette with marker/dash/label redundancy, 3:1 non-text contrast, 44px touch targets on mobile, keyboard focus visible, text summary and table toggle per chart (e.g. "Esta semana: 6,5 h ahorradas, 1,2 h más que la anterior").

### Gaps
- No source found on next-intl App Router setup, Next.js PWA plugins, or push delivery to an installed PWA through Tailscale Serve; needs a spike on iOS and Android.
- Open WebUI extension route (Functions/Pipes) not researched.

## 5. Voice-first / mobile: owners who will not open a dashboard daily

### Takeaway
Make the daily brief and one-tap approvals live in WhatsApp (or Telegram), with the dashboard as the place for history and settings. WhatsApp rules (24-hour window, templates, 3 buttons) constrain the design and must be verified against Meta docs.

### Cited Findings
- WhatsApp Business: pre-approved templates are needed to message a customer outside the 24-hour window; interactive reply buttons allow tap responses, up to 3 buttons; list messages up to 10 options; vendors disagree on whether quick replies inside an open session need template approval. All vendor sources, not Meta. — [Infobip](https://www.infobip.com/blog/how-to-use-whatsapp-interactive-buttons); [Zoho](https://help.zoho.com/portal/en/kb/desk/support-channels/instant-messaging/whatsapp/articles/send-interactive-message-templates); [Vonage](https://www.vonage.com/resources/articles/whatsapp-interactive-messaging/); [smsmode](https://www.smsmode.com/en/whatsapp-business-api-customer-care-window-ou-templates-comment-les-utiliser/)
- Approvals delivered out-of-app (email/Slack with deep link to the step) is the established pattern in Zapier. — [Zapier help](https://help.zapier.com/hc/en-us/articles/41776074420493)
- Swipe-style approve/reject UIs for agent approvals are discussed as a mobile pattern. — [vp0](https://vp0.com/blogs/human-in-the-loop-approval-swipe-ui)

### Inferences
- Daily brief (e.g. 08:30 local): 5 lines max: what needs approval (count), today's calendar conflicts, money waiting (invoices due/overdue), one thing Annie did overnight, and 3 quick-reply buttons ("Aprobar todo seguro", "Ver pendientes", "Más tarde"). Keep each approval one message with Aprobar / Editar / Rechazar (3-button limit) and a deep link to the PWA for detail.
- The owner messaging their own number (self-chat) is likely within the 24h window after any reply, but a morning push needs an approved template or a Telegram bot (Telegram has no template restriction; not sourced here). Decide channel per owner; offer Telegram as fallback.
- Voice: accept voice notes for commands and read back a short confirmation before irreversible actions; local speech-to-text on the mini PC is plausible but not researched.
- Fatigue guard: batch low-risk approvals into one daily digest; only interrupt for time-sensitive or irreversible items.

### Gaps
- No Meta primary documentation on current 2026 template categories, pricing or window rules; confirm before design lock.
- No sources on Telegram bot capabilities, local voice transcription quality in Spanish, or EU data-protection/AI-Act transparency obligations for such an assistant; these were not researched.
