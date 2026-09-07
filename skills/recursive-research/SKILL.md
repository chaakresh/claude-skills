---
name: recursive-research
version: 2.2.0
author: Joseph Huayhualla (@Anjos2)
license: MIT
repository: https://github.com/Anjos2/recursive-research
description: Deep recursive research with a self-regulating loop that iterates to PhD level. Works in any domain (science, technology, business, art, humanities). Uses a Weighted Decision Matrix plus Munger inversion for autonomous decisions, tiering of trustworthy sources, and checkpointing to disk to survive context limits. Use when the user wants to go deep on a topic, understand a new field before deciding, prepare a technical paper or proposal, or map state of the art and knowledge gaps.
---

# Skill: Deep Recursive Research (v2.0)

Self-regulating research that iterates until it reaches **PhD level** on a research seed (root topic). Works in any domain: formal, natural and social sciences, humanities, the arts, technology, business.

## When to use

- You want to go deep on a topic until you reach expert level
- You need to understand a new field in order to make informed decisions
- You are preparing a technical document, paper, proposal or study
- You want to identify the state of the art plus knowledge gaps

## Principles

1. **Ask before researching** — the skill interrogates the user about seed, mode and sources BEFORE starting
2. **Trustworthy sources with transparent tiering** — automatically rejects unreliable sources
3. **WDM + Munger inversion** on every non-trivial autonomous decision
4. **Self-regulating loop** — no fixed iteration count; a measurable criterion decides when to stop
5. **Defensive checkpointing** — write to disk every cycle; survives compaction and session close
6. **Preventive pause** — detects proximity to the context limit and suggests pausing before a forced cutoff

Throughout this skill, **WDM** means Weighted Decision Matrix: score each candidate against weighted criteria and take the top scorers. **Munger inversion** means asking what you are missing or getting wrong, rather than confirming what you already have.

---

## Full flow

### Phase 0 — Opening questions (the skill interrogates)

When `/recursive-research` is invoked, the skill asks the user, in order:

1. **Research seed**: "What is the topic you want to research?" (free text)
2. **Mode**: `web` / `local` / `mixed`
3. **If local is included**: "Which local paths should I research?" (comma-separated list of paths)
4. **Prioritised sources** (optional): preferred authors, domains, publications
5. **Excluded sources** (optional)
6. **Hard cycle cap** (default: 20; configurable)

The skill presents a summary and waits for confirmation before starting.

---

### Phase 1 — Prepare the workspace

1. Generate a `slug` from the seed (kebab-case, max 40 characters)
2. Verify / create `memory/research/<slug>/` in the current working directory
   - **If `memory/` does NOT exist, create it** and explain: *"There is no `memory/` folder in this project. I am creating it because the skill needs to consolidate findings to disk every cycle — that is what allows the research to resume in a new session."*
3. Create the initial files:
   - `state.md` — metadata, progress, metrics
   - `threads.md` — tree of seed threads and sub-threads
   - `sources-tier-1.md`, `sources-tier-2.md`, `sources-tier-3.md`, `sources-rejected.md`
   - `findings.md` — consolidation

---

### Phase 2 — Identify seed threads

Generate **3-5 seed threads** (distinct angles on the topic).

**Apply WDM to thread selection**:

| Criterion | Weight | What it evaluates |
|---|---|---|
| Conceptual coverage | 4 | Does it cover a distinct dimension of the topic? |
| Diversity of perspective | 3 | Does it bring different voices / schools of thought? |
| Source accessibility | 3 | Do Tier 1/2 sources exist for this thread? |
| Relevance to the user | 4 | Does it align with the goal that motivated the research? |

Evaluate 5-8 candidate threads, select the top 3-5.

**Munger inversion on the chosen threads**:
- Which important thread am I ignoring?
- Which absent perspective would make my research one-sided?
- Which school of thought or dissenting voice is missing?

If the inversion reveals a critical missing thread, add it and re-run the WDM.

**Examples by domain** (NOT only code):

| Domain | Seed | Typical threads |
|--------|------|-----------------|
| Science | Cancer immunotherapy | Molecular mechanisms / Clinical trials / History and evolution / Controversies and limitations / Commercial status |
| Art | Minimalism in 20th-century music | Key composers / Techniques / Historical and cultural context / Criticism and reception / Landmark works |
| Business | B2B SaaS monetisation models | Pricing strategies / Financial metrics / Documented cases / Legal framework / B2B buying psychology |
| Humanities | Modern applied Stoic philosophy | Primary sources (Epictetus, Seneca, Aurelius) / Contemporary interpretations / Practical applications / Philosophical critiques / Empirical psychological evidence |
| Technology | Hexagonal architecture in microservices | Theoretical foundations / Implementations per language / Real-world cases / Trade-offs and critiques / Tooling |

