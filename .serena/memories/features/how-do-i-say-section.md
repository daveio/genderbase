# "How Do I Say…?" section (as of 2026-08-29)

Route: `resources :terminologies, path: "language"` → `/language`. Nav/footer/home label is "How Do I Say...?".

## Non-obvious facts
- `app/views/terminologies/index.html.erb` is **entirely hardcoded HTML** (five static glossary entries). `@terminologies` from the DB is never rendered; the seven seeded terms in `db/seeds.rb` are invisible on the site.
- The index search form uses `data-controller="search-form"`, which **does not exist** in `app/javascript/controllers/` (only `question_form_controller.js`), and `TerminologiesController#index` ignores `params[:query]`. Search is dead.
- `Terminology` model is just `term / definition / info / responder_id`. No fields for "avoid / say instead / why / audience", which is what README.md promises for this section.
- `_terminology.html.erb`, `show`, and `_form` are untouched Rails scaffold output (inline `style=`, prints `responder_id`).
- The DB is **SQLite** (`config/database.yml`), not PostgreSQL as `CLAUDE.md` claims. Use `json` columns, not array columns.
- `HOWDOISAY.md` at the repo root holds the presentation ideas and a proposed `Phrasing` + `PhrasingAlternative` data model (situation-first cards with Say / Avoid / Why and a four-level rating: say / depends / avoid / never). Nothing from it is built yet.
- Theme status colours exist for the rating idea: success `#8fcf9a`, info `#7fb5e6`, warning `#e9c46a`, error `#ea7f7f`. See `mem:styling/theme-and-asset-pipeline`.
- `Knowledge.categories` already includes `pronouns` and `terminology`, useful for cross-linking cards to articles.
