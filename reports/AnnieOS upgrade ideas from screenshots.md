# Borrow the patterns, not the products, for AnnieOS

**The screenshots hold one product-grade idea and four useful patterns, and none of the five items needs a vendor dependency to be useful.** The strongest idea is the vault-style memory architecture (schema-enforced pages, three write-permission layers, a nightly consolidation job that proposes changes). It has public precedent, it can be built with ordinary files, SQLite and a small write gateway, and it directly serves what Spanish small-business owners will pay for: auditability, control and a system that visibly improves. The "decision model" idea (EEVO-1) is worth copying as a design pattern, a small structured-output layer in the router with calibrated confidence and an audit record. The product itself is two days old, cloud-only as far as anyone can tell, and its numbers are all self-reported. The Harness Learning paper is a real paper, but its code is not released. The practical version for you is a GEPA/DSPy-style optimisation loop, which only works once you have a held-out set of the customer's own tasks. The Ollama infographic is a decent beginner guide, but its model example is stale and its sizing table is wrong for the mixture-of-experts (MoE) models you will actually run on a Strix Halo box. The dashboard rules are sound but incomplete for an AI assistant, where trust (approval queue, action trail, undo) matters more than charts.

**Important caveat on evidence.** The research agents could not open most primary pages (DNS errors; some sites blocked). Almost everything below comes from search-result summaries, with some model facts checked directly on Hugging Face. Each section says what is verified, what is a vendor claim, and what is my inference. Your 11 screenshots cover five topics (EEVO-1 is one image, the harness-learning paper three, the Ollama infographic one, the vault architecture five, the dashboard rules one), and every screenshot is covered below.

## Verdicts and the five actions to take first

| Item | Verdict | One-line reason |
|---|---|---|
| (a) EEVO-1 decision model | **Watch** the product; **adopt now** the concept (build your own structured "decision" layer with local models) | Cloud API only as far as found, no residency or licence info, vendor-only benchmarks |
| (b) Harness Learning paper | **Watch** the paper and code; **adopt later** the cheap GEPA/DSPy-style loop | Code is a placeholder; you need an eval set first |
| (c) Ollama infographic | **Adopt now** the corrected model stack and hardening advice; **skip** its sizing table and example model | Table is wrong for MoE on unified memory; `qwen3:8b` is two generations old |
| (d) Vault agent-OS architecture | **Adopt now** the pattern (own implementation); **skip** the Operator OS product until verified | Every piece has public precedent; the creator's claims are unverified |
| (e) 7 dashboard design rules | **Adopt now**, extended with five more rules and AI-specific panels | Mainstream and consistent with the literature; misses accessibility and trust |

The top five recommended actions, in order:

1. Build the vault with a **single write gateway** that enforces the schema and the three write layers (sources immutable, wiki agent-owned, live operations), and commits every write to git with actor, model and run id.
2. Add a **structured decision layer** to the router: constrained JSON with an action enum, per-option confidence, a risk tier and a logged rationale, with thresholds for "ask the owner" and "escalate to a bigger model".
3. Start **logging every task run and collecting owner corrections now**, and write 30 to 100 held-out test cases per vertical. This is the prerequisite for any harness optimisation and for honest ROI cards.
4. **Benchmark the candidate model stack on the real box** (64 and 128 GB), set the GPU memory pool correctly, and choose the runtime (llama-server or Lemonade versus Ollama).
5. Ship the owner **"Today" screen** (approval queue, what Annie did, four or five value cards) plus a short WhatsApp or Telegram daily brief, after verifying WhatsApp's template and window rules with Meta.

## Eevo-1 is real, two days old, and not something you can run locally

### What it is

