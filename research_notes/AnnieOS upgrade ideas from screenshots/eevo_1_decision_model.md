# EEVO-1 (Eevo-1) decision model, research notes (as of 2026-10-16)

Method caveat: WebFetch failed for every page (DNS ENOTFOUND via sandbox proxy), so all facts below come from WebSearch result summaries, not from reading the pages in full. Primary pages (uprightproject.com) were identified but not read directly. Treat numbers as "as reported by search summary of vendor pages", and re-check them against the originals.

## What is EEVO-1: maker, architecture, modality, release date, licence, open weights or API-only?

### Takeaway
EEVO-1 is real: "Eevo-1" from The Upright Project, a Finnish company, announced 14 Oct 2026 (two days before today), billed as "the first consequential decision model" for AI agents. It is delivered as an API / MCP server / web console; I found no open weights or licence info. Spelling is "Eevo", not "EVO-1".

### Cited Findings
- Upright Project's product page titles it "Eevo, the first consequential decision model"; press release "Eevo: the first consequential decision model for AI agents", dated October 14, 2026 per search summary — [Eevo page](https://www.uprightproject.com/eevo/); [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)
- Described as a Finnish technology company launching Eevo — same press release.
- Input/output: user supplies a decision, the options, and which stakeholders' interests count; model returns, per stakeholder, the highest-expected-value option plus a calibrated probability for every option, and records whose interests were prioritised and where they conflicted — [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)
- Architecture (from the team's Show HN post): a decision model trained on comparative sizing of consequences, wrapped in a harness that runs pairwise comparisons, models overlap between consequences, and computes expected value; the calling agent supplies context, options and consequences — [Show HN: Eevo](https://news.ycombinator.com/item?id=50093003)
- Access channels: Eevo API, MCP, and Eevo console — [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)
- Related page "Model" exists at https://www.uprightproject.com/model/ (listed in search results; content not read).

### Inferences
- Modality is text/structured-in, structured-out (not tabular ML, not a chat model). The "model" is partly a multi-call harness around a trained comparator, not a single forward pass; that is why pricing is "summed over every model call".
- Base model, parameter count, licence and training data are not stated in anything I saw; "API-only" is the safe working assumption.

### Gaps
- Licence, parameter count, base model, training data, open weights: not found (primary pages unreadable). Hugging Face search for "eevo" returned only an unrelated user "eevoire" (small Qwen LoRA adapters, one an "eczena-action-router"), not Upright's model — [HF search result](https://hf.co/eevoire/eczena-action-router-qwen2.5-0.5b-lora).
- No technical report / arXiv paper found.

## Who/what is "valohai", and is this marketing?

### Takeaway
Valohai is a (Finnish-origin) MLOps platform company. I could NOT confirm any link between Valohai and Upright Project/Eevo, nor find the Instagram reel itself. The reel is, at minimum, promotional content for a vendor launch.

### Cited Findings
- Valohai is an MLOps platform, per-user licence pricing, deployable on-prem/private cloud, docs at [docs.valohai.com](https://docs.valohai.com/getting-started); [pricing](https://valohai.com/pricing/)
- Searches for "Valohai EEVO-1", "Valohai Upright Project Eevo", and Valohai 2026 decision-model launch returned nothing connecting them.
- The slide wording ("vs Claude, OpenAI, Jev") matches Eevo's claimed comparison set (see benchmarks): the third name is almost certainly TypeSafe's Jev, which resolves the obscured text.

### Inferences
- The reel is probably a repost/sponsored or affiliated promo of Upright's launch (same 2 days of news cycle). Whether Valohai is an investor, partner, shared founder network, or just reposting is unknown. Note the "OpenAI" in Upright's own table is "OpenAI Decisions" and "Microsoft-Decision-1", i.e. decision-model products, not GPT/Claude chat models; the slide's "vs Claude" is not supported by anything I found (see below).

### Gaps
- Valohai-Upright relationship; the reel itself; the exact slide text.

## Benchmarks, comparisons, and independent verification of "beats the big labs"

### Takeaway
All numbers are Upright's own, on benchmarks it highlights (STEER plus its own CoCoCo etc.). No independent verification exists yet; the product is two days old. "Beats Claude/OpenAI" is not shown: reported comparators are other decision models (Jev, Microsoft-Decision-1, OpenAI Decisions), not general chat LLMs.

### Cited Findings
- STEER (economic rationality): Eevo-1 72.8% vs TypeSafe Jev 70.3%, Microsoft-Decision-1 66.4%, OpenAI Decisions 64.8%. Upright says STEER has 16,300 questions — [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)
- Other self-reported scores: 81.9% / 84.2% / 83.3% on its expected-value, game-theory and sequential-risk evals; 84.2 on CoCoCo (its own consistency-of-consequence-sizing benchmark) — [Show HN](https://news.ycombinator.com/item?id=50093003) (via search summary; mapping of the three scores to eval names is as summarised, not verified)
- Poker is also mentioned as a claimed win in the press release (search summary).
- STEER is a real, peer-reviewed benchmark (ICML 2024), multiple-choice economic-rationality questions — [arXiv 2402.09552](https://arxiv.org/pdf/2402.09552). A search found no source confirming the "16,300 questions" figure (STEER has a 64-element taxonomy; follow-up STEER-ME has 58 elements — [NeurIPS 2025](https://neurips.cc/virtual/2025/poster/121497)). Upright may be using an expanded set.
- The HN thread is short, mostly author pitch plus tester comments; no independent replication — [Show HN](https://news.ycombinator.com/item?id=50093003)

### Inferences
- A 2.5-point STEER lead over Jev, on a multiple-choice benchmark, from a vendor, with no variance/CI reported, is weak evidence. CoCoCo is Upright-authored, so it is not independent.
- Claude is not in any comparison I found; the slide may be loosely using "the big labs".

### Gaps
- Whether Claude/GPT/Gemini general models were scored on STEER by Upright; independent evals; methodology details.

## Pricing vs Claude / OpenAI / Gemini

### Takeaway
Eevo-1 is $2.50 per 1M input tokens in both modes, output free, but billed over every internal model call per decision; Upright quotes about $0.20 per decision. Jev is far cheaper per token ($0.042/M input). I did not look up current Claude/OpenAI/Gemini prices, so price-vs-big-labs cannot be stated here.

### Cited Findings
- $2.50 per M input tokens, summed over every model call in a decision, output free — [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)
- "around $0.20 per decision", weighing trade-offs "in seconds" — [Eevo page](https://www.uprightproject.com/eevo/)
- Jev (TypeSafe AI): launched 15 Sep 2026 in early access, $40M seed, $0.042 per M input tokens with free output, 70-500 ms reported latency, waitlist access; benchmarks vendor-reported — [Let's Data Science](https://letsdatascience.com/news/typesafe-ai-launches-jev-decision-model-889a38c0); [Gradually listing](https://www.gradually.ai/en/ai-models/jev/); [HackerNoon](https://hackernoon.com/inside-jev-how-decision-models-trade-text-generation-for-typed-calibrated-answers)

### Inferences
- $0.20 per decision at $2.50/M implies roughly 80k input tokens per decision (arithmetic, not stated by vendor), i.e. a heavy multi-call harness, much slower and costlier than a single classifier call. Eevo is about 60x Jev per input token.

### Gaps
- Claude/OpenAI/Gemini comparable-task cost; no apples-to-apples cost study.

## Local run on mini PC (Ryzen AI Max+ 395, 64-128 GB) / EU data residency / GDPR

### Takeaway
No evidence Eevo-1 can run locally; treat as cloud API only. Residency/GDPR info not found, though the maker is Finnish (EU).

### Cited Findings
- Only API, MCP and console access are listed — [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)
- No hosting region, DPA, or retention terms found in searches.

### Inferences
- Finnish company suggests EU entity, but where inference runs (and which upstream LLM providers see data) is unknown; if the harness calls third-party frontier models, data leaves the EU. Ask Upright before sending personal data.
- Local alternative: nothing to download; replicate the concept with local models instead (below).

### Gaps
- Weights, hosting region, subprocessors, GDPR terms.

## What "makes decisions, doesn't chat" means, and what is useful for a local orchestrator/router

### Takeaway
It means typed, calibrated, bounded outputs (an option choice plus probabilities), rather than prose. Jev is the classification/routing/scoring flavour; Eevo is the stakeholder-weighted expected-value flavour. The concept is transferable even if neither product is usable locally.

### Cited Findings
- Jev: returns typed probabilistic answers for classification, routing, scoring, extraction and other bounded decisions; not for chat or code generation — [Let's Data Science](https://letsdatascience.com/news/typesafe-ai-launches-jev-decision-model-889a38c0); [HackerNoon](https://hackernoon.com/inside-jev-how-decision-models-trade-text-generation-for-typed-calibrated-answers)
- Eevo: per-stakeholder best option, calibrated probability per option, audit record of conflicts — [press release](https://www.uprightproject.com/blog/p/first-consequential-decision-model-launched-press-release/)

### Inferences (design ideas for AnnieOS, mine, not from sources)
- Router/orchestrator pattern: have a small local model emit a constrained JSON (enum action + per-option probability) via grammar-constrained decoding, instead of free text; threshold on confidence to escalate to a bigger model or ask the user.
- For consequential actions (send email, spend money, delete files): list options, stakeholders (user, third parties), consequences; score expected value per stakeholder; log the rationale as an audit trail. Pairwise comparison of consequences is a cheap, implementable harness around any local LLM.
- Calibrate with a held-out set of own routing decisions; vendors' calibration claims are unverified.
- A Ryzen AI Max+ 395 with 64-128 GB can host a mid-size local LLM for this, so no need for Eevo itself.

### Gaps
- No evidence the pairwise-EV harness beats a plain structured-output prompt on a strong local model; untested.

## Spellings tried and closest non-matches
Tried: "EEVO-1", "Eevo", "Eevo-1", "EVO-1", "Evo 1", "Valohai EEVO-1", "Hugging Face eevo". Not this: Arc Institute Evo / Evo 2 (DNA models; [GitHub](https://github.com/evo-design/evo/)); Evo-1 VLA robotics model from MINT-SJTU ([arXiv 2511.04555](https://arxiv.org/abs/2511.04555)); GMKtec EVO-X2 (hardware); Cambridge Audio evo one; Valohai itself (MLOps, no such model). Closest real match and likely the intended product: Upright Project's Eevo-1 (above); closest competitor named on slide: TypeSafe AI's Jev.
