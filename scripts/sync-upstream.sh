#!/usr/bin/env bash
# Refresh vendored skills from their upstream repos.
# Every skill here is a copy; this script re-pulls those copies so a
# `git diff` afterwards shows exactly what changed upstream.
#
# Usage: scripts/sync-upstream.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

clone() { git clone --depth 1 --quiet "https://github.com/$1" "$TMP/$2"; }

echo "==> cloning upstreams"
clone coreyhaines31/marketingskills   marketingskills
clone mattpocock/skills               mattpocock
clone affaan-m/everything-claude-code ecc
clone BayramAnnakov/synthetic-market-research synthetic
clone Gabberflast/academic-pptx-skill          academic
clone Anjos2/recursive-research                recursive
clone nimrodfisher/data-analytics-skills       analytics

# Only these 17 of the upstream 50 are kept. Anything not listed here was
# deliberately deleted -- do not "helpfully" widen this list, or the sync will
# resurrect skills that were pruned to hold down always-on context cost.
MARKETING_KEEP=(
  ab-testing ad-creative ads ai-seo analytics cold-email
  competitor-profiling competitors copywriting marketing-council
  marketing-ideas marketing-loops marketing-plan marketing-psychology
  pricing product-marketing sales-enablement
)

echo "==> marketingskills: ${#MARKETING_KEEP[@]} of 50 skills + tools registry"
for s in "${MARKETING_KEEP[@]}"; do
  if [ -d "$TMP/marketingskills/skills/$s" ]; then
    rm -rf "$REPO_ROOT/skills/$s"
    cp -R "$TMP/marketingskills/skills/$s" "$REPO_ROOT/skills/"
  else
    echo "    WARNING: $s no longer exists upstream" >&2
  fi
done
rm -rf "$REPO_ROOT/tools"
cp -R "$TMP/marketingskills/tools"     "$REPO_ROOT/tools"
cp    "$TMP/marketingskills/partners.json" "$REPO_ROOT/partners.json"

echo "==> mattpocock/skills: grilling, grill-me"
cp -R "$TMP/mattpocock/skills/productivity/grilling"  "$REPO_ROOT/skills/"
cp -R "$TMP/mattpocock/skills/productivity/grill-me"  "$REPO_ROOT/skills/"

echo "==> ECC: market-research"
cp -R "$TMP/ecc/skills/market-research" "$REPO_ROOT/skills/"

# This upstream is a bare skill at its repo root, not a skills/ collection.
echo "==> synthetic-market-research"
SMR="$REPO_ROOT/skills/synthetic-market-research"
mkdir -p "$SMR"
cp "$TMP/synthetic/SKILL.md" "$TMP/synthetic/requirements.txt" \
   "$TMP/synthetic/test_run.py" "$TMP/synthetic/LICENSE" "$SMR/"
rm -rf "$SMR/references" "$SMR/examples"
cp -R "$TMP/synthetic/references" "$TMP/synthetic/examples" "$SMR/"

# Also a bare skill at its repo root.
echo "==> academic-pptx"
ACAD="$REPO_ROOT/skills/academic-pptx"
mkdir -p "$ACAD"
cp "$TMP/academic/SKILL.md" "$TMP/academic/content_guidelines.md" \
   "$TMP/academic/slide_patterns.md" "$TMP/academic/LICENSE" "$ACAD/"
cp "$TMP"/academic/*.pdf "$ACAD/"

# 13 of that repo's 31 skills. The rest are data-engineering and team-process
# oriented (quality audits, SQL review, data catalogs, retros) or duplicate the
# memo/deck skills here. Same rule as MARKETING_KEEP: do not widen casually.
# Upstream groups skills under numbered category dirs, so each is located by name.
ANALYTICS_KEEP=(
  root-cause-investigation funnel-analysis cohort-analysis segmentation-analysis
  business-metrics-calculator impact-quantification insight-synthesis
  analysis-planning stakeholder-requirements-gathering ab-test-analysis
  visualization-builder dashboard-specification time-series-analysis
)

echo "==> data-analytics-skills: ${#ANALYTICS_KEEP[@]} of 31 skills"
for s in "${ANALYTICS_KEEP[@]}"; do
  src="$(find "$TMP/analytics" -type d -name "$s" -not -path '*/.git/*' | head -1)"
  if [ -n "$src" ]; then
    rm -rf "$REPO_ROOT/skills/$s"
    cp -R "$src" "$REPO_ROOT/skills/"
  else
    echo "    WARNING: $s no longer exists upstream" >&2
  fi
done

echo "==> recursive-research"
RR="$REPO_ROOT/skills/recursive-research"
mkdir -p "$RR"
cp "$TMP/recursive/plugins/recursive-research/skills/recursive-research/SKILL.md" "$RR/"
cp "$TMP/recursive/LICENSE" "$RR/"

# skills/startup-cso, executive-deck, consulting-frameworks and
# amazon-narrative-memo are authored here, not vendored.
# The sync deliberately leaves them alone.

find "$REPO_ROOT" -name '.DS_Store' -delete 2>/dev/null || true

echo
echo "==> done. $(ls "$REPO_ROOT/skills" | wc -l | tr -d ' ') skills present."
echo "    Review with: git -C \"$REPO_ROOT\" diff --stat"
