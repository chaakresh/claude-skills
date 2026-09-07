# claude-skills

Personal Agent Skills, packaged as a Claude plugin so one repo serves every surface:
Claude Code, Claude Chat (web/desktop), and Cowork.

## Skills

| Skill | What it does | Invocation |
| --- | --- | --- |
| `market-research` | Market sizing, competitor comparisons, investor dossiers, technology scans — with source attribution and decision-oriented summaries. | automatic or `/market-research` |
| `competitor-profiling` | Turns a list of competitor URLs into structured profile documents, combining live site scraping with SEO data. Needs MCP (see below). | automatic or `/competitor-profiling` |
| `grilling` | Relentless round-based interview that maps a plan as a design tree and stress-tests it. | automatic on "grill" phrases |
| `grill-me` | Thin trigger that hands off to `grilling`. Never auto-invokes. | `/grill-me` only |

`grill-me` is useless without `grilling` — keep them together.

### `competitor-profiling` prerequisites

This skill drives two MCP servers and degrades badly without them:

- **Firecrawl** — live competitor site scraping
- **DataForSEO** — traffic, keyword, and backlink data

It also looks for a `.agents/product-marketing.md` (or `.claude/product-marketing.md`) context
file in the working directory and, finding none, will interview you for the same information.
Output lands in `competitor-profiles/` relative to wherever it runs.

## Install

**Claude Code**

```
/plugin marketplace add <this repo>
/plugin install chakresh-skills@chakresh
```

**Claude Chat and Cowork** (one account-level list — add it once, in either)

Customize -> Plugins -> Personal -> `+` -> Add marketplace -> Add from a repository -> paste this repo.

Requires a paid plan. Skills run on all three surfaces; hooks and subagents only run in Cowork.

## Updating

Edit a `SKILL.md`, commit, push. Each surface picks up the change on its next marketplace sync.

## Provenance

- `market-research` — [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) (ECC)
- `competitor-profiling` — [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) (MIT, © 2025 Corey Haines)
- `grilling`, `grill-me` — [mattpocock/skills](https://github.com/mattpocock/skills) (MIT)

Vendored deliberately rather than installed from upstream: both source repos are large
(37, 286 and 50 skills), and every installed skill's name and description occupies context
on every request.
