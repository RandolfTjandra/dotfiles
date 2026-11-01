---
name: obsidian-journaling
description: Conversationally develop and save a dated personal journal entry in the Home Obsidian vault. Use when the user begins discussing today's or a chosen day's journal entry, wants to journal about their day, or wants to continue an entry. Do not trigger for a casual mention of today or a read-only journal lookup.
---

# Obsidian journaling

Help the user tell the story of their day through natural conversation, then turn their answers into polished first-person journal prose in that day's entry. This is a conversation, not a questionnaire or a required daily routine.

## Follow the conversation

- Use what the user has already shared; do not ask them to repeat it. If they have not started telling the story, open with one easy question about the day.
- Ask one question at a time by default, especially for voice conversations, and wait for the answer. Follow interesting details and the user's chosen topics rather than cycling through categories or imposing a checklist.
- Ask about feelings or meaning when it fits, without assuming either. Let brief answers stay brief, accept topic changes, and respect a desire to stop or skip something.
- Resolve the entry date from the conversation. Interpret today and yesterday using the user's local date and timezone, not the execution host's clock. Ask only if the intended date is ambiguous; keep the chosen date across follow-ups unless the user changes it.
- Once there is enough substance, shape it into prose and save at a natural pause or when the user asks. Do not require a separate approval ritual for ordinary saves within the journaling request. If they ask only to talk or draft, respect that and do not save yet.

## Write in their voice

- Write as “I,” preserving the user's meaning, opinions, uncertainty, and emotional intensity. Smooth spoken repetition and grammar while keeping their natural, conversational voice.
- Never invent events, feelings, motives, dialogue, lessons, or a positive ending. Clarify important ambiguity or omit an unsupported detail.
- Use readable paragraphs with a natural flow. Do not save the interview transcript, assistant questions, or a bullet-point recap unless requested. Avoid making every entry follow the same narrative arc.
- Personal reflections about work still belong in this personal journal unless the user chooses another destination.

## Save to the correct entry

Home vault: `/Users/randolftjandra/Library/Mobile Documents/iCloud~md~obsidian/Documents/Home`

Entry path: `Journal/YYYY-MM/YYYY-MM-DD.md`, using the chosen date. Create the month folder if needed. Honor an explicit alternate destination.

Keep all journal prose written through this skill in a separate Markdown section headed `## AI-assisted journaling`, clearly distinguished from prose the user types themselves. Use plain paragraphs separated by blank lines within that section. Do not add a note title, YAML frontmatter, tags, properties, or additional headings automatically. Preserve existing `[[wikilinks]]` where appropriate.

Read the exact entry before editing. Preserve all existing human-written text outside the AI-assisted section; do not move it into that section or polish it unless explicitly asked. If no AI-assisted section exists, append the heading and new prose after the existing content. If one exists, reuse it across later sessions for the same date rather than creating a duplicate heading. The section ends at the next Markdown heading of level 1 or 2, or at the end of the file; insert new prose before that boundary and preserve other sections.

Within the AI-assisted section, append new material by default and revise an existing passage when the user asks for a correction or rewrite. Track what has already been saved so later saves add only new material and corrections, without duplicating earlier paragraphs. Keep all skill-authored journal prose within the AI-assisted section.

Immediately before writing, re-read the destination to account for intervening edits or iCloud updates. Apply the intended changes to that latest content. A missing final newline is not a paragraph separator: add a blank line before appending prose.

Use the complementary [write-to-obsidian skill](../write-to-obsidian/SKILL.md) for filesystem writing conventions and permission handling. If access is blocked, prepare the complete updated note in a writable staging location using `apply_patch`, then use an approved or escalated move to save it. Do not author notes through shell redirection, `cat`, or `tee`. Do not modify Obsidian settings or reorganize other entries.

After saving, verify the destination and changed content, including preservation of existing paragraphs and other sections, and confirm that the AI-assisted heading has not been duplicated and all new prose is inside it. Briefly confirm the date and link to the saved entry. Continue with one relevant follow-up if the user is still journaling; do not force more questions after they are finished. If saving fails, say it remains unsaved and retain the draft for retry.
