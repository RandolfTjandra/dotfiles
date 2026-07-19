---
name: parcel-pending-qr
description: Save live Parcel Pending locker QR codes for offline access. Use when the user asks to find Parcel Pending delivery emails, extract their QR-code images, save new codes to an Obsidian folder, or avoid duplicate reminder codes.
---

# Parcel Pending QR

Save only original delivery notices, not reminders.

## Workflow

1. Search the connected mailbox for messages from `no-reply@parcelpending.com` received on or after `2026-07-11`. Treat this as the initial setup baseline; do not backfill older notices.
2. Fetch candidate messages and retain only those with the exact subject `You have a Parcel Pending!`. Exclude every `Daily Reminder:` message, even if Gmail's subject search includes it.
3. Read each retained message with raw MIME enabled. Extract the QR image URL matching `https://my.parcelpending.com/bc/...`; use `scripts/extract_qr_urls.py` if helpful.
4. Save each image to the user's configured Obsidian destination. Default destination: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Home/Parcel Pending`.
5. Name images `parcel-pending-<first 16 hex characters of SHA-256 of QR URL>.png`. If that exact filename exists, skip it. Do not use locker number, delivery time, access code, or reminder state for deduplication.
6. Maintain `Parcel Pending.md` in the same folder. For every new image, add `- [ ] ![[<image filename>]]`; an unchecked item means not picked up and the user ticks it after collection. Preserve all existing checklist state and entries.
7. Download the QR URL as a PNG, follow redirects, and verify that it is a non-empty image. Report only the number added and skipped; do not echo QR URLs or access codes.

## Safety

- Treat QR images and URLs as locker credentials. Do not expose them in chat, logs, filenames, or notes.
- Ask before writing outside the current workspace or changing the configured destination.
- Do not delete expired or old images unless the user explicitly asks.
- If mailbox access is unavailable, explain which connection is needed rather than fabricating codes.
