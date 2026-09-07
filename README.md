# claude-skills

Personal Agent Skills, packaged as a Claude plugin so one repo serves every surface:
Claude Code, Claude Chat (web/desktop), and Cowork.

**53 skills.** All of them are vendored copies of upstream repos — see
[Provenance](#provenance) and [Updating](#updating).

## Curated skills

| Skill | What it does | Invocation |
| --- | --- | --- |
| `market-research` | Market sizing, competitor comparisons, investor dossiers, technology scans — with source attribution and decision-oriented summaries. | automatic or `/market-research` |
| `competitor-profiling` | Turns a list of competitor URLs into structured profile documents, combining live site scraping with SEO data. Needs MCP (see below). | automatic or `/competitor-profiling` |
| `grilling` | Relentless round-based interview that maps a plan as a design tree and stress-tests it. | automatic on "grill" phrases |
| `grill-me` | Thin trigger that hands off to `grilling`. Never auto-invokes. | `/grill-me` only |

`grill-me` is useless without `grilling` — keep them together.

## Marketing skills

49 skills from [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills),
covering CRO, copywriting, SEO, paid ads, lifecycle, and growth:

| `ab-testing` | `ad-creative` | `ads` |
| `ai-seo` | `analytics` | `aso` |
| `attribution` | `churn-prevention` | `co-marketing` |
| `cold-email` | `community-marketing` | `competitors` |
| `content-strategy` | `copy-editing` | `copywriting` |
| `cro` | `customer-research` | `directory-submissions` |
| `emails` | `events` | `free-tools` |
| `image` | `influencer-marketing` | `launch` |
| `lead-magnets` | `marketing-council` | `marketing-ideas` |
| `marketing-loops` | `marketing-plan` | `marketing-psychology` |
| `offers` | `onboarding` | `paywalls` |
| `popups` | `pricing` | `product-marketing` |
| `programmatic-seo` | `prospecting` | `public-relations` |
| `referrals` | `revops` | `sales-enablement` |
| `schema` | `seo-audit` | `signup` |
| `site-architecture` | `sms` | `social` |
| `video` |  |  |

Several of these link to a shared tool registry at `tools/` (integration notes for Google Ads,
GA4, Segment and ~160 other files). That directory is vendored too, so those `../../tools/...`
links resolve.

## Prerequisites worth knowing

`competitor-profiling` drives two MCP servers and degrades badly without them:

- **Firecrawl** — live competitor site scraping
- **DataForSEO** — traffic, keyword, and backlink data

It also looks for a `.agents/product-marketing.md` (or `.claude/product-marketing.md`) context
file in the working directory and, finding none, will interview you for the same information.
Output lands in `competitor-profiles/` relative to wherever it runs. Many of the marketing
skills expect similar API access for the platform they cover.

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

Every installed skill's name and description is loaded on every request. At 53 skills
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
| 49 marketing skills, `competitor-profiling`, `tools/` | [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | MIT, (c) 2025 Corey Haines |
| `grilling`, `grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT |
| `market-research` | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | see upstream |
