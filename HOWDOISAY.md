# How Do I Say…? — presentation ideas

_Drafted 2026-08-29 as a spike, so it holds ideas and no code; nothing here is built yet._

## 1. What the section is for, and where the page misses

The README's promise:

> quick and easy answers on what terminology to use, words which they should use, words which they should avoid, and why.

The visitor is a parent, partner, friend, or colleague who has been *sent here* by a trans or non-binary person. They arrive with a sentence half-formed in their head, something like "how do I talk about my son's old name?", and a fear of getting it wrong.

The current page, `app/views/terminologies/index.html.erb`, is a glossary: term, definition, usage example, related terms. A glossary answers *"what does X mean?"*. The page title asks *"how do I say…?"*, which is a different question. The visitor already knows what they want to express and needs the **words**, the **words to drop**, and the **reason**, in that order, fast.

Three implementation facts make this a good moment to rethink instead of restyle:

1. The index is entirely hardcoded HTML. `@terminologies` from the database is never rendered; the seven seeded terms in `db/seeds.rb` are invisible.
2. The search box posts to `data-controller="search-form"`, which does not exist in `app/javascript/controllers/`, and `TerminologiesController#index` ignores `params[:query]`. Search is dead.
3. The model is `term / definition / info`. It has no column for "avoid", "say instead", "why", or "who this applies to", the four things the README asks for.

## 2. The reframe: answer sentences, not define words

Make the unit of content a **situation**, written in the visitor's own voice, with a fixed answer shape:

```plaintext
I want to…  talk about someone's life before they transitioned

  SAY      their current name and pronouns, even in the past tense
  AVOID    the old name · "when he was a girl" · "back when she was Steven"
  WHY      they were the same person then; the old name is often painful
  EXAMPLE  "Priya grew up in Leeds and moved here for uni."
  IN DOUBT "Is it all right if I mention your school years, or would you rather I didn't?"
```

Every idea below hangs off this shape. The glossary stays as the reference layer underneath (see §4).

## 3. Do now: five ideas, ranked

### 3.1 Situation-first cards ("I want to…")

The page opens with situations, not terms. Each card is one `edge-card` with the situation as its heading (`type-display`), then Say / Avoid / Why as three labelled rows. Say and Avoid are visible; Why, Example, and In doubt sit behind a native `<details>`, with no JS, the same pattern as the mobile nav.

Grouped under four eyebrow headings so the page scans:

- **Talking about someone**: pronouns, names, the past, bodies and transition
- **Talking to someone**: they've just come out, they've told you their pronouns, you slipped up
- **Groups, forms, and work**: greeting a room, HR and titles, a colleague transitions
- **Words to know, words to weigh**: reclaimed terms, dated terms, slurs

Hero: `render "shared/page_hero", eyebrow: "Language", title: "How do I say…?", lead: "Quick answers on what to say, what to drop, and why. Nobody expects you to get it right first time.", tone: "accent"`, which matches the accent-toned Language card on the home page.

Effort: half a day for the view once the model exists (§5). The content is the real work (§6).

### 3.2 Say / Avoid / Why with a four-level rating

Not everything is right or wrong. Each phrase carries a rating, colour-coded with the existing theme tokens:

| Rating | Meaning | Theme colour |
| --- | --- | --- |
| **Say** | Safe with anyone | `success` `#8fcf9a` |
| **Depends** | Fine if the person uses it; follow their lead | `info` `#7fb5e6` |
| **Avoid** | Dated or imprecise; a better word exists | `warning` `#e9c46a` |
| **Never** | A slur | `error` `#ea7f7f` |

Rendered as a `badge` beside each phrase. The **Depends** level is the one that earns trust. Telling people that "preferred pronouns", "queer", "MTF", and "guys" are contextual instead of forbidden matches the good-faith tone of the rest of the site, and it stops the page reading as a list of rules.

Effort: an enum on the phrase model and one badge partial. An hour.

### 3.3 Search that accepts the wrong word

The placeholder is the page title, `How do I say…`, and the visitor finishes the sentence. Crucially, search matches **avoided phrases as well as preferred ones**. People search with the vocabulary they already have:

- "sex change" finds the transition card
- "born a man" finds the assigned-at-birth card
- "real name" finds the old-name card

That is only possible if avoided phrases are rows, not free text in a `why` paragraph (§5). Live filtering runs through a small Stimulus controller that submits on input and swaps the list with Turbo. The existing form already expects `search-form#submit`, so this finishes what is half-there.

Effort: a model scope with `LIKE` across situation and phrase, one Stimulus controller, a Turbo frame around the list. Half a day, including a controller test.

### 3.4 Scripts, not just vocabulary

The most common real question is about a whole sentence: *"what do I say when…"*. Some cards need a line you can borrow:

- Someone tells you their pronouns: **"Thanks for letting me know."** Then use them.
- You slip: **"He — sorry, she — said…"** and carry on. No speech.
- Someone comes out to you: **"Thank you for trusting me. What name and pronouns would you like me to use?"**
- You are about to ask about surgery: **don't.** Unless you are their clinician or they raised it.

