#!/usr/bin/env bash
set -euo pipefail

REPO="Cyfrin/claude-docs-prompts"
VERSION="${1:-main}"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${VERSION}"
CONFIG_FILE=".docs-config.json"
CLAUDE_FILE="CLAUDE.md"

printf "Installing claude-docs-prompts (%s)...\n\n" "$VERSION"

MARKER="<!-- LOCAL CUSTOMIZATIONS — everything below this line is preserved on update -->"

# Save local customizations if they exist
local_additions=""
if [ -f "$CLAUDE_FILE" ] && grep -qF "$MARKER" "$CLAUDE_FILE"; then
	local_additions="$(sed -n "/${MARKER}/,\$p" "$CLAUDE_FILE")"
fi

# Download latest template (always overwrite)
if ! curl -fsSL "${RAW_BASE}/src/CLAUDE.md" -o "$CLAUDE_FILE"; then
	printf "Error: failed to download CLAUDE.md from %s\n" "$VERSION" >&2
	exit 1
fi

# Restore local customizations
if [ -n "$local_additions" ]; then
	# Replace the marker and everything after it with the saved content
	sed -n "/${MARKER}/q;p" "$CLAUDE_FILE" >"${CLAUDE_FILE}.tmp"
	printf "%s\n" "$local_additions" >>"${CLAUDE_FILE}.tmp"
	mv "${CLAUDE_FILE}.tmp" "$CLAUDE_FILE"
	printf "Updated %s (local customizations preserved)\n" "$CLAUDE_FILE"
else
	printf "Updated %s\n" "$CLAUDE_FILE"
fi

# Create .docs-config.json only if it doesn't exist
if [ -f "$CONFIG_FILE" ]; then
	printf "Skipped %s (already exists — edit manually to update values)\n" "$CONFIG_FILE"
else
	printf "\nCreating %s — enter repo-specific values:\n\n" "$CONFIG_FILE"

	# Infer defaults where possible
	default_repo=""
	if git remote get-url origin >/dev/null 2>&1; then
		remote_url="$(git remote get-url origin)"
		# Handle both SSH and HTTPS remotes
		default_repo="$(echo "$remote_url" |
			sed 's|.*github\.com[:/]||' |
			sed 's|\.git$||')"
	fi

	default_title=""
	if [ -f "package.json" ]; then
		default_title="$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json |
			head -1 |
			sed 's/.*"name"[[:space:]]*:[[:space:]]*"//;s/"//' || true)"
	fi

	# Prompt for values
	if [ -n "$default_repo" ]; then
		printf "GitHub repo [%s]: " "$default_repo"
	else
		printf "GitHub repo (e.g. Cyfrin/docs-main): "
	fi
	read -r github_repo </dev/tty
	github_repo="${github_repo:-$default_repo}"

	if [ -z "$github_repo" ]; then
		printf "Error: github_repo is required\n" >&2
		exit 1
	fi

	printf "GitHub branch [main]: "
	read -r github_branch </dev/tty
	github_branch="${github_branch:-main}"

	printf "Production URL (e.g. https://docs.cyfrin.io): "
	read -r production_url </dev/tty
	if [ -z "$production_url" ]; then
		printf "Error: production_url is required\n" >&2
		exit 1
	fi

	if [ -n "$default_title" ]; then
		printf "Site title [%s]: " "$default_title"
	else
		printf "Site title: "
	fi
	read -r site_title </dev/tty
	site_title="${site_title:-$default_title}"

	printf "Site description: "
	read -r site_description </dev/tty

	# Write config
	cat >"$CONFIG_FILE" <<EOF
{
  "github_repo": "${github_repo}",
  "github_branch": "${github_branch}",
  "production_url": "${production_url}",
  "site_title": "${site_title}",
  "site_description": "${site_description}"
}
EOF

	printf "\nCreated %s\n" "$CONFIG_FILE"
fi

printf "\nDone! Add %s to version control.\n" "$CONFIG_FILE"
printf "Add repo-specific instructions below the LOCAL CUSTOMIZATIONS marker in CLAUDE.md\n"
