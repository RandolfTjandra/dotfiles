---
name: write-to-obsidian
description: Create, save, append to, or update Markdown notes in the user's Obsidian vault. Use when the user asks to write, export, capture, record, or save content to Obsidian; add something to their vault; create an Obsidian note; or modify an existing vault note, including recipes, journal entries, travel notes, technical notes, and miscellaneous personal notes.
---

# Write to Obsidian

Use the configured vault paths directly. Do not search for `.obsidian` directories or inspect Obsidian's application configuration unless a configured path is unavailable.

## Configured vaults

- Default active vault: `/Users/randolftjandra/Library/Mobile Documents/iCloud~md~obsidian/Documents/Home`
- Work vault: `/Users/randolftjandra/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work`

Use the Home vault unless the user explicitly asks for the Work vault or the content is clearly work-specific.

## Route the note

Honor an explicit folder or note path first. Otherwise route by subject:

- Recipes, meal plans, or cooking notes: `Cooking`
- Journal or dated personal entries: `Journal`
- Travel plans or destination notes: `Travel`
- Technical notes: `Tech`
- Company notes: `Companies`
- Film notes: `Movies`
- Parcel Pending material: `Parcel Pending`
- Anything without a clear destination: `Misc`

Use an existing folder. Do not reorganize the vault or create a new folder unless the user asks or no suitable folder exists.

## Create or update a note

1. Infer a short, descriptive filename and add the `.md` extension. Avoid `/` and `:` in filenames.
2. Check whether the exact destination already exists.
3. Preserve existing notes by default:
   - If the user asks to update, append, or replace an existing note, read it first and make only the requested change.
   - If creating a note would overwrite an unrelated file, choose a more specific filename or ask when the intended identity is ambiguous.
4. Match the target folder's prevailing level of structure when useful. Keep simple notes simple.
5. Write standard Obsidian Markdown. Use `[[wikilinks]]`, `![[embeds]]`, callouts, properties, or tags only when they add value or match nearby notes. Do not add YAML frontmatter automatically.
6. If sandbox permissions prevent direct editing, create the complete note in a writable staging location with `apply_patch`, then move it to the destination with an approved or escalated `mv` command. Never use shell redirection, `cat`, or `tee` to author the note.
7. Verify the saved destination and essential content after writing.
8. Report the vault-relative path, such as `Home → Cooking → Teriyaki Chicken Bento`.

## Guardrails

- Do not rediscover the vault on every invocation.
- Do not modify `.obsidian` settings or plugin data.
- Do not delete, rename, or overwrite existing notes unless the user explicitly requests it.
- Treat iCloud permission failures as filesystem-access issues; request the minimum required approval and retry the intended operation.
