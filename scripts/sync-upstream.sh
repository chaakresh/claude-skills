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

echo "==> marketingskills: 50 skills + tools registry"
cp -R "$TMP/marketingskills/skills/."  "$REPO_ROOT/skills/"
rm -rf "$REPO_ROOT/tools"
cp -R "$TMP/marketingskills/tools"     "$REPO_ROOT/tools"
cp    "$TMP/marketingskills/partners.json" "$REPO_ROOT/partners.json"

echo "==> mattpocock/skills: grilling, grill-me"
cp -R "$TMP/mattpocock/skills/productivity/grilling"  "$REPO_ROOT/skills/"
cp -R "$TMP/mattpocock/skills/productivity/grill-me"  "$REPO_ROOT/skills/"

echo "==> ECC: market-research"
cp -R "$TMP/ecc/skills/market-research" "$REPO_ROOT/skills/"

find "$REPO_ROOT" -name '.DS_Store' -delete 2>/dev/null || true

echo
echo "==> done. $(ls "$REPO_ROOT/skills" | wc -l | tr -d ' ') skills present."
echo "    Review with: git -C \"$REPO_ROOT\" diff --stat"
