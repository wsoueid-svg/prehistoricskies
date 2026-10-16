# Local LLM stack for AnnieOS (Strix Halo, Oct 2026): fact-check of the "How to run an LLM locally" infographic

Research date: 2026-10-16. Limits of this pass: ollama.com, rocm.docs.amd.com, morphllm.com were unreachable from the sandbox (DNS failure), so Ollama library tags and AMD docs were NOT read directly. Model existence/licences below were verified on Hugging Face via the HF connector where marked "HF-verified". Web-search summaries are secondary sources and are flagged. Memory figures labelled "estimate" are my own arithmetic, not sourced.

## 1. Which open-weight models lead per role (Oct 2026), and is "gemma4" real?

### Takeaway
"gemma4" is real (Gemma 4, Apache 2.0, HF-verified). The infographic's "qwen3:8b" is two generations stale: the Qwen3.5 (Feb 2026), Qwen3.6 (Apr 2026) and Qwen3.8 (Aug 2026) families exist on HF, mostly Apache-2.0 and natively multimodal. For a 64/128 GB box the sweet spot is 27-35B dense/MoE models for chat and 80-120B MoE for heavy work. Caveat: I could not read ollama.com, so I could not confirm exact Ollama tags (e.g. `gemma4`, `qwen3.6`) exist; confirm with `ollama list`/library before printing.