The product is spelled **Eevo** (not "EVO-1") and comes from The Upright Project, a Finnish company. It was announced on **14 October 2026** as "the first consequential decision model" for AI agents ([Eevo page](https://www.uprightproject.com/eevo/); [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)). You give it a decision, the options and whose interests count. It returns, per stakeholder, the highest-expected-value option plus a calibrated probability for each option, and it records whose interests were prioritised and where they conflicted ([press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)). According to the team's Show HN post, it is a model trained on comparative sizing of consequences, wrapped in a harness that runs pairwise comparisons, models overlap between consequences and computes expected value, while the calling agent supplies context, options and consequences ([Show HN](https://news.ycombinator.com/item?id=50093003)). Access is through an API, MCP or a web console ([press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)).

"Doesn't chat, makes decisions" therefore means typed, bounded, probability-carrying outputs instead of prose. A rival, TypeSafe AI's **Jev** (launched 15 September 2026 in early access), is the classification, routing and scoring flavour of the same idea ([Let's Data Science](https://letsdatascience.com/news/typesafe-ai-launches-jev-decision-model-889a38c0); [HackerNoon](https://hackernoon.com/inside-jev-how-decision-models-trade-text-generation-for-typed-calibrated-answers)). The slide's obscured third name is almost certainly Jev, which is my inference from the matching comparison set.

### Verified facts versus vendor claims

| Item | Status | Detail |
|---|---|---|
| Product exists, maker, date | Reported by vendor pages via search summary; primary pages not read | Upright Project, 14 Oct 2026 |
| Benchmarks | **Vendor claims only** | STEER: Eevo-1 72.8% vs Jev 70.3%, Microsoft-Decision-1 66.4%, OpenAI Decisions 64.8%; other self-reported scores 81.9 / 84.2 / 83.3 and 84.2 on its own CoCoCo benchmark ([press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/); [Show HN](https://news.ycombinator.com/item?id=50093003)). The mapping of scores to eval names is as summarised by search, not verified |
| STEER benchmark itself | Real, peer-reviewed (ICML 2024) | [arXiv 2402.09552](https://arxiv.org/pdf/2402.09552). Upright's "16,300 questions" figure was not found elsewhere |
| "Beats Claude and OpenAI" | **Not supported** | The compared systems are other decision models, not general chat models. No Claude comparison was found |
| Pricing | Vendor-stated | $2.50 per million input tokens, output free, summed over every internal model call; about $0.20 per decision ([press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/); [Eevo page](https://www.uprightproject.com/eevo/)). Jev is listed at $0.042 per million input tokens ([Let's Data Science](https://letsdatascience.com/news/typesafe-ai-launches-jev-decision-model-889a38c0)) |
| Local or open weights | **Not found** | No weights, licence, base model, hosting region, subprocessors or GDPR terms found. Treat as cloud API only |
| Valohai connection | **Unknown** | Valohai is an MLOps company ([docs](https://docs.valohai.com/getting-started)); no link to Upright was found and the reel itself was not located |

A 2.5-point lead over Jev on a multiple-choice benchmark, from the vendor, with no variance reported, is weak evidence. The $0.20 per decision at $2.50 per million tokens implies roughly 80,000 input tokens per decision. That figure is my arithmetic, not the vendor's, but it shows the harness is heavy: far slower and costlier than one classifier call.

### What to take from it

The notes propose, as design inference, copying the shape of the idea locally. A small model emits constrained JSON (an action enum plus a probability per option), and a threshold decides whether to act, ask the owner, or escalate. For consequential actions (send an email, move money, delete a file) the router lists options, stakeholders and consequences, scores them, and logs the rationale. The notes found no evidence that the pairwise-expected-value harness beats a plain structured-output prompt on a strong local model, so test that before building the heavy version. Do not send client personal data to Upright until you have confirmed its data location and terms.

## The Harness Learning paper points to a cheap optimisation loop, not a research project

### What it is

The paper is **arXiv 2609.35738**, "Harness Learning Enables Generalizable Test-Time Adaptation", listed late September 2026, with Alvin Zhang first author and Andrea Zanette among the co-authors ([arXiv](https://arxiv.org/abs/2609.35738); [HTML](https://arxiv.org/html/2609.35738v1)). A "harness" is the program that organises model calls, tools and information flow ([abstract mirror](https://hub.baai.ac.cn/paper/40acbea7-a35a-4401-a220-7b989cf4ec10)). The method trains a small proposer model with reinforcement learning (GRPO) to edit the harness of a frozen solver model. The loop is: run the harness, summarise outcomes and traces into an execution report, let the proposer output a code diff, then score the revised harness ([StartupHub summary](https://www.startuphub.ai/ai-news/ai-research/2026/small-editors-learn-to-rewrite-agents-at-test-time)). No weights of the solver are changed.

### Verified versus unverified

The full paper text was **not read**; everything comes from search snippets. Reported results, all unverified against the PDF: on Reasoning Gym, single-step revision score on 21 unseen task families rose from 0.32 to 0.62, and a trained 4B proposer beat its 35B teacher on average; on multi-hop QA a proposer trained on HotpotQA transferred to MuSiQue and 2WikiMultihopQA, with MuSiQue reaching a mean 0.27 after ten revision rounds versus 0.15 for single-step ([arXiv HTML snippet](https://arxiv.org/html/2609.35738v1)). The summary notes that compute and feedback are not matched across approaches, so comparisons need care. The companion code repo is MIT-licensed but its README says only "Code coming soon!" ([GitHub](https://github.com/AlvinZH04/Harness-Learning)). Solver models, per-task gains, training compute, venue and the paper's limitations section were not recovered. The carousel's examples (retries, output validation) are plausible but not confirmed as the paper's own.

### The nearest usable tool

GEPA (reflective prompt evolution) is peer-reviewed at ICLR 2026, reads full traces, and is reported to beat GRPO by 6 points on average (up to 19) with up to 35 times fewer rollouts, and to beat MIPROv2 by over 10 points. It ships as `dspy.GEPA` and as a standalone library ([ICLR](https://proceedings.iclr.cc/paper_files/paper/2026/hash/0e9e708b6f48e14fd0ac29e167413f76-Abstract-Conference.html); [arXiv](https://arxiv.org/html/2507.19457v1)). Many concurrent 2026 papers on harness evolution exist (TTHE, MemoHarness, HarnessForge and others), but the notes read only titles ([TTHE](https://arxiv.org/pdf/2607.08124)). The notes found no benchmark of GEPA with 7B to 30B local solvers. Reinforcement-learning training of a proposer is, by the notes' unverified inference, not realistic on an integrated-GPU mini PC. The paper's own caveat about proposers producing broken edits is why it adds validity reward shaping ([arXiv HTML snippet](https://arxiv.org/html/2609.35738v1)).

## Ollama infographic: right idea, stale model, wrong sizing for your hardware

### What holds up

The model landscape has moved. **Gemma 4 is real** and Apache-2.0 (E2B, E4B, 12B, 26B-A4B MoE, 31B dense) ([HF gemma-4-31B-it](https://hf.co/google/gemma-4-31B-it); [26B-A4B](https://hf.co/google/gemma-4-26B-A4B-it)). The infographic's `qwen3:8b` is two generations behind: Qwen3.5 (February 2026, 0.8B to 397B-A17B), Qwen3.6 (35B-A3B and 27B, April 2026) and Qwen3.8-27B (August 2026) all exist on Hugging Face under Apache-2.0 ([Qwen3.5-9B](https://hf.co/Qwen/Qwen3.5-9B); [Qwen3.6-35B-A3B](https://hf.co/Qwen/Qwen3.6-35B-A3B); [Qwen3.8-27B](https://hf.co/Qwen/Qwen3.8-27B)). Two Qwen3.8 variants carry a licence tagged "other" and need reading before commercial use ([Flash-Next](https://hf.co/Qwen/Qwen3.8-Flash-Next)). The "no per-token cost, offline, private" claim is valid, though tool-calling agents widen the attack surface.

**Unverified:** ollama.com was unreachable, so no Ollama tag (`gemma4`, `qwen3.6` and so on) was confirmed. Run `ollama list` or check the library before using any tag. The 4096-token default context in Ollama's FAQ may have changed in recent releases ([Ollama FAQ](https://raw.githubusercontent.com/ollama/ollama/main/docs/faq.mdx)).

### Why the sizing table is wrong for you

The infographic's rule (1 to 4B needs 8 GB, 7 to 8B needs 16 GB, 13 to 14B needs 24 GB or more, 30B+ needs 48 GB or more, 70B+ needs multi-GPU) is a dense-model, discrete-GPU rule. On Strix Halo you size by total weight bytes plus context against the GPU-addressable pool, and you get speed from **active** parameters, because token generation is bandwidth-bound. Measured on a Ryzen AI Max+ 395 in a community benchmark repo (single user, llama.cpp version not stated): Qwen3-30B-A3B Q4 about **86 tokens/s**, gpt-oss-120b about **53**, Qwen3-Coder-Next 80B-A3B about **43**, dense Qwen2.5-32B about **11** and dense Llama-3.1-70B about **5** ([visorcraft/strix-halo-llm-perf](https://github.com/visorcraft/strix-halo-llm-perf)). Other reports put gpt-oss-120b lower, at 34 tokens/s in October 2025 ([Level1Techs](https://forum.level1techs.com/t/strix-halo-llm-inference-notes/249466)). No benchmarks of Qwen3.5/3.6/3.8 or Gemma 4 on this chip were found.

### Corrected sizing table (my estimates, not benchmarked, except the three measured sizes)

Estimates use Q4 at about 0.6 bytes per parameter plus context and 8 to 10 GB for the operating system and other services, calibrated on measured sizes of Qwen3-30B-A3B Q4 (17.3 GiB), gpt-oss-120b (58.5 GiB) and Qwen3-Coder-Next Q4 (45 GiB) ([visorcraft](https://github.com/visorcraft/strix-halo-llm-perf)).

| Model class | Active params | Approx. Q4 size | 64 GB box | 128 GB box |
|---|---|---|---|---|
| 4B (Qwen3.5-4B, Gemma 4 E4B) | 4B | ~3 GB | Yes | Yes |
| 9-12B (Qwen3.5-9B, Gemma 4 12B) | 9-12B | ~6-8 GB | Yes | Yes |
| 26-35B MoE (Qwen3.6-35B-A3B, Gemma 4 26B-A4B) | 3-4B | ~17-22 GB | Yes, fast | Yes |
| 27-31B dense (Qwen3.8-27B, Gemma 4 31B) | 27-31B | ~16-19 GB | Yes, slow (~10 t/s est.) | Yes |
| gpt-oss-120b (native MXFP4) | ~5B | 58.5 GiB (measured) | No, too tight | Yes, ~50 t/s |
| Qwen3-Coder-Next 80B-A3B | 3B | ~45 GiB (measured) | Tight, small context | Yes |
| 119-122B MoE (Mistral Small 4, Qwen3.5-122B-A10B) | 6-10B | ~70 GB | No | Q4 yes, little room for other big models |
| 235B MoE | ~22B | Q3 ~105 GiB (measured) | No | Q3 only, ~17 t/s |

The notes also advise setting the BIOS GPU carve-out small and raising the GTT limit (about 48 to 56 GB on a 64 GB machine, about 110 to 120 GB on 128 GB; both are estimates), because default settings left one user's ROCm seeing only about 4 GB ([Level1Techs](https://forum.level1techs.com/t/rocm-can-only-use-half-of-the-unified-memory-on-my-strix-halo/253152); [Framework community](https://community.frame.work/t/ryzen-ai-max-395-how-should-i-configure-the-gpu-vram-from-the-bios-settings/76753)). Reported backend rule of thumb: Vulkan (RADV) is usually faster for generation, ROCm better for long-prompt ingestion ([visorcraft](https://github.com/visorcraft/strix-halo-llm-perf)). Long prompts matter for document work: a 20,000-token prompt takes tens of seconds at the prompt speeds measured (hundreds of tokens/s, inference).

### Per-role model recommendations (unverified; picked from what exists with a compatible licence, not from benchmarks)

| Role | Recommendation | Notes |
|---|---|---|
| Router / classifier | Qwen3.5-4B or Gemma 4 E4B | Both Apache-2.0 |
| Everyday chat and tool calling | Qwen3.6-35B-A3B (fast MoE); alternatives Qwen3.8-27B, Gemma 4 26B-A4B | Dense 27B only if quality outweighs speed |
| Reasoning / heavy agent work | gpt-oss-120b, Qwen3.5-122B-A10B or Mistral Small 4 (128 GB only) | Mistral Small 4 licence and active-parameter figure come from secondary sources ([HF](https://hf.co/mistralai/Mistral-Small-4-119B-2603)); an EU-origin model helps the pitch |
| Coder | Qwen3-Coder-Next 80B-A3B | [HF](https://hf.co/Qwen/Qwen3-Coder-Next) |
| Vision | Qwen3.5/3.6 or Gemma 4 natively | No separate vision model needed |
| Embeddings and reranker | bge-m3 with bge-reranker-v2-m3 (safe, Apache-2.0), or Qwen3-Embedding with Qwen3-Reranker | Sources are vendor-authored ([SiliconFlow](https://www.siliconflow.com/articles/best-reranker-model-for-document-retrieval)) |
| Speech-to-text | Parakeet-tdt-0.6b-v3 (lists Spanish), Whisper large-v3(-turbo) fallback | [HF](https://hf.co/nvidia/parakeet-tdt-0.6b-v3) |
| Text-to-speech | Kokoro (82M, Apache-2.0) | Spanish voice quality unverified ([tts.ai](https://tts.ai/blog/open-source-text-to-speech-guide-2026/?lang=ru)) |
| Wake word | **No sourced finding** | Candidates to test: openWakeWord, Porcupine, microWakeWord (unverified) |

"Leader" rankings here are based on download and like counts plus roundups, not Artificial Analysis or LMArena data, and reasoning leaders such as DeepSeek, GLM and Kimi were not checked. Prefer Apache-2.0 models for resale and avoid the "other"-licence Qwen3.8 variants without legal review.

### Runtime and hardening

Ollama wraps llama.cpp and is fine for a first single-user version if you set context, keep-alive and parallelism explicitly. For a product, llama.cpp's `llama-server` or AMD-sponsored Lemonade (which orchestrates llama.cpp, an NPU path, whisper.cpp and Kokoro) give more control ([Lilting](https://lilting.ch/en/articles/amd-lemonade-local-ai-gpu-npu-server)). vLLM suits many concurrent users on discrete GPUs and is not the natural choice here (blog-quality comparisons, unclear methodology ([Codersera](https://codersera.com/blog/ollama-vs-lm-studio-vs-vllm-vs-llama-cpp-vs-mlx-2026/amp/))). Ollama has **no built-in authentication** and binds to loopback by default; a scan reportedly found about 175,000 exposed Ollama hosts, nearly half with tool calling enabled (secondary report, primary not read) ([Elest.io](https://blog.elest.io/175-000-ollama-servers-are-wide-open-right-now-is-yours-one-of-them/); [Twingate](https://www.twingate.com/blog/ollama-server-exposure)). Docker's `-p 11434:11434` can bypass firewall rules. Keep the engine on 127.0.0.1 or a Unix socket with only the AnnieOS backend as client.

## The vault pattern is mostly precedent, and its best parts are structural

### What the carousel describes and what is verified

Nothing about **operatoros.ai, @davis.mcm or @os.operator could be verified**. A Skool community called "Operator OS" ($50 a month, ecommerce marketing) exists but may be unrelated ([Skool](https://www.skool.com/operator-os-3049/about)). The "comment VAULT for the doc" wording is a standard lead-magnet funnel (inference). The figures in the carousel (297 files, 9 hooks, a 3 a.m. dream agent) are creator claims with no independent confirmation. Ask: who is behind it, what it costs, whether it is open source. That is a manual check for you.

What is verifiable is that every component has public precedent. Karpathy's "LLM Wiki" idea (reportedly April 2026; gist not opened) has three layers: immutable raw sources, an LLM-maintained markdown wiki and a schema file, with periodic lint passes and index-first retrieval ([VentureBeat](https://venturebeat.com/data/karpathy-shares-llm-knowledge-base-architecture-that-bypasses-rag-with-an); [Towards AI](https://pub.towardsai.net/andrej-karpathy-killed-rag-or-did-he-the-llm-wiki-pattern-7824d876e790)). OpenClaw keeps plain-markdown memory in tiers (a curated MEMORY.md, daily notes, optional DREAMS.md for human review) with a background "dreaming" sweep that promotes only items passing score and recall thresholds ([OpenClaw docs](https://docs.openclaw.ai/concepts/memory.md)); the docs conflict on whether dreaming is on by default. Letta's sleep-time agents consolidate memory while the main agent is idle, but its own docs call the feature experimental ([Letta](https://docs.letta.com/guides/agents/sleep-time-agents)). Generative Agents introduced reflection ([arXiv 2304.03442](https://arxiv.org/pdf/2304.03442v1)). Claude Code hooks (SessionStart, PreToolUse and so on) give deterministic guardrails outside the model, where PreToolUse can block a call ([hooks docs](https://code.claude.com/docs/en/hooks)). Basic Memory is a ready-made markdown-plus-SQLite MCP server, but **AGPL-3.0**, which matters for commercial reuse ([Basic Memory](https://www.mintlify.com/basicmachines-co/basic-memory/concepts/how-it-works)). Vendor memory benchmarks (Mem0, Zep, Letta) conflict and are not comparable ([Atlan](https://atlan.com/know/mem0-alternatives/)). The "trust levels" (seedling, growing, evergreen) idea was not found in prior art and looks like marketing unless tied to provenance (inference).

### Ranking the ideas for a small-business assistant (inference from the notes)

The ideas that bound damage regardless of model quality rank highest: write-permission layers, schema-validated writes through a single API, a small always-loaded curated file, source-trust ordering (owner above employee above inbound email above web), and per-run cost logging. Nightly consolidation adds value but is the riskiest writer, so it should propose diffs for review, not overwrite.

### Failure modes that matter for you

Persistent memory turns a one-off prompt injection into durable compromise, and ingesting client email into a trusted wiki is exactly that path. The notes cite OWASP's agentic top 10 listing memory and context poisoning ([Vectorize](https://vectorize.io/articles/ai-memory-poisoning)), MemoryGraft-style attacks where planted "successful experiences" are later trusted ([arXiv 2512.16962](https://arxiv.org/html/2512.16962)), and dormant fabricated memories ([ICML 2026](https://icml.cc/virtual/2026/67842)). Reported attack success rates come from a vendor and vary widely; check originals. On GDPR, sources (blogs, not regulator text) say erasure must reach memory, vector stores, logs and derived inferences, and that embeddings of personal data may count as personal data ([Atlan](https://atlan.com/know/ai-agent/gdpr-compliance-for-ai-agents/); [sota.io](https://sota.io/blog/eu-ai-act-agentic-ai-memory-rag-compliance-gdpr-vector-stores-2026)). No primary EDPB text was read; get legal review.

### Can small local models write schema-valid pages?

Constrained decoding guarantees syntax, not correctness. On 0.5 to 1.7B models, forcing a schema raised validity from 61.5% to 100% but cut accuracy from 19.7% to 11.0%, and one Qwen2.5-1.5B tool-calling test fell from 91.5% to 48.0% ([The Constraint Tax](https://www.alphaxiv.org/abs/2605.26128)). Those sizes are far below your 7 to 30B range, so this is a warning, not a measurement, and no benchmark of 7 to 30B models doing wiki consolidation was found ([StructureBench](https://www.ijcai.org/proceedings/2026/0267.pdf)). The notes' inferred recipe: ask for flat JSON, validate it in code, retry with error feedback two or three times, render the markdown from validated JSON by template so the model never writes frontmatter, split consolidation into small per-page steps, and escalate on failure.

## Dashboard rules are sound but written for BI, not for a trusted assistant

The seven rules (key metrics first, grouping, consistency, limited visuals, trends, filters and drill-down, restraint) match mainstream guidance: three to seven headline metrics per view ([AuFaitUX](https://www.aufaitux.com/blog/good-dashboard-design/)), Few's single-screen principle and warnings against excess detail and colour ([UXmatters](https://uxmatters.com/mt/archives/2007/04/book-review-information-dashboard-design.php)), Tufte on data-ink and sparklines ([IEEE Spectrum](https://spectrum.ieee.org/tufteisms)), and Grafana on thresholds and USE/RED layouts for health panels ([Grafana](https://grafana.com/docs/grafana/latest/best-practices/)). The uiux.build post itself was not found, so the rules are taken from your description. One tension: rule 6 pushes interactivity while Few favours one screen, so keep filters minimal for non-technical owners.

The post misses accessibility and data trust. WCAG 2.2 requires 24-pixel minimum targets (2.5.8) and 3:1 contrast for graphical objects (1.4.11); phone guidance is larger, 44 pt on iOS and 48 dp on Android ([DAISY](https://kb.daisy.org/publishing/docs/wcag/target-size-minimum.html); [Visa](https://design.visa.com/global-accessibility-requirements/mobile/visual/)). Colour must not be the only carrier of meaning ([Material blog](https://m2.material.io/blog/data-visualization-accessibility)). My proposed additions: accessible colour, honest charts, an "as of" time on every number, designed empty and error states ("WhatsApp not connected since 09:12", never a silent zero), and an explain-this-number drawer.

For an assistant, the job is trust. Pattern libraries recommend reversibility marking, a human-readable action trail with undo, pre-action visibility and risk-tiered approval to avoid approval fatigue ([AI UX Playground](https://www.aiuxplayground.com/pattern/reversibility-marking); [Towards AI](https://pub.towardsai.net/designing-for-ai-agents-8-ux-patterns-that-build-trust-in-2026-713a0c926933); [Skins Factory](https://www.theskinsfactory.com/uiux-design-questions-answers/how-do-you-design-human-in-the-loop-ai-without-creating-approval-fatigue)). One unreviewed preprint reports higher preference for high-transparency agents (about 38 points), with a low-confidence warning adding about 22 ([arXiv 2606.18716](https://arxiv.org/pdf/2606.18716)); treat it cautiously. Zapier records approvals with actor and timestamp in an audit log ([Zapier](https://help.zapier.com/hc/en-us/articles/41776074420493)), and Lindy advises starting with heavy oversight and loosening ([Lindy](https://docs.lindy.ai/testing/human-in-the-loop.md)). Most of this evidence is practitioner content, not empirical research.

ROI numbers owners respond to are real but soft: Adobe's survey of 431 small-business owners reported about 175 hours a year saved on social content and 152 on report summaries, with Adobe noting self-report bias ([Adobe](https://www.adobe.com/acrobat/resources/small-business-superpower-study.html)); other surveys are US-based, vendor-run and self-reported ([Bluehost](https://www.bluehost.com/state-of-small-business-ai-confidence/the-roi-picture)). **No Spain or EU survey was found**, and no source validates per-task baseline minutes; those need a pilot. On technology, the notes suggest shadcn/ui with Recharts, a PWA over Tailscale Serve, and Grafana only for a hidden health view ([shadcn charts](https://ui-v4.shadcn.com/docs/components/chart); [Open WebUI Tailscale docs](https://docs.openwebui.com/ecosystem/computer/phone-and-remote/tailscale)). Push notifications to an installed PWA over Tailscale were not confirmed and need a spike on iOS and Android. WhatsApp constraints (24-hour window, pre-approved templates, three reply buttons) come from vendor sources, not Meta, so verify them ([Infobip](https://www.infobip.com/blog/how-to-use-whatsapp-interactive-buttons)).

## Implications for AnnieOS

Everything in this section is **my assessment built on the notes**, not sourced fact, except where a citation is given. Effort is S (days), M (weeks), L (months) for a solo founder; these sizes are rough inferences.

### Assessment per idea

| Idea | Integration design | Value (customer and commercial) | Effort | Main risks | Priority |
|---|---|---|---|---|---|
| **Vault memory with write layers** | Markdown files plus a write gateway. Layer 1 raw sources (emails, documents) immutable; layer 2 wiki pages agent-owned, schema-validated; layer 3 live operations (tasks, drafts). SQLite FTS5 index (rebuildable), embeddings only if recall is poor. Git commit per write | Owner can read and edit what Annie "knows"; per-subject pages make GDPR access and erasure tractable; auditability is a sales argument | M | Injection via email into the wiki; git history blocks erasure unless designed for it; concurrency; schema bloat | 1 (now) |
| **Schema-enforced writes** | Model returns flat JSON; code validates and retries; templates render the markdown | Reliable memory on small models | S-M | Constrained decoding can hurt small models; validate-and-retry costs latency | 1 (now) |
| **Nightly consolidation as proposals** | Job runs on the idle box, drafts per-page diffs with source links; low-risk diffs auto-merge after a trial period, others queue for owner review; git revert | Visible "Annie learned this" feed; retention through continual improvement | M | Drift and compounding errors; poisoning; no evidence of effect on quality | 2 (after gateway works) |
| **Hot file (~500 words)** | Short curated owner profile and rules loaded every session, human-editable | Cheap personalisation; owner can fix it | S | Stale or poisoned content; keep it reviewable | 1 |
| **Source-trust tiers** | Trust labels (owner, employee, inbound email, web) stored per fact; low tiers cannot create "evergreen" entries | Defence against injection | S | Needs consistent labelling | 1 |
| **Hook-style guardrails** | Implement as code in AnnieOS's own runtime: allow-lists, action blocking, rate limits (Claude Code hooks are only a model for this) | Safe automation; lets you say what Annie can never do | M | Gaps in policy coverage | 1 |
| **Decision layer in router** | Constrained JSON: action enum, per-option confidence, risk tier, rationale. Thresholds: auto, ask owner, escalate | Fewer wrong actions; every consequential step has a logged "why"; supports EU AI Act style record-keeping (inference, check legally) | M | Small-model calibration untested; constrained decoding trade-off | 1 |
| **Eevo-style stakeholder scoring** | Only for the highest-risk actions (sending to clients, payments). Pairwise comparison of consequences by a local model | Differentiated "reasoned decision" record | M | No evidence it beats a plain structured prompt; slow | 3 (test first) |
| **Using Eevo itself** | Not recommended now | None demonstrated | S | Cloud-only, unknown residency, 2 days old, self-reported benchmarks | Watch |
| **GEPA/DSPy harness optimisation** | Nightly or weekly job on the customer's own logged tasks: execution report, candidate prompt or harness edits, score on held-out cases with a frozen model, keep the winner, keep an archive for rollback | Measurable "Annie got better" claim; defensible care-plan value | M-L | Overfitting to small eval sets, reward hacking, unsafe edits; gains on benchmarks may not transfer | 2-3 (needs eval set first) |
| **RL-trained proposer (the paper)** | Wait for code and results on assistant tasks | Possibly later | L | Code unreleased; compute | Watch |
| **Updated model stack** | Table above; keep a small always-on set (router, embedder, reranker, STT) plus one big model | Speed and quality on the 2,000 EUR box; a 128 GB tier justified by 120B-class MoE | S-M | Unverified tags and speeds; memory-pool configuration errors | 1 (now) |
| **Owner dashboard** | "Today" screen: approval queue first, what Annie did, four or five KPI cards, connector status; Advanced tab for model and system health; Spanish locale formats | Perceived control; demonstrable ROI | M | Self-reported ROI inflation; approval fatigue | 1 |
| **WhatsApp/Telegram daily brief** | Five lines, three buttons, deep link to the dashboard | Owners who never open dashboards still engage | S-M | Meta template and window rules, EU data issues with WhatsApp (not researched) | 2 |

### How the pieces fit together (architecture sketch)

```
 Inputs: email, calendar, WhatsApp, documents, voice (wake word -> STT)
                       |
              [Ingestion, low-privilege extractor model, no tools]
                       |  schema-valid, source-cited facts only
                       v
 +-------------------- VAULT (markdown + git) ---------------------+
 | L1 raw sources (immutable) | L2 wiki pages (agent-owned)        |
 | L3 live ops (tasks, drafts)| hot file, per-page ACL, trust tier |
 +--------------^----------------------------------^---------------+
                |  all writes via WRITE GATEWAY     | nightly proposals (diffs)
                |  (schema, layers, ACL, log, git)  | = consolidation job
                |                                   |
   Request -> ROUTER (small model, constrained JSON "decision":
              intent, action, confidence, risk tier, rationale)
                |--> specialist local models (chat+tools, reasoning, coder, vision)
                |--> low confidence / hard task -> optional cloud escalation (owner-consented, logged)
                v
   ACTION LAYER: allow-lists, reversibility tags, approval rules
                |--> auto (read, draft)   |--> approval queue (send, pay, delete)
                v
   EVENT LOG (SQLite): every run, tool call, cost, correction
        |                         |
        v                         v
   OWNER DASHBOARD         OPTIMISATION LOOP (GEPA/DSPy-style, weekly):
   approval queue,          logs -> execution report -> candidate edits ->
   activity feed,           score on held-out customer tasks (frozen model) ->
   time-saved cards,        accept only if better and valid -> archive/rollback
   "Annie learned"
```

The design rule that ties it together is "the model proposes, code disposes": models never write files or send messages directly, and the gateway, action layer and evaluator are outside anything the optimiser may edit. This follows the notes' inference that the optimiser must never edit its own evaluator.

### Phased roadmap

**Next 2 weeks.** Set the GPU memory pool and benchmark the candidate stack on the real box (at least one 4B router, one 26 to 35B MoE chat model, one embedder, STT). Check Ollama tags by hand. Define the vault schema (a small set of page types: client, matter or case, contact, task, preference, decision) and write the gateway with schema validation, layer permissions and git commits. Add event logging for every run and owner correction. Start writing 30 test cases for one vertical (a gestoria is a natural first).

**Next 2 months.** Ship the router decision layer with confidence thresholds and risk tiers. Build the dashboard "Today" screen and the approval queue, plus the daily brief on a channel confirmed against Meta's rules. Add the nightly consolidation job in proposal-only mode with a diff review screen. Run a pilot with two or three friendly businesses to measure baselines for time-saved cards. Run a first GEPA/DSPy experiment on routing and drafting prompts using the held-out set, and compare it with the plain baseline. Run a poisoning test: send crafted emails and see whether anything reaches layer 2.

**Later.** Per-vertical eval packs and per-customer optimisation loops sold inside the care plan. Auto-merge for low-risk consolidation after a track record. Evaluate the Harness Learning code if released and the Eevo and Jev products once independent evaluations and EU terms exist. A 128 GB tier for 120B-class models once measured on the box. Legal review of GDPR erasure design and EU AI Act obligations.

### Commercial angles for Spanish small businesses

These are inferences, and anything about Kit Digital eligibility is not covered by the notes: confirm current rules with an authorised "agente digitalizador" before pitching it.

Auditability is the lead differentiator for gestorias and law firms. An owner can open a page, see what Annie "knows", where it came from and who changed it, and revert it. "Annie learned this" cards turn the nightly job into a visible weekly deliverable, which supports the 150 to 400 EUR monthly care plan: the customer sees the system improving. Time-saved cards help justify the 6,000 to 10,000 EUR fee, but only if they are honest (count accepted work only, conservative editable baselines, "followed by" not "caused by", formulas shown) because the available surveys are self-reported and non-Spanish. Local processing is a real pitch for professional-secrecy sectors (law, clinics), though the notes did not research the legal basis. Be careful not to promise compliance: erasure, retention and any cloud escalation need a documented data protection impact assessment and processor terms, and the notes recommend legal review. Offering an owner-controlled switch for cloud escalation, off by default, keeps the privacy claim clean.

## What to verify next

Open questions and the exact checks, in rough order of importance:

1. **Local model speeds and fit.** Run llama-bench and a real task suite on the actual 64 GB and 128 GB boxes for Qwen3.6-35B-A3B, Gemma 4 26B-A4B, Qwen3.8-27B, gpt-oss-120b and Mistral Small 4. Record prompt speed, generation speed, memory, and quality in Spanish. No published numbers exist for the newer models on this chip.
2. **Ollama tags and defaults.** Open ollama.com/library and confirm the tags for Gemma 4, Qwen3.5/3.6/3.8 and gpt-oss; check current default context length, keep-alive and parallelism in the release notes.
3. **Memory pool.** Follow AMD's Strix Halo ROCm page (not read) to set the BIOS carve-out and GTT limit, and confirm the GPU sees the memory you expect.
4. **Licences.** Read the model cards for Mistral Small 4 (licence and active parameters came from secondary sources) and any Qwen3.8 variant tagged "other" before building them into a sold product.
5. **Spanish speech.** Test Parakeet v3 and Whisper for Spanish accents and legal vocabulary, test Kokoro Spanish voices, and try the three wake-word options. None were verified.
6. **Eevo and Jev.** Visit uprightproject.com/eevo and the model page; ask Upright about licence, open weights, hosting region, subprocessors, retention and a data processing agreement. Check whether independent evaluations appear. Ask whether Valohai has any relationship (the notes could not find one). Find the Instagram reel's exact claim about Claude.
7. **Operator OS.** Visit operatoros.ai and the Instagram profiles; find who runs it, the price, and whether any code or documentation is public. Check whether the Skool community is related.
8. **Harness Learning.** Read the PDF (arXiv 2609.35738): solver models, example diffs, compute, limitations. Watch the GitHub repo for code. Read the primary GEPA paper's setup for the model sizes it used.
9. **Constrained decoding on your sizes.** Run your own test of schema-constrained versus prompt-only JSON with 4B, 9B and 27 to 35B models on your actual router and page-writing tasks.
10. **Karpathy gist, Letta and OpenClaw docs.** Read the primary pages; the notes used secondary summaries.
11. **WhatsApp.** Confirm template categories, pricing and the 24-hour window with Meta's documentation, and decide whether Telegram is an acceptable fallback; research data-protection implications of routing owner messages through WhatsApp.
12. **PWA push.** Build a spike that tests web push to an installed PWA over Tailscale Serve on iOS and Android.
13. **Legal.** Get advice on GDPR erasure with git history, embeddings as personal data, DPIA, EU AI Act duties for your use cases, and Kit Digital eligibility. The notes did not read any regulator text.
14. **Dashboard sources.** The uiux.build post was not found; primary NN/g, Perceptual Edge and Apple HIG pages were not read.

## Conclusion

The five screenshots look like five separate tools, but for AnnieOS they converge on one principle: put the intelligence in small models, and put the safety, memory and learning in plain, inspectable code around them. The vault gives memory the owner can read, the decision layer gives each action a recorded reason and a confidence, the optimisation loop gives a monthly improvement the customer can see, and the dashboard makes all of it legible. None of this depends on a vendor, which fits a product whose main promise is that client data stays on the box.

The main thing the research changes is the order of work. The flashy items (a decision-model API, an RL-trained proposer) are the least ready, while the unglamorous ones (a write gateway, an event log, a held-out test set, correct GPU memory settings) are the enabling infrastructure for everything else. Build the logging and test set first, because they unlock memory quality, routing calibration, optimisation and honest ROI cards at the same time. Every external claim in the screenshots remains unverified until the checks above are done.