Present these as a quoted line in the card, visually distinct: the `prose` blockquote style, or the accent-bordered `alert` already used on the About page. The "In doubt" row is a script every time. It tells the visitor that asking is fine, which mirrors the Good Faith policy.

Effort: content only. The `example` and `if_in_doubt` columns carry it.

### 3.5 Audience filter: "I'm a…"

The right phrasing shifts with the relationship. A chip row above the cards: **parent · partner · friend · colleague or manager · teacher · writing about someone**. Selecting one keeps every card that applies and drops the rest. The workplace card is noise for a parent, and "don't out them to the family" is noise for HR.

Ratings can also shift by audience: "birth name" is *Avoid* in conversation and *Say* on a legal form. That is a later refinement; start with card-level tags.

Effort: a tags column plus a filter param. Two hours.

## 4. Later

- **Glossary as a reference tab.** Keep `Terminology` as an A to Z list on a second tab ("Words"), and link terms from inside cards, so "assigned at birth" jumps to its definition. Demote it; do not delete it.
- **Pronoun grammar table and practice paragraph.** Pick a set such as they/them, xe/xem, or ze/zir and see one paragraph rendered with it, with the subject, object, possessive, and reflexive forms alongside. The single most asked question, and a small Stimulus controller.
- **Permalinks with clean slugs.** `/language/old-names`, `/language/before-transition`. People are *sent* this page; let them send one card. `Knowledge` already has the `parameterize` slug pattern to copy.
- **Cross-links.** `Knowledge` already has `pronouns` and `terminology` categories. List matching articles at the foot of a card, and end every card with "Still unsure? Ask anonymously", linking to `new_question_path`.
- **"Reviewed on" date.** Language shifts; a date per card says so honestly and is the cheapest trust signal on the page. Add UK / US notes where usage differs; "Mx" is far more established in the UK.
- **Empty and unsure states.** No results? Show "Nothing yet for that. Ask us, and it will probably become a card." Search misses become questions, and questions become cards.

## 5. Data model sketch

Two jobs, two models: `Terminology` stays as the glossary, and situations are new.

```ruby
# db/migrate/..._create_phrasings.rb
create_table :phrasings do |t|
  t.string  :situation, null: false            # "Talking about someone's life before they transitioned"
  t.string  :slug, null: false
  t.string  :group, null: false                # about_someone / to_someone / groups_and_work / words_to_weigh
  t.text    :why, null: false
  t.text    :example
  t.text    :if_in_doubt
  t.json    :audiences, null: false, default: []   # SQLite: JSON column, validated against an AUDIENCES constant
  t.date    :reviewed_on
  t.integer :position, null: false, default: 0
  t.references :responder, null: false, foreign_key: true
  t.timestamps
  t.index :slug, unique: true
end

# Every phrase attached to a situation, with a rating. This is what search hits.
create_table :phrasing_alternatives do |t|
  t.references :phrasing, null: false, foreign_key: true
  t.string  :phrase, null: false               # "born a man"
  t.integer :rating, null: false               # enum: say / depends / avoid / never
  t.string  :note                              # "unless they use it for themselves"
  t.integer :position, null: false, default: 0
  t.timestamps
end

# Situations reference glossary terms
create_join_table :phrasings, :terminologies
```

Why phrases are rows and not a text column: search on the wrong word in §3.3, a rating per phrase in §3.2, and per-audience overrides later in §3.5 all need each phrase addressable.

Note: `config/database.yml` is **SQLite**, and `CLAUDE.md` wrongly states PostgreSQL. No array columns; hence `json` for `audiences`.

Search, first cut:

```ruby
# app/models/phrasing.rb
scope :matching, ->(query) {
  pattern = "%#{sanitize_sql_like(query)}%"
  left_joins(:phrasing_alternatives)
    .where("phrasings.situation LIKE :q OR phrasing_alternatives.phrase LIKE :q", q: pattern)
    .distinct
}
```

## 6. Seed content starter

Thirteen situations to launch with. Check the wording against the GLAAD Media Reference Guide, the Trans Journalists Association style guide, and Stonewall's glossary before it ships; these are mainstream positions, not novel ones.

1. **Someone has just told me their pronouns.**
   Say: "Thanks for letting me know." Then use them. If you slip, fix it in three words and carry on.
   Avoid: a long apology · "I'll try, but it's hard for me" · "preferred pronouns" [Depends: pronouns are not a preference, though few people will mind].
   Why: a big apology makes it about you and asks them to reassure you.

2. **Talking about someone's life before they transitioned.**
   Say: their current name and pronouns, even for the past.
   Avoid: the old name · "when he was a girl" · "back when she was Steven".
   Why: they were the same person then; the old name is often painful.
   Example: "Priya grew up in Leeds and moved here for uni."

3. **Referring to a trans person's old name.**
   Say: "the name she used before", and only if you need to.
   Avoid: saying the name · "real name" [Avoid] · "birth name" in conversation [Depends: fine on a legal form].
   Why: "real name" says the current one is fake.

