# auto-docs

Generate complete documentation sites from any codebase. A Claude Code plugin that analyzes your project's source code and creates a full docs site with API reference, architecture guides, and how-tos — all derived from the actual code.

## What it does

- Analyzes any codebase (TypeScript, Python, Rust, Go, Java, Ruby, PHP, C#, C/C++, Swift, and more)
- Generates a complete documentation site inside a `docs/` subfolder
- Documents project features, architecture, APIs, configuration, and usage
- Supports three docs frameworks: **Next.js/MDX**, **Docusaurus**, and **Astro Starlight**
- Creates build scripts for link checking, llms.txt generation, and search indexing

## Installation

Install via the Claude Code plugin marketplace:

```bash
# In a Claude Code terminal, run:
/plugin marketplace add cromewar/claude-docs-prompts
/plugin install auto-docs@cromewar/claude-docs-prompts
# Restart Claude Code
/exit
claude --continue
```

## How it works

The plugin gives Claude Code a seven-phase playbook:

1. **Project Discovery** — detects language, framework, project type, and existing docs
2. **Codebase Analysis** — maps directory structure, catalogs public APIs, reads tests and docstrings
3. **Documentation Planning** — creates a docs outline using the Diataxis framework
4. **Framework Scaffolding** — sets up the chosen docs framework (Next.js, Docusaurus, or Astro Starlight)
5. **Content Generation** — writes MDX pages with content derived from actual code
6. **Site Features** — adds PageActions dropdown, Edit This Page links, link checker, llms.txt, and search
7. **Verification** — builds the site and validates links

## Supported project types

The plugin adapts its documentation strategy based on what it finds:

| Project Type | Emphasis |
|---|---|
| Library | API reference, installation, quickstart examples |
| CLI | Command reference, configuration, common workflows |
| Web app / API | Architecture overview, endpoints, deployment guide |
| Monorepo | Per-package docs, workspace structure |

## Docs frameworks

| Framework | Best for | Built-in features used |
|---|---|---|
| **Next.js/MDX** (default) | Full customization, custom components | — (all features built from scratch) |
| **Docusaurus** | React ecosystem, easy setup | Sidebar navigation, search |
| **Astro Starlight** | Lightweight, fast, docs-focused | Sidebar navigation, search |

Set your preference in `.docs-config.json` or when prompted during install.

## Configuration (.docs-config.json)

```json
{
  "github_repo": "yourorg/yourproject",
  "github_branch": "main",
  "production_url": "https://docs.yourproject.com",
  "site_title": "YourProject Docs",
  "site_description": "Documentation for YourProject",
  "project_type": "library",
  "docs_framework": "nextjs",
  "docs_dir": "docs"
}
```

| Field | Required | Default |
|---|---|---|
| `github_repo` | Yes | Inferred from `git remote` |
| `github_branch` | No | `main` |
| `production_url` | Yes | — |
| `site_title` | No | Inferred from `package.json` name |
| `site_description` | No | — |
| `project_type` | No | `library` |
| `docs_framework` | No | `nextjs` |
| `docs_dir` | No | `docs` |

Commit this file to version control. It is never overwritten on update.

## Legacy install (curl)

Download the `CLAUDE.md` template directly into your repo root:

```bash
curl -fsSL https://raw.githubusercontent.com/cromewar/claude-docs-prompts/main/install.sh | bash
```

Pin to a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/cromewar/claude-docs-prompts/main/install.sh | bash -s v2.0.0
```

### Keeping up to date

Add to your `package.json`:

```json
{
  "scripts": {
    "update-claude": "curl -fsSL https://raw.githubusercontent.com/cromewar/claude-docs-prompts/main/install.sh | bash"
  }
}
```

Or set up a GitHub Action to auto-update weekly:

```yaml
name: Update CLAUDE.md
on:
  schedule:
    - cron: "0 9 * * 1"
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
        run: curl -fsSL https://raw.githubusercontent.com/cromewar/claude-docs-prompts/main/install.sh | bash
      - name: Create PR if changed
        uses: peter-evans/create-pull-request@<sha> # pin to latest
        with:
          commit-message: "Update CLAUDE.md from auto-docs"
          title: "Update CLAUDE.md template"
          branch: update-claude-md
          delete-branch: true
```

## Customization

The `CLAUDE.md` has a marker line near the bottom:

```
<!-- LOCAL CUSTOMIZATIONS — everything below this line is preserved on update -->
```

Add any project-specific agent instructions below this marker. Re-running the install script updates everything above the marker and preserves everything below it.

## Authors

[cromewar](https://github.com/cromewar)
