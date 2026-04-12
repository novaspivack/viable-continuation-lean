#!/usr/bin/env bash
# Configure branch protection on main so PRs require your approval before merge.
# Run: ./scripts/setup-branch-protection.sh [owner/repo]
# With no arg: auto-detect from current repo's git origin.
# Requires: gh auth login (or unset GITHUB_TOKEN if invalid)

set -e
if [[ -n "$1" ]]; then
  REPO="$1"
else
  # Auto-detect from git remote (e.g. https://github.com/owner/repo.git -> owner/repo)
  ORIGIN=$(git remote get-url origin 2>/dev/null) || true
  if [[ "$ORIGIN" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    REPO="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  else
    echo "Error: No repo specified and could not detect from git origin. Run: $0 owner/repo"
    exit 1
  fi
fi

echo "Setting up branch protection for $REPO main branch..."

# GitHub API: PUT /repos/{owner}/{repo}/branches/{branch}/protection
# https://docs.github.com/en/rest/branches/branch-protection
gh api "repos/$REPO/branches/main/protection" -X PUT \
  -H "Accept: application/vnd.github+json" \
  --input - <<'JSON'
{
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "required_approving_review_count": 1
  },
  "enforce_admins": false,
  "required_status_checks": null,
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON

echo ""
echo "Done. main now requires a PR with 1 approval before merge."
echo "You (owner/admin) can still push directly and merge PRs (enforce_admins=false)."
echo "Collaborators must open PRs; you approve and merge."
