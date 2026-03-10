---
description: Analyze any codebase and auto-generate a documentation site. Supports Next.js, Docusaurus, and Astro Starlight. Use when the user wants to generate docs from their code.
disable-model-invocation: true
---

# Auto-Docs: Generate Documentation from Code

You are generating a documentation site for this project. Analyze the codebase, then create a complete docs site inside a `docs/` subfolder (or the directory specified in `.docs-config.json`). Follow these phases in order.

## Phase 1: Project Discovery

Before writing any documentation, understand what you are documenting.

1. **Detect language and framework** — read these files in order until you find a match:
   - `package.json` — Node.js / TypeScript / JavaScript
   - `Cargo.toml` — Rust
   - `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt` — Python
   - `go.mod` — Go
   - `pom.xml`, `build.gradle`, `build.gradle.kts` — Java / Kotlin
   - `Gemfile`, `*.gemspec` — Ruby
   - `composer.json` — PHP
   - `*.sln`, `*.csproj` — C# / .NET
   - `CMakeLists.txt`, `Makefile` — C / C++
   - `Package.swift` — Swift
   - Fall back to file-extension analysis if none match

2. **Read existing documentation** — `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `LICENSE`, any `docs/` or `doc/` folder.

3. **Read `.docs-config.json`** if it exists. If it does not exist, infer values:
   - `github_repo` — from `git remote get-url origin`
   - `github_branch` — default `main`
   - `site_title` — from `package.json` name or repo name
   - `docs_framework` — default `nextjs`
   - `docs_dir` — default `docs`

4. **Identify the project type**:
   - **Library** — exports functions/classes for other code to consume
   - **CLI** — has a `bin` field, argument parser dependency (yargs, clap, argparse, cobra, etc.)
   - **Web app** — has a frontend framework (React, Vue, Angular, Svelte) or full-stack framework (Next.js, Nuxt, Rails, Django)
   - **API server** — has a web framework (Express, Fastify, Flask, FastAPI, Actix, Gin, Spring Boot) with route definitions
   - **Monorepo** — has `packages/`, `apps/`, or workspace config
   - **Other** — anything else; document what you find

5. **Note the package manager, build system, and test framework** for use in the getting-started docs.

## Phase 2: Codebase Analysis

Map the project thoroughly before writing any content.

1. **Directory structure** — map top two levels of the project, go deeper for `src/`, `lib/`, `pkg/`, or equivalent source directories.

2. **Entry points** — find `main`, `index`, `app`, `server`, or exported module roots.

3. **Public API catalog** — for each public/exported symbol, extract:
   - Name, signature, parameters, return type
   - Doc comments or docstrings (if present)
   - Which module/file it belongs to

4. **API extraction strategy by language**:
   - **TypeScript/JavaScript** — read `index.ts`/`index.js` exports, JSDoc comments, OpenAPI/Swagger specs, route files
   - **Python** — read `__init__.py` exports, docstrings, type hints, FastAPI/Flask route decorators
   - **Rust** — read `lib.rs` public items, `///` doc comments, `pub` visibility
   - **Go** — read exported symbols (capitalized names), godoc comments, handler registrations
   - **Java/Kotlin** — read public class/method signatures, Javadoc, Spring/JAX-RS annotations
   - **Other languages** — look for exported/public symbols, doc comments in whatever format the language uses

5. **Configuration and environment** — identify config files, environment variables, feature flags, CLI arguments.

6. **Tests** — read test files to understand usage patterns, expected behavior, and edge cases. Tests are excellent source material for code examples.

7. **Dependencies** — identify key dependencies and what each is used for.

8. **Architecture patterns** — detect MVC, microservices, plugin system, event-driven, layered architecture, monorepo structure, etc.

## Phase 3: Documentation Planning

Based on your analysis, plan the documentation structure.

1. **Choose sections based on project type**:
   - **Library** — emphasize API reference, installation, quickstart with code examples
   - **CLI** — emphasize command reference, configuration, common workflows
   - **Web app / API** — emphasize architecture overview, API endpoints, deployment guide
   - **All projects** — always include: overview, getting started, architecture

2. **Create a navigation outline** — this becomes the sidebar/nav tree. Group pages logically using the Diataxis framework (see Content Organization below).

3. **Plan API reference pages** — one page per major module or API surface area. Do not create one page per function unless the project is very small.

