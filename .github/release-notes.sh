#!/usr/bin/env bash
# Prints release notes for a tag: its commits since the previous tag, then
# GitHub's generated notes (merged PRs, new contributors, full changelog link).
# --generate-notes alone lists only PRs, so direct pushes to main left releases empty.
#   usage: release-notes.sh <tag>   (needs GITHUB_REPOSITORY and gh auth)
set -euo pipefail
tag="$1"
previous="$(git describe --tags --abbrev=0 "$tag^" 2>/dev/null || true)"

echo "## Changes"
echo
git log --no-merges --format='- %s (%h)' "${previous:+$previous..}$tag"
echo

args=(-f tag_name="$tag")
[[ -n "$previous" ]] && args+=(-f previous_tag_name="$previous")
gh api "repos/$GITHUB_REPOSITORY/releases/generate-notes" "${args[@]}" --jq .body