---

### Phase 3 — Detect available tools

Before the first cycle, detect available MCPs and order them by preference:

**Preference (fastest and most effective first)**:

1. **AI-optimised scraping MCPs**: Firecrawl (`firecrawl_scrape`, `firecrawl_crawl`, `firecrawl_search`, `firecrawl_extract`) — structured text, fast
2. **Official documentation MCPs**: Context7 (`query-docs`) — when the source is a library or framework
3. **Native tools**: `WebSearch`, `WebFetch` — universal fallback
4. **Real-browser MCPs (Chrome DevTools)**: DEPRIORITISED — only when the content genuinely requires JS execution (SPAs without SSR, content behind auth)

Reason: AI scrapers are 10-50x faster than real browsers and return text that is already structured.

---

### Phase 4 — Suggested seed sources

The skill presents the user with a list of seed sources **pre-loaded by domain**, to **confirm, extend or reject**:

**General science / papers**:
- arXiv (https://arxiv.org) — preprints in physics, mathematics, CS, biology, economics
- Semantic Scholar (https://www.semanticscholar.org) — citation network
- Google Scholar (https://scholar.google.com)
- Connected Papers (https://www.connectedpapers.com) — visual citation maps
- OpenReview (https://openreview.net) — open peer review in ML

**Medicine / biology**:
- PubMed (https://pubmed.ncbi.nlm.nih.gov)
- Cochrane Library (https://www.cochranelibrary.com) — meta-analyses
- WHO (https://www.who.int)
- ClinicalTrials.gov

**Humanities / social sciences**:
- JSTOR (https://www.jstor.org)
- SSRN (https://www.ssrn.com)
- Project MUSE (https://muse.jhu.edu)

**Code / technology**:
- GitHub (search, topics, experts' starred lists)
- Context7 for official docs (if the MCP is available)
- RFCs (https://www.rfc-editor.org)
- W3C specs (https://www.w3.org/TR/)

**Data / statistics**:
- World Bank (https://data.worldbank.org)
- OECD Data (https://data.oecd.org)
- Our World in Data (https://ourworldindata.org)
- Pew Research (https://www.pewresearch.org)
- Eurostat, national statistics institutes, and equivalents

**Art / culture / humanities**:
- Europeana (https://www.europeana.eu)
- Google Arts & Culture (https://artsandculture.google.com)
- Internet Archive (https://archive.org)
- Project Gutenberg (https://www.gutenberg.org)

**General**:
- Wikipedia — as a STARTING POINT only. Always jump to the **references** section to reach Tier 1/2
- Wikidata — structured data

**Local sources** (if the user supplied paths):
- List the folder structure
- Prioritise `.md`, `.pdf`, `.txt`, `.doc/.docx`, `.html`, `.epub`
- Use the agent's reading tools (Read, Grep, Glob)

---

### Phase 5 — Research cycle (self-regulating LOOP)

Each cycle runs the following sub-steps.

#### 5.1. Pick the thread with the lowest coverage

Compute current coverage per thread (`findings_recorded / expected_findings_proxy`). Pick the lowest percentage.

#### 5.2. WDM + Munger on the sources to use in THIS cycle

**WDM per candidate source**:

| Criterion | Weight | Scale |
|----------|------|--------|
| Authority (Tier) | 5 | Tier 1 = 5 · Tier 2 = 3 · Tier 3 = 2 · Rejected = 0 |
| Relevance to the current thread | 5 | 1-5 by semantic match |
| Accessibility | 3 | 5 = open full text · 3 = abstract + paywall · 1 = blocked |
| Recency appropriate to the field | 2 | Code: recent > old · Classical philosophy: old = relevant |
| Absence of conflict of interest | 3 | 5 = independent · 1 = funded by an interested party |

Select the top 3-5.

**Munger inversion on the selected sources**:
- Which source am I NOT using that I should be? (dissenters, critical schools, silenced voices)
- Which bias do all the selected sources share? (only Anglophone, only one era, only one school)
- Which documented contrary opinion exists? -> Add at least 1 contradictory source if one exists

#### 5.3. Run the searches / readings

- Use MCPs in the preference order detected in Phase 3
- Extract: concrete facts, numerical data, verbatim quotes with attribution, names of new people/works/concepts
- Record in the cycle's working notes

#### 5.4. Apply tiering to every source consulted

**Tier 1 — Maximum confidence**:
- Peer-reviewed papers in indexed journals (Scopus, Web of Science, PubMed, ACM, IEEE)
- Books from academic presses (MIT Press, Oxford UP, Cambridge UP, Springer)
- Official standards documentation (W3C, IETF/RFC, ISO, IEEE, WHO, FDA, BIS)
- Verifiable primary archives (national museums, university libraries, state archives)
- Raw data from official statistical institutions

**Tier 2 — High confidence**:
- Official repositories of active, recognised projects
- Blogs and publications by citable authors (researchers, practitioners with a verifiable track record)
- Talks at recognised conferences (with video and paper)
- Wikipedia *WITH* references to Tier 1/2 (treat it as a reference aggregator)
- Think tank / consultancy reports with published methodology (Pew, Gartner, McKinsey Institute)

**Tier 3 — Useful with caution**:
- Blogs with internal citations to Tier 1/2
- Stack Overflow / forums with high vote counts plus citations
- Recorded interviews with identifiable experts
- Industry publications with clear authorship

**Automatic rejection**:
- No identifiable author
- Marketing without empirical data
- Spam / SEO aggregators
- Tutorials that cite no sources
- Social media without verifiable context
- AI-generated content with no documented human oversight

Every source consulted is recorded in its corresponding tier file with: title, URL, author, date, tier assigned, justification.

#### 5.5. Consolidate into a checkpoint

At the end of the cycle, write `memory/research/<slug>/cycle-N.md` containing:
- Thread worked on
- Sources consulted (with tier)
- New findings
- Connections to previous threads
- Open questions for upcoming cycles

#### 5.6. Update `state.md`

- Increment the cycle counter
- Recompute coverage per thread
- Record the saturation metric: `saturation = new_findings_this_cycle / total_accumulated_findings`
- Update the estimate of tool calls and output tokens consumed

#### 5.7. Evaluate stopping criteria — the "PhD level" fitness function

All 5 criteria MUST be met:

1. **Coverage >=80%** across all seed threads
2. **>=3 Tier-1 sources per thread** (or Tier 1+2 combined if the field has few Tier 1 sources)
3. **Saturation <=5%** for 3 consecutive cycles
4. **Munger inversion applied to the state of knowledge**: documented what I do NOT know, where sources contradict each other, which biases I detected
5. **Cross-thread synthesis**: >=3 explicit connections between different threads recorded

**Decision**:
- All met -> Phase 6 (natural close)
- Cycle cap reached -> Phase 6 (forced close, with notice)
- Otherwise -> continue to step 5.8

#### 5.8. Preventive pause (context check)

Thresholds:
- `tool_calls_this_session >= 150`
- **OR** `approx_output_tokens >= 80000`

If either is crossed:

1. Write a full checkpoint (5.5 + 5.6)
2. Emit the message:

```
[PREVENTIVE PAUSE RECOMMENDED]

Current state:
- Cycles completed: N
- Tool calls this session: X (near the limit)
- Approximate output tokens: Y

Reason: I am approaching the context limit. If I continue, I could lose
coherence when the session is compacted.

The research is saved in:
  memory/research/<slug>/

To resume in a new session:
  /recursive-research --resume <slug>

Pause here, or continue for 1-2 more cycles? (continue / pause)
```

3. Wait for a reply. On `continue`, carry on. On `pause`, jump to Phase 6 (documented partial close).

If the threshold is not crossed -> return to 5.1 for the next cycle.

---

### Phase 6 — Close

Whether the close is natural (5 criteria met), forced (cycle cap), or partial (manual pause):

1. **`synthesis.md`** — executive synthesis:
   - Plain-language summary (3-5 paragraphs)
   - Findings per thread with cross-references
   - Controversies and contradictions detected
   - Knowledge gaps (what was NOT researched / what remains open)
   - Map of the threads followed (tree)

2. **`actions.md`** — checklist of applicable actions, prioritised by impact

3. **FINAL Munger inversion on the state of knowledge** (record in `gaps.md`):
   - What do I still not know?
   - Which sources contradicted each other without my resolving it?
   - What bias does my set of sources carry?
   - What question would a critical reviewer ask that I could not answer?

4. **Ask the user**:

```
[RESEARCH COMPLETE — status: natural / forced / paused]

Seed: <topic>
Cycles run: N / <cap>
Sources consulted: X total (T1: A · T2: B · T3: C · Rejected: D)
PhD status: reached / NOT reached (reasons: ...)

Gaps identified:
  1. ...
  2. ...
  3. ...

Options:
  1. Close here
  2. Go deeper on a specific gap (say which)
  3. Add a new thread and continue
  4. Change mode (web -> mixed, etc.)

What would you prefer?
```

**The research can be infinite** — it only closes when the user decides.

---

## `--resume` mode

Invocation: `/recursive-research --resume <slug>`

1. Look for `memory/research/<slug>/`
2. If it does not exist -> clear error, suggest plain `/recursive-research`
3. If it does exist:
   - Read `state.md` -> rebuild the metrics
   - Read the latest `cycle-N.md` -> recent context
   - Read `threads.md` -> current tree
   - Present: "Resuming from cycle N. Next step: [thread X]. Continue?"
4. Continue the loop from Phase 5

---

## `--list` mode

Invocation: `/recursive-research --list`

List every saved research project under `memory/research/` in the current project:
- Slug · Seed · Cycles completed · Status (open / closed) · Last modified

---

## Anti-patterns to actively reject

1. **Flat search** — repeating queries with synonyms without going deeper into the actual results
2. **Ignoring Munger** — selecting sources purely for comfort; the inversion is mandatory
3. **Missing checkpoint** — advancing 5 cycles without dumping to disk
4. **Tier 3 without references** — accepting a blog that does not explicitly cite Tier 1/2
5. **Self-certifying the PhD** — declaring PhD level without measuring the 5 criteria; if one is missing, do NOT close
6. **Ignoring gaps** — closing without documenting what is not known; the gaps are part of the deliverable
7. **Intellectual condescension** — hiding controversies or contradictions "to keep the synthesis clean"; intellectual honesty IS the result
8. **Blindly trusting internal knowledge** — the agent's knowledge may be out of date; always verify against a source

---

## Final structure of generated files

```
memory/research/<slug>/
├── state.md              ← progress, metrics, metadata
├── threads.md            ← tree of threads and sub-threads with status
├── sources-tier-1.md     ← most trustworthy sources consulted
├── sources-tier-2.md     ← high-confidence sources
├── sources-tier-3.md     ← sources to treat with caution
├── sources-rejected.md   ← sources evaluated and discarded (with reason)
├── findings.md           ← consolidation of discoveries
├── cycle-01.md           ← checkpoint for cycle 1
├── cycle-02.md
├── cycle-N.md
├── synthesis.md          ← executive synthesis (Phase 6)
├── actions.md            ← checklist of applicable actions
└── gaps.md               ← what is NOT known, controversies, biases
```

---

## Example invocation

```
User: /recursive-research

Skill: What is the topic you want to research?
User: Mechanisms of episodic memory in humans

Skill: Mode? (web / local / mixed)
User: mixed

Skill: Local paths?
User: C:/Dropbox/neuroscience-papers

Skill: Prioritised sources / authors? (optional)
User: Endel Tulving, Eleanor Maguire

Skill: Excluded sources? (optional)
User: -

Skill: Cycle cap? (default 20)
User: 25

Skill: Confirmed.
       Seed: "episodic memory in humans"
       Mode: mixed · Local: [C:/Dropbox/neuroscience-papers]
       Prioritise: [Tulving, Maguire] · Cap: 25 cycles

       Applying WDM + Munger to identify seed threads...
       [shows table]

       Selected threads:
       1. Neuroanatomical basis (hippocampus, PFC)
       2. Phenomenology and taxonomy (Tulving et al.)
       3. Disorders and dissociations (amnesia, Alzheimer's)
       4. Computational models
       5. Contemporary cognitive neuroscience

       The `memory/` folder does not exist. I am creating it — it is
       required to consolidate each cycle to disk.

       Path: memory/research/episodic-memory-humans/

       Starting cycle 1 (lowest-coverage thread: 1)...
```

---

## Authorship and licence

- **Author:** Joseph Huayhualla ([@Anjos2](https://github.com/Anjos2))
- **Licence:** MIT — see the `LICENSE` file in this directory
- **Repository:** https://github.com/Anjos2/recursive-research

Contributions welcome upstream. If you spot an anti-pattern that is not covered, a better
heuristic, or a more robust PhD criterion, open a PR on the repository above.

### Note on this copy

This is an English translation of upstream v2.2.0, which is written in Spanish. The structure,
thresholds, weights, tiering rules and stopping criteria are unchanged. The names of the files
the skill *generates* were translated too (`memoria/investigaciones/` -> `memory/research/`,
`estado.md` -> `state.md`, `hilos.md` -> `threads.md`, `hallazgos.md` -> `findings.md`,
`sintesis.md` -> `synthesis.md`, `acciones.md` -> `actions.md`, `ciclo-N.md` -> `cycle-N.md`),
so research folders created by this copy are not interchangeable with ones created by upstream.
MIT permits this derivative; the copyright notice above and in `LICENSE` is retained.