## Phase 4: Framework Selection & Scaffolding

Read `docs_framework` from `.docs-config.json` (default: `"nextjs"`). Supported values: `"nextjs"`, `"docusaurus"`, `"astro"`.

Create the docs site inside the configured `docs_dir` (default: `docs/`). If the directory already exists, update it rather than overwriting — preserve any manual edits.

### Next.js / MDX

```
docs/
  app/                  Next.js App Router pages and layouts
    layout.tsx          Root layout with sidebar navigation
    page.tsx            Home page (renders overview or redirects)
    [...slug]/
      page.tsx          Dynamic route for all docs pages
  components/
    Navigation.tsx      Sidebar nav driven by config/docs.json
    PrevNextNav.tsx     Bottom-of-page prev/next links
    PageActions.tsx     Dropdown: copy markdown, view raw, open in ChatGPT/Claude
    EditThisPage.tsx    Link to GitHub edit URL
    Search.tsx          Client-side search
    MDXComponents.tsx   Custom MDX component overrides
  config/
    docs.json           Navigation tree (generated from content structure)
  content/              MDX documentation pages organized by section
  lib/
    markdown.ts         MDX processing utilities
    navigation.ts       Nav tree helpers (flatten, find prev/next)
    search.ts           Search index utilities
  scripts/
    check-links.ts      Broken link validation
    build-llms-txt.ts   Generate llms.txt and llms-full.txt
    build-search-index.ts  Generate client-side search index
  public/               Static assets + generated files (llms.txt, search-index.json)
  package.json
  tsconfig.json
  next.config.mjs
  tailwind.config.ts
  postcss.config.mjs
```

**Technical conventions for Next.js:**
- Tailwind CSS utility classes. No custom CSS unless necessary.
- `'use client'` directive only on components using browser APIs, event handlers, or hooks (`useState`, `useEffect`). Server components are the default.
- `lucide-react` for all icons.
- Pin exact dependency versions in `package.json` (no `^` or `~`).

### Docusaurus

```
docs/
  docs/                 Markdown/MDX content pages organized by section
  src/
    components/         Custom React components (PageActions, etc.)
    css/                Custom styles (minimal)
    pages/              Custom pages (if needed)
  static/               Static assets + generated files (llms.txt)
  scripts/
    check-links.ts      Broken link validation
    build-llms-txt.ts   Generate llms.txt and llms-full.txt
  docusaurus.config.ts  Site configuration (title, URL, navbar, footer)
  sidebars.ts           Sidebar navigation tree
  package.json
  tsconfig.json
```

**Docusaurus notes:**
- Uses built-in sidebar navigation — do not create a custom PrevNextNav component.
- Uses built-in search plugin (e.g., `@docusaurus/plugin-search-local` or Algolia) — do not create a custom search index script.
- Sidebar is auto-generated from folder structure or manually defined in `sidebars.ts`.
- Supports MDX out of the box.

### Astro Starlight

```
docs/
  src/
    content/
      docs/             Markdown/MDX content pages organized by section
    components/         Custom components (PageActions, etc.)
  scripts/
    check-links.ts      Broken link validation
    build-llms-txt.ts   Generate llms.txt and llms-full.txt
  public/               Static assets + generated files (llms.txt)
  astro.config.mjs      Astro config with Starlight integration
  package.json
  tsconfig.json
```

**Astro Starlight notes:**
- Uses built-in sidebar navigation configured in `astro.config.mjs` — do not create a custom PrevNextNav component.
- Uses built-in search — do not create a custom search index script.
- Content pages use Markdown frontmatter for titles and ordering.
- Supports MDX via `@astrojs/mdx` integration.

## Phase 5: Content Generation

### Rules

- **Every factual claim must be derived from the actual codebase.** Do not invent features that don't exist.
- Include **code examples** extracted from tests, example files, or source code.
- **Link to source files** where appropriate (e.g., "See `src/parser.ts` for implementation details").
- Use **doc comments and docstrings** as primary source material for API reference pages.
- When docstrings are absent, read function bodies and test cases to understand behavior.
- Write in clear, concise technical English. Avoid marketing language.

### Required Pages

Generate these pages (paths adapt per framework):