4. **Describing the sex someone was assigned at birth.**
   Say: "assigned female / male at birth", written AFAB / AMAB, and only when it is relevant, such as healthcare.
   Avoid: "born a man" · "biologically male" · "genetically…" · "used to be a woman".
   Why: a trans woman did not stop being a woman; "biological" is vague and is mostly used to argue trans people are not who they say.

5. **Talking about transition, hormones, and surgery.**
   Say: "transition" · "gender-affirming care" · "gender-affirming surgery", if it comes up at all.
   Avoid: "sex change" · "the operation" · "pre-op / post-op" · "fully transitioned".
   Why: transition is social, legal, and medical, and not everyone has surgery. It is also medical history; you would not ask a colleague about their hysterectomy.
   In doubt: don't ask, unless you are their clinician or they raised it.

6. **Using "transgender" and "trans" in a sentence.**
   Say: as an adjective, so "a trans woman", "transgender people", "he's trans".
   Avoid: "a transgender" · "transgenders" · "transgendered".
   Why: it describes a person, like "tall" or "Welsh"; the noun forms reduce them to the label.

7. **Which way round is "trans woman"?**
   Say: a trans woman is a woman; a trans man is a man. Two words.
   Avoid: "male-to-female / MTF" and "female-to-male / FTM" [Depends: some people use them for themselves] · "transwoman" as one word.
   Why: MTF centres the starting point, not the person.

8. **Someone is non-binary. What do I call them?**
   Say: they/them unless told otherwise · "person", "partner", "sibling", "child" · "Mx" as a title.
   Avoid: "it" [Never] · "he-she" [Never] · "enby" [Depends: casual and in-group].
   Why: singular "they" has been standard English for centuries.
   Grammar box: they / them / their / theirs / themself. "Alex left their coat; I'll give it to them."

9. **Someone I love has just come out to me.**
   Say: "Thank you for trusting me." · "What name and pronouns would you like me to use?" · "I love you — that hasn't changed."
   Avoid: "Are you sure?" · "Is this a phase?" · "I always knew." · "But you were such a beautiful girl." · "What did I do wrong?"
   Why: they have usually thought about it for years; your first sentence is the one they will remember.
   In doubt: "Who else knows? Who can I talk to about this?", so you do not out them by accident.

10. **A colleague has transitioned. What do I say at work?**
    Say: the new name and pronouns from day one · correct others briefly ("It's Maya, actually") · nothing about their appearance you would not say to anyone else.
    Avoid: "You look so much better as…" · "I preferred…" · "So what do we call you now?" in front of the room · retelling it to people who do not need to know.
    Why: they have usually planned this carefully; your job is to be normal.
    In doubt: privately, "Is there anything you'd like me to do, or not do?"

11. **"Identifies as" versus "is".** [Depends]
    Say: "she is a woman" · "he's a trans man".
    Avoid: "identifies as a woman" as your default · "self-identifies as".
    Why: it is often used to imply doubt, even when meant kindly. "Is" is simpler and kinder.

12. **Greeting a group.**
    Say: "everyone" · "folks" · "team" · "all".
    Avoid: "ladies and gentlemen" · "ladies" · "guys" [Depends: many read it as neutral, so know your room].
    Why: it costs nothing and nobody is left out.

13. **Words that used to be common, and words that are slurs.**
    "Transsexual" is older and medical, and some trans people use it for themselves; do not apply it to someone who does not. [Depends]
    "Queer" is widely reclaimed and fine as an umbrella in most settings, but it is still used as an insult, so follow the person. [Depends]
    "Hermaphrodite" is outdated for intersex people; say "intersex". [Avoid]
    "Tranny", "shemale", "he-she", and "trap" are slurs. [Never]
    Why: this card is what the rating system is for, because not everything is right or wrong.

## 7. Copy that changes elsewhere

- Home page Language card in `app/views/home/index.html.erb`: replace "A glossary of gender terminology, with examples of how each term is used" with "What to say, what to drop, and why, for the conversation you're about to have."
- Nav and footer label stays "How Do I Say…?", which is already the best thing on the page. Use a real ellipsis `…` in place of three dots, as the README does.
- About page: replace "A comprehensive terminology guide for simple questions of language" with "Quick answers on what to say and what to avoid, and a glossary behind it."

## 8. Recommended first slice

One PR, roughly a day:

1. `Phrasing` + `PhrasingAlternative` models, migrations, validations, model tests.
2. Seed cards 1, 2, 4, 5, and 9 from §6.
3. Replace the hardcoded index with the hero, grouped situation cards, and the rating badges (§3.1 + §3.2). Render from the database.
4. Wire search to `Phrasing.matching` with the Stimulus controller the form already expects (§3.3).
5. Update the home card copy (§7).

Audience filter, permalinks, glossary tab, and the pronoun table follow as separate PRs.

Also worth a separate fix: `CLAUDE.md` says PostgreSQL; the app runs on SQLite.
