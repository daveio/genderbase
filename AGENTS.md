# Genderbase Agent Guide

This document contains essential information for AI agents working on the Genderbase repository.

## Project Context

**Genderbase** is a Rails application providing a knowledge base and anonymous Q&A system for gender issues.

- **Stack**: Ruby 3.4+, Rails 7+, PostgreSQL, Redis
- **Frontend**: Hotwire (Turbo/Stimulus), Tailwind CSS, DaisyUI, esbuild
- **Environment**: Managed via `mise`

## Essential Commands

### Setup & Environment

The project uses `mise` for tool versioning and task management.

- **Install dependencies**: `bin/mise install`
- **Reset Database**: `mise run db:reset` (drops, creates, migrates, seeds)

### Development

- **Start Server (Local)**: `mise run dev:localhost` (starts Rails + JS/CSS watchers)
- **Start Server (Tailscale)**: `mise run dev` (requires `TAILSCALE_IPV4`)

### Testing

- **Run All Tests**: `mise run ci:test` or `bundle exec rails test test:system`
- **Run Unit Tests**: `bundle exec rails test`
- **Run System Tests**: `bundle exec rails test:system`
- **Prepare Test DB**: `bundle exec rails db:test:prepare`

### Building Assets

- **Build All**: `bun run build`
- **Build JS**: `bun run build:js`
- **Build CSS**: `bun run build:css`

### Linting & Security

- **Ruby Lint**: `mise run ci:rubocop`
- **Security Scan**: `mise run ci:brakeman`
- **Full CI Check**: `mise run ci`
- **Multi-language Linting**: `trunk check` (runs Biome, Stylelint, Gitleaks, etc.)
- **Biome config**: one self-contained `biome.json` at the repo root — do not split it with `extends` or move it under `.trunk/configs/`. Trunk runs each linter batch in a temp sandbox that contains only the target files plus that one file (no `.git`, no `.gitignore`), so `extends` and `vcs.useIgnoreFile` fail there, and because Biome exits 1 on a config error and Trunk accepts exit 1, the failure shows up as "no issues". Ignore paths with `!!` entries in `files.includes` instead. `css.parser.tailwindDirectives` is on for the Tailwind 4 stylesheet. To debug a suspicious pass, run `trunk check -v` and read the per-invocation logs (command, exit code, stderr) in `~/.cache/trunk/repos/<hash>/out/*.yaml`.

## Architecture & Patterns

### Core Models

- **Responder**: Vetted users who answer questions.
- **Question**: Anonymous/public submissions.
- **Answer**: Responses from Responders.
- **Knowledge**: Curated articles derived from Q&A.
- **Terminology**: Glossary of terms.

### Frontend

- **CSS**: Tailwind CSS 4 with DaisyUI 5, all configured in CSS (there is no `tailwind.config.js`). `app/assets/stylesheets/application.postcss.css` loads the plugins via `@plugin`, defines the single `genderbase` dark theme (colours derived from the logo gradient, copper to indigo), registers the fonts, and holds the shared component classes (`type-display`, `type-eyebrow`, `ink-gradient`, `glow-hero`, `page-hero`, `edge-card`, `site-nav`, `site-footer`).
- **Fonts**: Sora (body/UI) and Fraunces (display, `h1` and `.type-display`) from `@fontsource-variable`. `postcss.config.js` uses `postcss-import` to inline their CSS and `postcss-url` to copy the woff2 files into `app/assets/builds/fonts/`, which Propshaft then digests. Do not reference `node_modules` font paths directly.
- **Page heroes**: marketing pages under `app/views/home/` open with `render "shared/page_hero", eyebrow:, title:, lead:, tone:` (`tone` is `primary`, `secondary`, or `accent`; anything else raises). The partial also sets the document title unless the view already did.
- **Flash**: `shared/_flash` renders `notice`/`alert` as DaisyUI alerts. Views must not render `notice` themselves. The `.notice` class is relied on by `test/test_helper.rb`.
- **JS**: Stimulus controllers in `app/javascript/controllers/`. Bundled via `esbuild`.
- **Views**: ERB templates. JSON APIs via JBuilder.

### Authentication

- Uses **Devise** with Argon2 password hashing.
- **Responders** are the primary authenticated user type.
- Devise views live in `app/views/devise/` (sessions, passwords, registrations, shared). They use the same shell as the rest of the site: `auth-page` glow, `type-eyebrow`/`type-display` heading, an `edge-card` form with DaisyUI `fieldset`/`label`/`input`, and `link-quiet` secondary links. `test/test_helper.rb` waits on `h1` "Log in" and `form#new_responder` when signing in.

## Testing Guidelines

- **Framework**: Minitest (standard Rails).
- **System Tests**: Driven by Capybara/Selenium.
- **Fixtures**: YAML fixtures in `test/fixtures/`.
- **Coverage**: tracked via SimpleCov.

## Gotchas & Notes

- **"Multipost" References**: You may see references to "Multipost" in `CONTRIBUTING.md` or other docs. This appears to be legacy/template text; the project is **Genderbase**.
- **Mise wrapper**: Prefer `mise run <task>` for complex workflows (CI, dev server) to ensure environment variables are loaded correctly.
- **Bin Wrappers**: Use `bin/rails` or `bundle exec rails` to ensure correct gem versions.
