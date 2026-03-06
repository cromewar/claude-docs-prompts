# claude-docs-prompts

Shared instructions and Claude Skill for documentation sites. Gives AI agents consistent guidance across all docs repos.

# Installation/Quickstart

Install the Cyfrin marketplace, then the claude-docs-prompts skill.

```bash
# Open a claude code terminal, and in the claude prompt run:
/plugin marketplace add Cyfrin/claude-docs-prompts
/plugin install claude-docs-prompts@Cyfrin/claude-docs-prompts
# Press Ctrl+C then run claude again. Or type /exit to quit first.
/exit
claude --continue
```

# What it does

- Consistent docs site structure across all Cyfrin repos
- Enforces required features (PrevNextNav, PageActions, link checker, llms.txt, search index)
- Follows Diataxis framework for content organization
- Technical conventions for MDX, Tailwind CSS, pinned dependencies, and GitHub Actions

# Usage

```
Build the PrevNextNav component using config/docs.json
Add the PageActions dropdown to docs pages
Set up the broken link checker script
Generate llms.txt and search index
```

# What the skill covers

- **Project structure** — where to find pages, components, config, and scripts
- **PrevNextNav** — bottom-of-page navigation driven by `config/docs.json`
- **PageActions** — dropdown to copy as markdown, open in Claude, open in ChatGPT
- **Edit this page** — link to the GitHub edit URL
- **Broken link checker** — `scripts/check-links.ts` + GitHub Action
- **llms.txt generation** — `scripts/build-llms-txt.ts` as prebuild
- **Search index** — `scripts/build-search-index.ts` as prebuild
- **Technical conventions** — MDX, Tailwind, `'use client'`, lucide-react, pinned actions
- **Content organization** — Diataxis framework (quickstart, tutorials, how-tos, reference, explanation)

# Legacy Install (curl)

The original installation method downloads a `CLAUDE.md` template directly into your repo root via curl.

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

## Keeping up to date (legacy)

### Option 1: package.json script

Add this to your `package.json`:

```json
{
  "scripts": {
    "update-claude": "curl -fsSL https://raw.githubusercontent.com/Cyfrin/claude-docs-prompts/main/install.sh | bash"
  }
}
```

Then run `pnpm update-claude` whenever you want the latest template.

### Option 2: GitHub Action

Add `.github/workflows/update-claude-md.yml` to auto-update weekly and open a PR:

```yaml
name: Update CLAUDE.md
on:
  schedule:
    - cron: "0 9 * * 1" # Every Monday at 9am UTC
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<sha> # pin to latest
        with:
          persist-credentials: false
      - name: Update CLAUDE.md
        run: curl -fsSL https://raw.githubusercontent.com/Cyfrin/claude-docs-prompts/main/install.sh | bash
      - name: Create PR if changed
        uses: peter-evans/create-pull-request@<sha> # pin to latest
        with:
          commit-message: "Update CLAUDE.md from claude-docs-prompts"
          title: "Update CLAUDE.md template"
          branch: update-claude-md
          delete-branch: true
```

### Manual

Re-run the install command directly. It updates the template section of `CLAUDE.md` while preserving your local customizations, and leaves `.docs-config.json` untouched.

## Configuration (.docs-config.json)

The legacy install script creates a `.docs-config.json` in your repo:

```json
{
  "github_repo": "Cyfrin/docs-main",
  "github_branch": "main",
  "production_url": "https://docs.cyfrin.io",
  "site_title": "Cyfrin Docs",
  "site_description": "Documentation for Cyfrin"
}
```

| Field              | Required | Default                           |
| ------------------ | -------- | --------------------------------- |
| `github_repo`      | Yes      | Inferred from `git remote`        |
| `github_branch`    | No       | `main`                            |
| `production_url`   | Yes      | —                                 |
| `site_title`       | No       | Inferred from `package.json` name |
| `site_description` | No       | —                                 |

Commit this file to version control. It is never overwritten on update.

## Repo-specific instructions (legacy)

The `CLAUDE.md` has a marker line near the bottom:

```
<!-- LOCAL CUSTOMIZATIONS — everything below this line is preserved on update -->
```

Add any repo-specific agent instructions below this marker. When you re-run the install script, everything above the marker gets updated to the latest template, and everything below it is preserved.

# Authors

[Patrick Collins](https://x.com/PatrickAlphaC) and the [Cyfrin](https://www.cyfrin.io/) team.
