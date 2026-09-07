# claude-skills

Personal Agent Skills, packaged as a Claude plugin so one repo serves every surface:
Claude Code, Claude Chat (web/desktop), and Cowork.

**40 skills.** Most are vendored copies of upstream repos; two are authored here — see
[Provenance](#provenance) and [Updating](#updating).

## Curated skills

| Skill | What it does | Invocation |
| --- | --- | --- |
| `market-research` | Market sizing, competitor comparisons, investor dossiers, technology scans — with source attribution and decision-oriented summaries. | automatic or `/market-research` |
| `competitor-profiling` | Turns a list of competitor URLs into structured profile documents, combining live site scraping with SEO data. Needs MCP (see below). | automatic or `/competitor-profiling` |
| `synthetic-market-research` | LLM-generated synthetic survey panels scored with Semantic Similarity Rating — purchase intent, concept tests, pricing, in minutes at $0/respondent. Needs Python deps + an LLM API key. | automatic or `/synthetic-market-research` |
| `recursive-research` | Self-regulating recursive research loop to PhD depth, with source tiering, Munger inversion, and disk checkpointing to survive context compaction. Translated to English here (see below). | automatic or `/recursive-research` |
| `academic-pptx` | Content and structure decisions for conference talks, thesis defenses, seminars, grant briefings. Needs a pptx engine (see below). | automatic or `/academic-pptx` |
| `grilling` | Relentless round-based interview that maps a plan as a design tree and stress-tests it. | automatic on "grill" phrases |
| `grill-me` | Thin trigger that hands off to `grilling`. Never auto-invokes. | `/grill-me` only |

`grill-me` is useless without `grilling` — keep them together.

`market-research` and `synthetic-market-research` both trigger on the phrase "market research" and
will compete for it. They answer different questions: the first does desk research over real
sources with attribution, the second simulates a survey panel. Name the one you want when it
matters.

## Authored here

Not vendored — these two live only in this repo, and `scripts/sync-upstream.sh` leaves them alone.

| Skill | What it does |
| --- | --- |
| `startup-cso` | Startup strategy review: challenges TAM/CAC/LTV, applies the Good Strategy Kernel, names the moat, forces explicit trade-offs. |
| `executive-deck` | Board- and investor-grade decks and memos via the Pyramid Principle and SCR, with action titles and one exhibit per slide. |
| `consulting-frameworks` | MECE issue trees, Good Strategy Kernel, Porter's Five Forces, effort-vs-value 2x2, 3 Horizons — for market entry theses and strategic evaluations. |
| `amazon-narrative-memo` | Dense-prose strategy memos: tenets, options considered and rejected, unit economics, pre-mortem risk matrix, FAQ appendix. |

## Analytics skills

13 skills from [nimrodfisher/data-analytics-skills](https://github.com/nimrodfisher/data-analytics-skills),
kept from that repo's 31:

| Skill | Role |
| --- | --- |
| `root-cause-investigation` | A metric moved — systematic investigation of why |
| `funnel-analysis` | Multi-step conversion drop-off diagnosis |
| `cohort-analysis` | Retention and behaviour over time |
| `segmentation-analysis` | Who the distinct groups actually are |
| `business-metrics-calculator` | MRR, churn, LTV, CAC with industry benchmarks |
| `ab-test-analysis` | Significance, sample ratio mismatch, experiment readout |
| `time-series-analysis` | Trend, seasonality, anomaly, forecast |
| `impact-quantification` | Sizing the opportunity and ROI of a recommendation |
| `insight-synthesis` | Findings into "so what" |
| `analysis-planning` | Structure the question before doing the work |
| `stakeholder-requirements-gathering` | Turning a vague ask into a scoped one |
| `visualization-builder` | Chart-type choice and publication-ready visuals |
| `dashboard-specification` | Dashboard requirements and design specs |

**A deliberate subset.** The 18 skipped skills are data-engineering oriented (`data-quality-audit`,
`query-validation`, `programmatic-eda`, `semantic-model-builder`, `sql-to-business-logic`, data
cataloguing), team-process artefacts (`analysis-retrospective`, `peer-review-template`,
`analysis-qa-checklist`, `context-packager`), or duplicate ground already covered here by
`executive-deck` and `amazon-narrative-memo` (`executive-summary-generator`,
`data-narrative-builder`, `methodology-explainer`, `technical-to-business-translator`).
`ANALYTICS_KEEP` in `scripts/sync-upstream.sh` holds the list.

These skills write and run analysis code, so they assume **pandas, numpy, matplotlib and
seaborn** are available in whatever environment you point them at.

Note `ab-test-analysis` (statistics of a finished experiment) and `ab-testing` from the
marketing set (designing the experiment) are complements, not duplicates.

## Marketing skills

16 skills from [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills),
kept from that repo's 50:

| `ab-testing` | `ad-creative` | `ads` |
| `ai-seo` | `analytics` | `cold-email` |
| `competitors` | `copywriting` | `marketing-council` |
| `marketing-ideas` | `marketing-loops` | `marketing-plan` |
| `marketing-psychology` | `pricing` | `product-marketing` |
| `sales-enablement` |  |  |

**This is a deliberate subset.** The other 33 upstream skills (`seo-audit`, `social`, `emails`,
`onboarding`, `cro`, `offers`, `prospecting`, …) were deleted to hold down always-on context
cost — every installed skill's description loads on every request. `scripts/sync-upstream.sh`
carries the keep-list, so a re-sync will not bring them back. To restore one, add its name to
`MARKETING_KEEP` in that script and re-run it.

Several kept skills link to a shared tool registry at `tools/` (integration notes for Google Ads,
GA4, Segment and ~160 other files). That directory is vendored too, so those `../../tools/...`
links resolve. One link now dangles by design: `ads` points at `customer-research`, which was
pruned.

Run `product-marketing` first — it writes the `.agents/product-marketing.md` context file that
`competitor-profiling` and others look for before interviewing you from scratch.

## `recursive-research` is a local fork

Upstream is written in Spanish — both the body and, more consequentially, the `description`
that decides when the skill fires. It is translated to English here, so it auto-triggers on
English phrasing like "research this deeply".

Structure, thresholds, WDM weights, source tiering and the five PhD stopping criteria are
unchanged. The filenames the skill *generates* were translated too
(`memoria/investigaciones/` -> `memory/research/`, `estado.md` -> `state.md`, and so on), so
research folders from this copy are not interchangeable with upstream's. MIT permits the
derivative; the copyright notice stays in `LICENSE` and in the skill.

`scripts/sync-upstream.sh` therefore does **not** re-copy this skill — that would silently
revert the translation. It refreshes `LICENSE`, compares the upstream `version:` against the
local one, and if upstream has moved it warns loudly and drops the new Spanish original at
`skills/recursive-research/SKILL.upstream.es.md` for you to diff and re-translate deliberately.

## The missing pptx/docx/xlsx engines

`executive-deck` and `academic-pptx` both expect an installed engine to actually write the
Office file — Anthropic's own `pptx`, `docx` and `xlsx` skills.

Those are **not vendored here, deliberately.** They ship with a proprietary licence
(`(c) 2025 Anthropic, PBC`) that forbids retaining copies outside Anthropic's Services,
reproducing them, or distributing them to third parties — which is what committing them to
this repo and pushing it would be. Third-party repositories that redistribute them do not
change those terms.

How each surface gets the engine instead:

- **Chat, Cowork, Desktop** — `pptx` / `docx` / `xlsx` / `pdf` are Anthropic-provided skills.
  Enable them under Customize -> Skills. Nothing to install; the two skills above then work as written.
- **Claude Code** — no bundled engine. Either drive the file format directly with a library
  (`python-pptx`, `python-docx`, `openpyxl`), or use these two skills for the outline and
  build the artifact in Chat/Cowork.

## Install

**Claude Code**

```
/plugin marketplace add <this repo>
/plugin install chakresh-skills@chakresh
```

**Claude Chat and Cowork** (one account-level list — add it once, in either)

Customize -> Plugins -> Personal -> `+` -> Add marketplace -> Add from a repository -> paste this repo.

Requires a paid plan. Skills run on all three surfaces; hooks and subagents only run in Cowork.

## Context cost

Every installed skill's name and description is loaded on every request. At 40 skills
that is a real, permanent overhead — if a category here goes unused, deleting its directory
is the fix.

## Updating

```
scripts/sync-upstream.sh
git diff --stat        # review what changed upstream
git commit -am "Sync upstream skills"
```

Vendoring means upstream fixes do not arrive on their own. The alternative is registering
each upstream repo as its own marketplace, which auto-updates but needs registering
separately on every surface.

## Provenance

| Skills | Source | License |
| --- | --- | --- |
| 16 marketing skills, `competitor-profiling`, `tools/` | [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | MIT, (c) 2025 Corey Haines |
| `grilling`, `grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT |
| `market-research` | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | see upstream |
| `synthetic-market-research` | [BayramAnnakov/synthetic-market-research](https://github.com/BayramAnnakov/synthetic-market-research) | MIT, (c) 2026 Bayram Annakov |
| `academic-pptx` | [Gabberflast/academic-pptx-skill](https://github.com/Gabberflast/academic-pptx-skill) | MIT, (c) 2026 Gabberflast |
| `recursive-research` | [Anjos2/recursive-research](https://github.com/Anjos2/recursive-research) | MIT, (c) 2026 Joseph Huayhualla |
| 13 analytics skills | [nimrodfisher/data-analytics-skills](https://github.com/nimrodfisher/data-analytics-skills) | **no LICENSE file** — see below |
| `startup-cso`, `executive-deck`, `consulting-frameworks`, `amazon-narrative-memo` | authored in this repo | — |

Note: `academic-pptx`'s own frontmatter carries `license: Proprietary. LICENSE.txt has complete
terms`, inherited from the Anthropic skill it was modelled on. The repository's actual `LICENSE`
is MIT, which is what governs; the frontmatter line is left byte-identical to upstream so the
sync stays a clean copy.

### One licensing caveat

`nimrodfisher/data-analytics-skills` ships no LICENSE file, so no redistribution rights are
granted. Vendoring it here is fine while **this repository stays private** — the author
publishes the skills to be cloned and used. Making this repo public would be redistribution
without a licence. If that ever becomes the plan, drop those 13 directories first (or ask the
author to add a licence).
