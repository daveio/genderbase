# Styling architecture (as of 2026-08-29)

## Non-obvious facts
- Tailwind 4 + DaisyUI 5 are configured entirely in `app/assets/stylesheets/application.postcss.css` via `@plugin`. There is no `tailwind.config.js`. Before 2026-08-29 DaisyUI was never loaded (the v4 migration dropped it), so every `btn`/`badge`/`bg-base-*` class was a silent no-op.
- Single dark theme `genderbase`; colours derived from the logo gradient (copper `#97513d` -> indigo `#322d85`): primary copper `#d98a6a`, secondary lavender `#9d97ec`, accent rose `#e6a7c2` (links), base-100 `#13111f`.
- Fonts: Sora Variable (body) + Fraunces Variable `full.css` (display, `h1`, `.type-display`, with `SOFT 60 / WONK 1`). Font files reach the browser via `postcss-url` (`url: 'copy', useHash: true, hashOptions.append`) into `app/assets/builds/fonts/`; Propshaft resolves `url(fonts/...)` from `application.css`. `useHash: false` is wrong: it preserves the node_modules-relative path and writes copies into `app/node_modules/`.
- `.prose` variable overrides are unlayered on purpose (the typography plugin defines them in the utilities layer).
- Shared component classes: `type-display`, `type-eyebrow`, `ink-gradient`, `glow-hero`, `page-hero(-primary|-secondary|-accent)`, `edge-card`, `site-nav`, `nav-link(-active)`, `nav-menu(-panel)`, `site-footer`, `footer-link`, `footer-rule`, `rise(-2..4)`.
- `shared/_page_hero` partial (strict locals `title:, lead:, eyebrow:, tone:`) replaces the old copy-pasted hero blocks on the 8 `home/*` marketing pages; unknown tone raises.
- `shared/_flash` owns notice/alert rendering; `.notice` class is a contract with `test/test_helper.rb`.
- Nav is `sticky` (in flow), so views must not add top padding/margins to clear it. Mobile menu is a native `<details>`, no JS.
- Tests for view logic live in `test/views/shared/` (ActionView::TestCase).

## Out of scope / known warts
- Devise views are unstyled gem defaults.
- Footer social links point at `#`.
- `app/views/terminologies/index.original.html.erb` is a dead duplicate.
