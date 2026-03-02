# claude-docs-prompts

Shared `CLAUDE.md` template for Cyfrin documentation sites. Gives AI agents consistent instructions across all docs repos.

## Install

Run this in your docs repo:

```bash
curl -fsSL https://raw.githubusercontent.com/Cyfrin/claude-docs-prompts/main/install.sh | bash
```

This does two things:

1. **Downloads `CLAUDE.md`** into your repo root (updates the template portion, preserves your customizations)
2. **Creates `.docs-config.json`** if it doesn't exist — prompts you for repo-specific values

Pin to a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/Cyfrin/claude-docs-prompts/main/install.sh | bash -s v1.0.0
```

## Update

Re-run the install command. It updates the template section of `CLAUDE.md` while preserving your local customizations, and leaves `.docs-config.json` untouched.

## Configuration

The install script creates a `.docs-config.json` in your repo:

```json
{
  "github_repo": "Cyfrin/docs-main",
  "github_branch": "main",
  "production_url": "https://docs.cyfrin.io",
  "site_title": "Cyfrin Docs",
  "site_description": "Documentation for Cyfrin"
}
```

| Field | Required | Default |
|-------|----------|---------|
| `github_repo` | Yes | Inferred from `git remote` |
| `github_branch` | No | `main` |
| `production_url` | Yes | — |
| `site_title` | No | Inferred from `package.json` name |
| `site_description` | No | — |

Commit this file to version control. It is never overwritten on update.

## What the template covers

The `CLAUDE.md` tells AI agents how to work with your docs site:

- **Project structure** — where to find pages, components, config, and scripts
- **PrevNextNav** — bottom-of-page navigation driven by `config/docs.json`
- **PageActions** — dropdown to copy as markdown, open in Claude, open in ChatGPT
- **Edit this page** — link to the GitHub edit URL
- **Broken link checker** — `scripts/check-links.ts` + GitHub Action
- **llms.txt generation** — `scripts/build-llms-txt.ts` as prebuild
- **Search index** — `scripts/build-search-index.ts` as prebuild
- **Technical conventions** — MDX, Tailwind, `'use client'`, lucide-react, pinned actions

## Repo-specific instructions

The `CLAUDE.md` has a marker line near the bottom:

```
<!-- LOCAL CUSTOMIZATIONS — everything below this line is preserved on update -->
```

Add any repo-specific agent instructions below this marker. When you re-run the install script, everything above the marker gets updated to the latest template, and everything below it is preserved.