### Cited Findings
- Gemma 4 exists: HF repos google/gemma-4-31B-it, gemma-4-26B-A4B-it (MoE), gemma-4-E4B-it, gemma-4-E2B-it, and gemma-4-12B(-it) (added 23 May 2026); all tagged license:apache-2.0; E-series and 12B are "any-to-any"/multimodal, 31B and 26B-A4B are image-text-to-text — [HF google/gemma-4-31B-it](https://hf.co/google/gemma-4-31B-it), [26B-A4B-it](https://hf.co/google/gemma-4-26B-A4B-it), [12B-it](https://hf.co/google/gemma-4-12B-it), [E4B-it](https://hf.co/google/gemma-4-E4B-it)
- Gemma 4 launch reported as 2 Apr 2026 with E2B (2.3B effective), E4B (4.5B effective), 26B MoE (~4B active; one source says 3.8B), 31B dense; context 128K (E-series) / 256K (26B, 31B); licence switched from Gemma Terms of Use to Apache 2.0; available on Ollama — [TechWyse](https://www.techwyse.com/news/ai-search/google-deepmind-gemma-4-open-models-apache-2-0-release), [DataNorth](https://datanorth.ai/news/google-releases-gemma-4-open-models). Conflict: HF "Created" dates for the repos are Mar 2026 (likely repo creation before public launch); the news date is 2 Apr.
- Qwen3.5 family on HF (Apache-2.0, multimodal image-text-to-text): 0.8B, 2B, 4B, 9B, 27B (dense), 122B-A10B, 397B-A17B (MoE); created Feb 2026 — [HF Qwen3.5-9B](https://hf.co/Qwen/Qwen3.5-9B), [Qwen3.5-122B-A10B](https://hf.co/Qwen/Qwen3.5-122B-A10B), [Qwen3.5-27B](https://hf.co/Qwen/Qwen3.5-27B)
- Qwen3.6: 35B-A3B (MoE, ~3B active, created 15 Apr 2026) and 27B dense (21 Apr 2026), Apache-2.0 — [HF Qwen3.6-35B-A3B](https://hf.co/Qwen/Qwen3.6-35B-A3B), [Qwen3.6-27B](https://hf.co/Qwen/Qwen3.6-27B); secondary confirmation [Gigazine](https://gigazine.net/gsc_news/en/20260423-qwen-3-6-27b/)
- Qwen3.8 (newest): Qwen3.8-27B (5 Aug 2026, Apache-2.0, 7.5M downloads, very high likes), plus Qwen3.8-Flash-Next (24 Aug 2026, license:other, not Apache) and a 2.4T-A95B giant (license:other) — [HF Qwen3.8-27B](https://hf.co/Qwen/Qwen3.8-27B), [Flash-Next](https://hf.co/Qwen/Qwen3.8-Flash-Next), [2.4T-A95B](https://hf.co/Qwen/Qwen3.8-2.4T-A95B). Note: "other" licences need reading before commercial use.
- Qwen3-Coder-Next (80B-A3B, Apache-2.0, 30 Jan 2026; official GGUF exists) — [HF](https://hf.co/Qwen/Qwen3-Coder-Next), [GGUF](https://hf.co/Qwen/Qwen3-Coder-Next-GGUF)
- gpt-oss-20b and gpt-oss-120b exist, Apache-2.0, MXFP4 native, Aug 2025 (so >12 months old, still widely recommended; guides still call gpt-oss:20b the best ~16 GB option) — [HF gpt-oss-120b](https://hf.co/openai/gpt-oss-120b), [gpt-oss-20b](https://hf.co/openai/gpt-oss-20b), [guide roundup](https://computingforgeeks.com/ollama-models-cheat-sheet/). Also gpt-oss-safeguard-20b/120b (Sep 2025, Apache-2.0) usable as a policy/safety classifier — [HF](https://hf.co/openai/gpt-oss-safeguard-20b)
- Mistral Small 4: 119B MoE (~6B active per secondary sources), merges Magistral reasoning + Pixtral vision + Devstral coding, multilingual incl. Spanish (es tag on HF), reported Apache-2.0; HF repo mistralai/Mistral-Small-4-119B-2603 — [HF](https://hf.co/mistralai/Mistral-Small-4-119B-2603), [Serenities AI](https://serenitiesai.com/articles/mistral-ai-models-2026-complete-guide). Licence and active params are from secondary sources; verify on the model card. Mistral Medium 3.5 (May 2026) reportedly modified-MIT licence — same caveat.
- Other names seen only in secondary roundups (NOT verified on HF/Ollama by me): GLM-5.1, Kimi K2.6/K2.7 Code, Laguna XS 2.1, "Qwen 3.6 27B as leading consumer model" — [MorphLLM via search snippet](https://www.morphllm.com/best-ollama-models) (SEO-style, conflicting; treat as unverified). Nemotron-3 Nano 30B-A3B (MXFP4, ~17.6 GiB) appears in a Strix Halo benchmark table — [visorcraft](https://github.com/visorcraft/strix-halo-llm-perf).
- Embeddings/reranker: Qwen3-Embedding (up to 8B, flexible 32-4096 dims) and Qwen3-Reranker (0.6B/4B/8B) cited as top multilingual picks; BGE-M3 + bge-reranker-v2-m3 (Apache-2.0) as the safe self-hosted stack — [SiliconFlow guide](https://www.siliconflow.com/articles/best-reranker-model-for-document-retrieval), [FutureAGI](https://futureagi.com/blog/best-rerankers-for-rag-2026/), [Netways](https://nws.netways.de/en/blog/2026/02/25/new-managed-ai-models/). Vendor-authored; Querit-Reranker-4B claims top MTEB-multilingual rerank score (self-reported, Aug 2026) — [AlphaNeural](https://app.alphaneural.io/assets/Querit/Querit-4B).
- Speech-to-text: nvidia/parakeet-tdt-0.6b-v3 exists on HF with `es` tag among its languages (25 European languages); Whisper large-v3 (99+ languages, ~7.4% avg WER per one source) is the broad fallback; Whisper large-v3-turbo/Distil for speed — [HF parakeet](https://hf.co/nvidia/parakeet-tdt-0.6b-v3), [Gladia](https://www.gladia.io/blog/best-open-source-speech-to-text-models), [OpenWhispr](https://openwhispr.com/de/blog/parakeet-vs-whisper-vs-nemotron)
- TTS: Kokoro (82M, Apache-2.0) is the top-rated open lightweight TTS in one guide — [tts.ai](https://tts.ai/blog/open-source-text-to-speech-guide-2026/?lang=ru). Lemonade bundles Kokoro and whisper.cpp — [Lilting](https://lilting.ch/en/articles/amd-lemonade-local-ai-gpu-npu-server)

### Inferences
- Suggested roles (from the verified list; benchmarks not independently checked): router/classifier 1-4B = Qwen3.5-4B or Gemma 4 E4B (both Apache, multimodal); everyday chat+tools 8-35B = Qwen3.6-35B-A3B (fast MoE) or Qwen3.8-27B / Gemma 4 26B-A4B / 31B; heavy/reasoning/agents = gpt-oss-120b or Qwen3.5-122B-A10B or Mistral Small 4 (EU-origin, good for a Spain/EU pitch); coding = Qwen3-Coder-Next 80B-A3B; vision = Qwen3.5/3.6/Gemma 4 natively (no separate VL model needed); embeddings = Qwen3-Embedding or bge-m3; reranker = Qwen3-Reranker-0.6B/4B or bge-reranker-v2-m3; STT = Parakeet v3 (speed, Spanish supported) with Whisper large-v3(-turbo) fallback; TTS = Kokoro (check Spanish voices) or other; wake word = see Gaps.
- Prefer Apache-2.0 models for resale. Avoid Qwen3.8-Flash-Next and 2.4T models without legal review (licence "other").
- Qwen3 era (qwen3:8b) is obsolete as the headline example; Qwen3.5-9B/Gemma 4 E4B/12B are the modern equivalents.

### Gaps
- Could not read ollama.com to verify exact Ollama tags/sizes; no Artificial Analysis / LMArena data fetched, so "leader" rankings are download/like popularity plus roundups, not benchmark-verified.
- Reasoning-specific leaders (DeepSeek V3.x/R-series, GLM, Kimi) not verified; DeepSeek/GLM/Kimi are too large for 128 GB at useful quants except small variants — not checked.
- Wake-word: no sourced finding (openWakeWord / Porcupine / microWakeWord unverified). Spanish TTS quality unverified. Llama (Meta) current status not researched.
- Not checked for EU AI Act / licence acceptable-use differences beyond HF licence tags.

## 2. MoE and unified memory on Strix Halo; real tokens/second

### Takeaway
Token generation is memory-bandwidth-bound (Strix Halo ~256 GB/s LPDDR5X-8000, from general knowledge, not sourced here), so MoE models with ~3-5B active params run 5-10x faster than dense models of similar size. Measured: Qwen3-30B-A3B ~86 t/s, gpt-oss-120b ~53 t/s, Qwen3-Coder-Next 80B-A3B ~43 t/s, but dense 32B only ~11 t/s and dense 70B ~5 t/s.

### Cited Findings
- Single-host llama-bench on Ryzen AI Max+ 395 (pp512 / tg128 t/s): Llama 3.2 3B Q8 2248/60.9; Qwen2.5 14B Q4_K_M 600/24.5; Qwen3 30B-A3B Q4_K_M (Vulkan RADV) 1142/86.1; Qwen2.5 32B Q4_K_M 242/11.3; Llama 3.1 70B Q4_K_M 81.6/5.1; Qwen3-Coder-Next 80B-A3B Q4_K_M (45 GiB) 531/42.7; GPT-OSS 120B Q4_K_M (58.5 GiB, llama-server) 120/53.4; Nemotron-3 Nano 30B-A3B MXFP4 112/61.5; Qwen3-235B-A22B Q3_K_M (105 GiB) 101/17.2; MiniMax M2.5 Q3_K_M 156/32.8 — [visorcraft/strix-halo-llm-perf](https://github.com/visorcraft/strix-halo-llm-perf) (single-user community repo; dates mostly not stated, latest finding 3 Mar 2026; llama.cpp version not given)
- Other reports: gpt-oss-120b 34 t/s (Hardware Corner, Oct 2025), ~54.5 Vulkan / 49 ROCm on EVO-X2; Qwen3-30B-A3B 75-100 t/s depending on setup; dense 70B 4-7 t/s — [search summary of Level1Techs/OpenBenchmarking/Codersera](https://forum.level1techs.com/t/strix-halo-llm-inference-notes/249466), [OpenBenchmarking](https://mail.openbenchmarking.org/result/2602150-NE-STRIXHALO14&grr&export=html)
- Backend: Vulkan RADV usually best for token generation, ROCm better for prompt processing (pp ~500-580 vs ~358 for Qwen3-Coder-Next); one source: Vulkan ~25% faster tg, ROCm better for heavy prompt ingestion — [visorcraft](https://github.com/visorcraft/strix-halo-llm-perf), [search summary](https://codersera.com/blog/amd-strix-halo-ryzen-ai-max-local-llm-setup-2026/)
- Two-node RPC: Qwen3.5-397B-A17B Q4_K_XL ~11.8 tg across two machines — [visorcraft](https://github.com/visorcraft/strix-halo-llm-perf)
- Newer Qwen3.5/3.6/3.8 models on Strix Halo: no tokens/s found.

### Inferences
- Rough expectation (estimate, not measured): Qwen3.6-35B-A3B similar to Qwen3-30B-A3B (~70-90 t/s Q4); Gemma 4 26B-A4B in the same band; dense 27B/31B Q4 ~10-13 t/s (bandwidth-limited), so for interactive use prefer MoE; dense 27B only if quality matters more than speed.
- For prompt-heavy RAG/document Q&A, pp speed (hundreds of t/s) matters as much as tg; long prompts of 20K tokens take tens of seconds.
- 64 GB: 120B-class MoE (~58 GiB) does not leave room for context+OS; 128 GB is required for gpt-oss-120b/Mistral Small 4/Qwen3.5-122B with a second small model loaded.

### Gaps
- No benchmarks dated Jul-Oct 2026; no Qwen3.5/3.6/3.8/Gemma 4 numbers; concurrency (multi-user) throughput on Strix Halo unmeasured.

## 3. Runtime comparison and pitfalls

### Takeaway
Ollama is the easiest and fine for a single-user appliance, wrapping llama.cpp; for a product, llama.cpp `llama-server` (or Lemonade, AMD-sponsored, which orchestrates llama.cpp ROCm/Vulkan, FastFlowLM for the NPU, whisper.cpp, Kokoro) gives more control over backend and flags. vLLM is for many concurrent users, mostly on discrete NVIDIA/ROCm GPUs; not the natural pick for a Strix Halo mini PC.

### Cited Findings
- Ollama official FAQ: default context 4096 tokens (change with OLLAMA_CONTEXT_LENGTH or num_ctx); models stay loaded 5 min (OLLAMA_KEEP_ALIVE, or per-request keep_alive; negative = forever, 0 = unload); OLLAMA_NUM_PARALLEL default 1; OLLAMA_MAX_LOADED_MODELS default 3 per GPU (CPU: 3) if memory fits; default bind 127.0.0.1:11434; flash attention automatic where supported (OLLAMA_FLASH_ATTENTION); KV cache type OLLAMA_KV_CACHE_TYPE f16 default, q8_0 ~half memory, q4_0 ~quarter — [Ollama FAQ (GitHub raw)](https://raw.githubusercontent.com/ollama/ollama/main/docs/faq.mdx). The fetched text may be a snapshot and the 4096 default may have changed in recent releases (I did not see release notes); verify.
- Ollama is built on llama.cpp; llama.cpp is typically fastest raw with the same GGUF/backends; Ollama easiest API; LM Studio = GUI + OpenAI-compatible server, not headless-friendly per one source; vLLM far better at many concurrent users (reports range 6x to 16-20x aggregate throughput at 50 users on an RTX 4090) — [Codersera](https://codersera.com/blog/ollama-vs-lm-studio-vs-vllm-vs-llama-cpp-vs-mlx-2026/amp/), [PopularAI](https://www.popularai.org/p/llama-cpp-vs-ollama-vs-lm-studio-speed). Blog-quality, methodology unclear.
- Lemonade: OpenAI-compatible; ROCm backend targets gfx1151; FastFlowLM runs models on XDNA2 NPU (Linux setup needed building from source per one author; Docker NPU flag beta); one developer says raw perf equals llama.cpp, gain is setup convenience — [Lilting](https://lilting.ch/en/articles/amd-lemonade-local-ai-gpu-npu-server), [Sleeping Robots](https://sleepingrobots.com/dreams/lemonade-server-npu-strix-halo/)
- Strix Halo memory: keep BIOS UMA/VRAM carve-out small (AMD advises ~0.5 GB) and raise GTT limit (default ~50% of RAM; set via amdgpu.gttsize or TTM pages_limit, which is counted in PAGES); with default allocation one user's ROCm saw only ~4 GB; disable mmap for ROCm loads; llama-swap/ROCm multi-model loading hit OOM when both models should fit; Vulkan shared-memory leak and ROCm stability issues reported — [Level1Techs](https://forum.level1techs.com/t/rocm-can-only-use-half-of-the-unified-memory-on-my-strix-halo/253152), [Framework community](https://community.frame.work/t/ryzen-ai-max-395-how-should-i-configure-the-gpu-vram-from-the-bios-settings/76753), [AMD ROCm doc title (not read)](https://rocm.docs.amd.com/en/docs-7.2.0/how-to/system-optimization/strixhalo.html), [Codersera](https://codersera.com/blog/amd-strix-halo-ryzen-ai-max-local-llm-setup-2026/)
- Ollama-specific Strix Halo behaviour (ROCm vs Vulkan default, GTT handling): no reliable source found.

### Inferences
- Product recommendation: llama-server (Vulkan RADV default, ROCm for long-prompt jobs) or Lemonade as the engine, behind a thin gateway; use llama-swap or Ollama for model hot-swap. Ollama is acceptable for the first version if you set context, keep-alive, parallel explicitly.
- Hot-swap with a 128 GB box: keep a small always-on set (router 4B, embedder, reranker, STT) plus one big model; do not rely on Ollama's default 4096 ctx for RAG.
- Structured outputs/JSON schema and tool calling: supported by Ollama and llama-server (GBNF grammar) from my background knowledge but I did not source this; verify per model template (thinking/tool templates are a common failure point).

### Gaps
- No primary sources on structured-output/tool-calling per runtime, LM Studio Strix Halo status, Mac/MLX comparison, or Ollama AMD release notes (Oct 2026).

## 4. Is the infographic's sizing table still accurate?

### Takeaway
Roughly right for dense models on discrete GPUs, wrong for MoE and unified memory. On Strix Halo you size by total weight bytes + KV cache against the GPU-addressable pool (GTT), and speed by ACTIVE params. All figures below are my estimates (Q4_K_M ~0.6 B/param, Q5 ~0.7, Q8 ~1.06; add KV cache and ~8-10 GB for OS+other services), calibrated against measured sizes: Qwen3-30B-A3B Q4 17.3 GiB, gpt-oss-120b 58.5 GiB, Qwen3-Coder-Next 80B Q4 45 GiB ([visorcraft](https://github.com/visorcraft/strix-halo-llm-perf)).

### Cited Findings / Inferences (corrected table; estimates)
| Model | Active | Q4 | Q5 | Q8 | 64 GB box | 128 GB box |
|---|---|---|---|---|---|---|
| 4B (Qwen3.5-4B, Gemma4 E4B) | 4B | ~3 GB | ~3.5 | ~5 | yes | yes |
| 9-12B (Qwen3.5-9B, Gemma4 12B) | 9-12B | ~6-8 | ~7-9 | ~10-13 | yes | yes |
| 26-35B MoE (Qwen3.6-35B-A3B, Gemma4 26B-A4B) | 3-4B | ~17-22 | ~21-26 | ~35-38 | yes, fast | yes |
| 27-31B dense (Qwen3.8-27B, Gemma4 31B) | 27-31B | ~16-19 | ~19-22 | ~29-33 | yes, slow (~10 t/s) | yes |
| gpt-oss-120b (MXFP4) | ~5B | 58.5 GiB native | n/a | n/a | no (too tight) | yes, ~50 t/s |
| Qwen3-Coder-Next 80B-A3B | 3B | ~45 GiB | ~55 | ~85 | Q4 tight, small ctx | yes |
| 119-122B MoE (Mistral Small 4, Qwen3.5-122B-A10B) | 6-10B | ~70 | ~82 | ~125 | no | Q4 yes, no room for other big models |
| 235-400B MoE | 17-22B | Q3 ~105 GiB (235B) | - | - | no | 235B Q3 only, ~17 t/s; 397B needs 2 nodes |
- Infographic's "1-4B = 8 GB, 7-8B = 16 GB, 13-14B = 24 GB+ VRAM, 30B+ = 48 GB+, 70B+ = multi-GPU 80 GB+" is a dense-model/discrete-GPU rule. On a 128 GB Strix Halo, a 70B dense Q4 (~40 GiB) loads fine but runs ~5 t/s (measured) so is impractical, and a 120B MoE runs at ~50 t/s. Hence: sizing on unified memory = fit + speed (active params).
- GPU pool limit: set GTT high (~110-120 GB on 128 GB; ~48-56 GB on 64 GB; estimates), BIOS carve-out minimal.

### Gaps
- Estimates not benchmarked; real KV-cache size at 32K-128K context varies by architecture (hybrid/linear-attention in Qwen3-Next/3.5 lowers it) — unverified.

## 5. Other infographic claims

### Cited Findings
- Install command and `ollama run` flow: not re-verified (site unreachable); Linux installer `curl -fsSL https://ollama.com/install.sh | sh` is the long-standing documented method (background knowledge). Default API http://localhost:11434 is confirmed (bind 127.0.0.1:11434) — [Ollama FAQ](https://raw.githubusercontent.com/ollama/ollama/main/docs/faq.mdx).
- "qwen3:8b" still pullable probably but outdated; "gemma4" tag unverified on Ollama but model confirmed on HF and reported as available on Ollama — [DataNorth](https://datanorth.ai/news/google-releases-gemma-4-open-models).
- "No per-token cost, offline, privacy": valid; but note hardware cost, and tool-calling agents widen the attack surface (see section 6).

### Inferences
- Replace example with `ollama pull qwen3.5:9b` / `gemma4` / `gpt-oss:120b` only after confirming tags.

### Gaps
- Use-case list not fact-checkable; it is generic.

## 6. Security/hardening for a business appliance

### Takeaway
Ollama has no built-in authentication; default bind is loopback. Keep it on 127.0.0.1 and expose only an authenticating reverse proxy or private mesh (WireGuard/Tailscale). Do not set OLLAMA_HOST=0.0.0.0 without a gateway; Docker publishing can bypass host firewall rules.

### Cited Findings
- No built-in auth; bind to loopback; use nginx/Caddy with TLS + auth, or oauth2-proxy/Authentik, or WireGuard/Tailscale; Ollama's own CORS docs say extra security (proxy, authentication) is needed when binding 0.0.0.0 — [Twingate](https://www.twingate.com/blog/ollama-server-exposure), [Centron](https://www.centron.de/tutorials/expose-ollama-network-port-hardening), [Serverman](https://serverman.co.uk/ai/ollama/ollama-security-guide/)
- ~175,000 exposed Ollama hosts across 130 countries reportedly found by SentinelOne/Censys scan (293 days, early 2026), nearly half with tool calling enabled — [Elest.io](https://blog.elest.io/175-000-ollama-servers-are-wide-open-right-now-is-yours-one-of-them/) (secondary; primary report not read)
- Docker `-p 11434:11434` bypasses firewall rules — [Twingate](https://www.twingate.com/blog/ollama-server-exposure)
- Check exposure with `ss -tlnp | grep 11434` plus an external reachability test — [Twingate](https://www.twingate.com/blog/ollama-server-exposure)

### Inferences
- Appliance design: LLM engine bound to 127.0.0.1/Unix socket; AnnieOS backend is the only client; per-tenant API keys at a proxy; rate limits; TLS; systemd hardening; no tool execution without allow-lists; log prompts carefully (GDPR); keep model files integrity-checked.

### Gaps
- No Ollama CVE list for 2026 reviewed; no GDPR/AI Act compliance sources gathered.