| Page | Content Source |
|------|---------------|
| **Overview / index** | README + code analysis: what the project is, what problem it solves, key features |
| **Installation** | Package manager files, README setup sections, prerequisites |
| **Quickstart** | Tests, examples folder, README — minimal working example |
| **Architecture** | Directory structure analysis, module relationships, architectural patterns |
| **API Reference** (per module) | Exported symbols, docstrings, type signatures, parameters |
| **Guides / How-tos** | Test files, example files, README sections — task-oriented walkthroughs |
| **Configuration** | Environment variables, config files, CLI arguments, feature flags |

Skip any section that has no meaningful content to derive from the codebase. A missing section is better than a section full of placeholders.

## Phase 6: Required Site Features

Create these features in the generated docs site. Some are framework-specific.

### All Frameworks

1. **PageActions Dropdown** — a dropdown on every docs page with these actions:
   - **Copy page** — copies the page content as Markdown to clipboard
   - **View as Markdown** — opens the raw Markdown in a new tab
   - **Open in ChatGPT** — opens `https://chatgpt.com/?q=` with an encoded prompt asking ChatGPT to read the page, using the page's production URL from `.docs-config.json`
   - **Open in Claude** — opens `https://claude.ai/new?q=` with an encoded prompt asking Claude to read the page, using the page's production URL from `.docs-config.json`

2. **Edit This Page** — a link on every page that opens the GitHub edit URL:
   ```
   https://github.com/{github_repo}/edit/{github_branch}/{docs_dir}/content/{path-to-file}
   ```
   Adjust the path pattern based on the framework's content directory structure.

3. **Broken Link Checker** — `scripts/check-links.ts`:
   - Validates all internal links in the content
   - Checks relative links between pages and anchor links within pages
   - Exits non-zero on failure with a list of broken links
   - Add a `check-links` script to `package.json`

4. **llms.txt Generation** — `scripts/build-llms-txt.ts`:
   - Generates `public/llms.txt` — page index with titles and URLs per the [llms.txt spec](https://llmstxt.org/)
   - Generates `public/llms-full.txt` — full concatenated content of all pages
   - Runs as a prebuild script in `package.json`
   - Uses `production_url` from `.docs-config.json` for absolute URLs

5. **README.md** — inside the docs directory, covering:
   - Prerequisites (Node.js version, package manager)
   - Install steps
   - Dev server command and local URL
   - Build command and how to preview production build
   - Any required environment variables

### Next.js Only

6. **PrevNextNav Component** — previous/next navigation at the bottom of every page:
   - Reads the nav tree from `config/docs.json`
   - Derives prev/next based on current position in the tree
   - Hides "previous" on first page, "next" on last page

7. **Search Index** — `scripts/build-search-index.ts`:
   - Builds a JSON client-side search index from content
   - Indexes titles, headings, and body text
   - Runs as a prebuild script

### Docusaurus & Astro Starlight

Features 6 and 7 are **not needed** — these frameworks provide built-in navigation and search. Use the framework defaults.

## Phase 7: Verification

After generating the docs site:

1. Run `pnpm install` (or `npm install`) inside the docs directory.
2. Run `pnpm build` to verify the site compiles without errors.
3. Run the link checker to ensure no broken internal links.
4. Verify the navigation tree/sidebar matches the actual content files.
5. Spot-check that API reference pages match the actual exported symbols.

## Content Organization (Diataxis)

Follow the [Diataxis](https://diataxis.fr/) framework as a guide (not a strict rulebook) for organizing documentation:

- **Quickstart** — get from zero to the "aha" moment as fast as possible
- **Installation guide** — setup and prerequisites
- **Tutorials** — practical activities where the reader learns by doing something meaningful toward an achievable goal
- **How-tos** — task-oriented guides that help the user get something done correctly and safely
- **Reference** — propositional or theoretical knowledge the user looks up during their work
- **Explanation** — content that deepens and broadens understanding, bringing clarity, light, and context

## General Technical Conventions

- **Content format**: MDX files. Use standard Markdown with JSX components where needed.
- **GitHub Actions**: Pin all actions to full SHA hashes with a version comment: `actions/checkout@<sha> # vX.Y.Z`. Use `persist-credentials: false` on checkout.
- **Dependencies**: Pin exact versions in `package.json` (no `^` or `~` prefixes).
- **Scripts**: All build/validation scripts live in `scripts/` and are written in TypeScript.
