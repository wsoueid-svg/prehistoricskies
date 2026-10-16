# Harness Learning paper (Zhang et al., 2026) and the wider harness-optimisation area

Research limits: arxiv.org, alphaxiv, x.com, startuphub.ai and the project page were unreachable from this sandbox (proxy 403 / DNS). The full paper text was NOT read. Everything about the paper comes from search-result snippets of the arXiv HTML/abstract plus secondary pages, and the GitHub README. Numbers marked "unverified" should be checked against the PDF.

## Find the actual paper: identity, date, abstract, benchmarks, headline numbers, cost, code

### Takeaway
The paper exists: arXiv 2609.35738, "Harness Learning Enables Generalizable Test-Time Adaptation", listed Sept 2026 (CMU-affiliated per one summary). A small proposer LLM is RL-trained (GRPO) to edit a frozen solver's harness code from execution reports. Code repo exists but is a "Code coming soon!" placeholder as of this check; no venue found; training compute not found.

### Cited Findings
- arXiv ID 2609.35738; Alvin Zhang first author, Andrea Zanette among co-authors (search tool could only confirm Zhang and Zanette; full author list in the brief not independently confirmed) — [arXiv abs](https://arxiv.org/abs/2609.35738), [arXiv HTML](https://arxiv.org/html/2609.35738v1)
- Listing date 2026-09-28 per an aggregator; a paper-notes issue tags it "arXiv'26, 2026.09" — [deeplearn.org](https://deeplearn.org/arxiv/832637/harness-learning-enables-generalizable-test-time-adaptation), [paper_notes #6692](https://github.com/AkihikoWatanabe/paper_notes/issues/6692)
- Abstract (paraphrased from snippets): harness = the program organising model calls, tools and information flow; "harness learning" trains a proposer model with RL to revise a solver's harness using execution feedback; framed as meta-learning over executable programs, harness edits playing the role of gradient updates; reward = task performance of revised harnesses; at test time the harness is refined with no parameter updates; experiments on reasoning and multi-hop QA show better revision quality and transfer of adaptation ability to unseen tasks — [BAAI hub abstract](https://hub.baai.ac.cn/paper/40acbea7-a35a-4401-a220-7b989cf4ec10), [arXiv HTML](https://arxiv.org/html/2609.35738v1)
- Loop: run current harness on questions -> outcomes and traces summarised into an "execution report" -> proposer reads task + current harness + execution report -> outputs a code edit/diff to the harness. Training: optional SFT then RLVR with GRPO; reward = mean grader score of the revised harness on a question set — [StartupHub summary (via search snippet)](https://www.startuphub.ai/ai-news/ai-research/2026/small-editors-learn-to-rewrite-agents-at-test-time), [arXiv HTML](https://arxiv.org/html/2609.35738v1)
- Reasoning Gym: on 21 unseen task families, single-step revision score rose from 0.32 (base proposer) to 0.62 (SFT then RL); trained 4B proposer beat its 35B teacher on average — [arXiv HTML snippet](https://arxiv.org/html/2609.35738v1) (exact table unverified)
- Multi-hop QA: proposer trained on HotpotQA transfers to MuSiQue and 2WikiMultihopQA and keeps improving harnesses over successive test-time rounds. On MuSiQue, single-step RL proposer averages 0.15 held-out EM over independent revisions; after ten revision rounds mean final score 0.27; compute/feedback not matched between approaches so compare cautiously — [arXiv HTML / summary snippet](https://arxiv.org/html/2609.35738v1) (unverified)
- Invalid edits: Appendix B.3 gives validity reward terms for Reasoning Gym; a failed edit receives only validity credit accumulated before the failure (i.e. reward shaping for syntactically valid / runnable harness) — [arXiv HTML snippet](https://arxiv.org/html/2609.35738v1)
- Code: separate repo AlvinZH04/Harness-Learning (MIT licence), README is only "Code coming soon!", 2 commits, 1 star; website repo has static site only — [GitHub code repo](https://github.com/AlvinZH04/Harness-Learning), [website repo](https://github.com/AlvinZH04/Harness-Learning-Website). Project page: https://alvinzh04.github.io/Harness-Learning-Website/ (not fetchable here)
- Social-media boost: Elvis Saravia (@omarsar0) called it a "banger paper" on improving agents by editing harness code instead of weights — [X post](https://x.com/omarsar0/status/2106529236068819394) (snippet only)

### Inferences
- The Instagram carousel's description (proposer -> edit harness.py -> frozen solver scores -> GRPO -> pick best valid harness) matches the snippets; the "harness.py" filename and "pick best valid harness" at inference are consistent with the validity-reward detail but not verified by me.
- The headline is a small (4B) proposer beating a 35B teacher at proposing edits; the solver models used and per-solver gains were not recovered.

### Gaps
- Venue/acceptance, full author list confirmation, solver model names, per-task gains, proposer training compute (GPUs/hours), rollout counts, whether harness code is evolved per-task or generalised: not found (full text unreachable).
- Code not yet released (placeholder README) as of the fetch.

## What exactly is a "harness", and what do learned edits look like?

### Takeaway
Harness = executable program (Python) wrapping the solver LLM: how it prompts, calls tools, processes information, and returns answers. Edits are code diffs produced from execution reports. Concrete example edits from the paper were not retrievable.

### Cited Findings
- Harness defined as "the program that organizes model calls, tools, and information flow" — [BAAI abstract](https://hub.baai.ac.cn/paper/40acbea7-a35a-4401-a220-7b989cf4ec10)
- Proposer output is a code edit/diff; the execution report summarises outcomes and traces — [StartupHub](https://www.startuphub.ai/ai-news/ai-research/2026/small-editors-learn-to-rewrite-agents-at-test-time)

### Inferences
- The carousel's examples (retry, output validation) are plausible instances but I could not confirm them as the paper's actual examples. Treat as illustrative.
- For multi-hop QA, harnesses likely include retrieval/query-decomposition and answer-checking logic; for Reasoning Gym, prompt/format/verification code (inference only).

### Gaps
- Actual example diffs, harness size, allowed edit scope: need the PDF appendix.

## Relation to similar work

### Takeaway
Harness learning differs from most prior work by amortising the "improver" into a trained (RL) proposer that generalises to unseen tasks, whereas ADAS/DGM/SICA/GEPA/TextGrad/Reflexion use a fixed LLM prompted to improve things per task.

### Cited Findings
- GEPA (Agrawal et al., ICLR 2026): reflective prompt evolution reading full traces, Pareto frontier of candidates; beats GRPO by 6 pp avg (up to 19 pp) over six tasks with up to 35x fewer rollouts; beats MIPROv2 by >10 pp (+12 on AIME-2025); available as dspy.GEPA and standalone — [ICLR proceedings](https://proceedings.iclr.cc/paper_files/paper/2026/hash/0e9e708b6f48e14fd0ac29e167413f76-Abstract-Conference.html), [arXiv](https://arxiv.org/html/2507.19457v1), [summary](https://www.morphllm.com/gepa-prompt-optimisation) (earlier preprint said 10% avg / up to 20% over four tasks)
- Darwin Godel Machine (Sakana): coding agent rewrites its own code, SWE-bench 20% -> 50% — secondary source only: [morphllm](https://www.morphllm.com/self-improving-ai)
- Concurrent/near-neighbour 2026 papers surfaced: TTHE Test-Time Harness Evolution (arXiv 2607.08124, unlabeled execution traces), MemoHarness (2607.14159), HarnessForge (2606.01779), Evo-Harness (2608.15071), HarnessX (2606.14249), Harness-RL (2608.29641), ClawGym II black-box RL on harness (2608.16798), "What Does Multi-Harness RL Learn?" (2609.04518), survey on self-improving test-time intelligence (2609.01679) — [TTHE](https://arxiv.org/pdf/2607.08124), [MemoHarness](https://arxiv.org/pdf/2607.14159), [HarnessForge](https://arxiv.org/pdf/2606.01779), [Evo-Harness](https://arxiv.org/pdf/2608.15071), [HarnessX](https://arxiv.org/pdf/2606.14249), [Harness-RL](https://arxiv.org/pdf/2608.29641), [survey](https://arxiv.org/pdf/2609.01679) (titles only; contents not read)

### Inferences (from background knowledge, NOT verified this session; verify before citing)
- ADAS (Hu, Lu, Clune; arXiv 2408.08435): meta-agent programs new agents in code, archive-based search. DGM (Zhang, Hu, Lu, Lange, Clune; 2505.22954): open-ended archive of self-modifying coding agents, reported SWE-bench 20->50% and Polyglot ~14->31%. SICA (Robeyns et al.; 2504.15228): self-improving coding agent editing its own code, reported SWE-bench Verified subset ~17->53%. Reflexion (2303.11366): verbal self-reflection memory. Voyager (2305.16291): growing library of verified code skills. TextGrad (2406.07496): textual "gradients" via LLM feedback. AlphaEvolve (DeepMind 2025): LLM-driven evolutionary code improvement with automated evaluators. All of these use a non-trained improver LLM; harness learning trains the improver by RL.
- Anthropic/OpenAI/"context engineering" posts on harnesses: not searched; no citations.

### Gaps
- No primary-source confirmation of ADAS/DGM/SICA numbers or Anthropic/OpenAI harness writing in this session.

## Applying it with small local models (7B-30B on 64-128GB mini PC)

### Takeaway
Full method (RL-train a proposer) is overkill. The cheap version is GEPA-style: log executions, have an LLM (same local model or an occasional stronger one) propose edits to prompts/harness code, evaluate on a held-out set of the user's own tasks, keep the winner. The paper's own finding that a 4B proposer can beat a 35B teacher at edits suggests small proposers are viable once trained, but that needs the (unreleased) code.

### Cited Findings
- GEPA/DSPy ships ready-made reflective optimisation (dspy.GEPA, standalone lib) and needs far fewer rollouts than RL (up to 35x fewer) — [ICLR](https://proceedings.iclr.cc/paper_files/paper/2026/hash/0e9e708b6f48e14fd0ac29e167413f76-Abstract-Conference.html)
- Paper's trained 4B proposer outperforms 35B teacher on average on unseen Reasoning Gym families — [arXiv HTML](https://arxiv.org/html/2609.35738v1)
- Paper's code repo is not yet usable — [GitHub](https://github.com/AlvinZH04/Harness-Learning)

### Inferences
- Practical recipe for AnnieOS: (1) log every task run with trace, tool calls, errors, user thumbs/corrections; (2) build 30-100 held-out task cases with automatic checkers (verifiable rewards); (3) summarise failures into an "execution report"; (4) ask a local model (Qwen/Llama-class 14-30B; occasionally a cloud model) to propose a diff to a bounded harness file (prompts, retry/validation wrappers, tool-call parsing, memory retrieval); (5) run candidate vs baseline on the held-out set with the same frozen solver; (6) accept only if it improves and passes validity/safety checks; keep archive for rollback (DGM-style).
- Best targets for small models: output-format validation, JSON repair, retries on tool errors, self-check steps, few-shot selection, retrieval query rewriting; these are what weak models fail at most.
- Tools: DSPy + GEPA (start here), plus a local inference server (llama.cpp/Ollama/vLLM). RL proposer training (GRPO via TRL/verl) is possible on a single GPU for ~4B models but not realistic on an iGPU mini PC (inference; hardware claim unverified).

### Gaps
- No benchmark of GEPA with 7B-30B local solvers found; no compute figures for the paper's training.

## Risks and limits

### Takeaway
Main risks: overfitting to a small eval set, reward hacking of the grader, and unsafe auto-modified code. Mitigate with sandboxing, held-out/rotating evals, and human review.

### Cited Findings
- Paper caveat: comparisons in the MuSiQue test-time results do not match total compute and feedback across approaches — [arXiv HTML snippet](https://arxiv.org/html/2609.35738v1)
- Paper includes validity reward shaping because proposed edits can be broken code — [arXiv HTML snippet](https://arxiv.org/html/2609.35738v1)

### Inferences
- Harness edits can hardcode answers/special-case eval items or weaken checkers (reward hacking); use separate validation and final test splits, hidden checks, and diff review for any change touching permissions/tools.
- Run candidate harnesses in a sandbox with no network/file-write beyond a scratch dir; restrict the editable file set; never let the optimiser edit its own evaluator.
- Gains measured on benchmarks (Reasoning Gym, Wikipedia QA) may not carry to personal-assistant tasks; the user needs their own eval set, which is the real prerequisite.

### Gaps
- Paper's own limitations section not read.
