#!/usr/bin/env python3
"""Safely decide whether Parcel Pending delivery messages contain new QR codes.

Reads raw RFC822 message files (or stdin), derives the canonical QR-image names,
and compares those names with the configured destination. It intentionally emits
only aggregate counts and a boolean: QR URLs, access codes, and filenames never
appear in its output.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import quopri
import re
import sys
from email import policy
from email.parser import BytesParser
from pathlib import Path


QR_URL_PATTERN = re.compile(rb"https://my\.parcelpending\.com/bc/[A-Za-z0-9_-]+")


def qr_urls(source: bytes) -> set[bytes]:
    """Return unique QR URLs found in raw and decoded MIME text."""
    texts = [source, quopri.decodestring(source)]
    try:
        message = BytesParser(policy=policy.default).parsebytes(source)
    except (ValueError, UnicodeError):
        message = None

    if message:
        for part in message.walk():
            if part.is_multipart():
                continue
            payload = part.get_payload(decode=True)
            if payload:
                texts.append(payload)

    return {match.group(0) for text in texts for match in QR_URL_PATTERN.finditer(text)}


def filename(url: bytes) -> str:
    digest = hashlib.sha256(url).hexdigest()[:16]
    return f"parcel-pending-{digest}.png"


def reconcile(sources: list[bytes], destination: Path) -> dict[str, int | bool]:
    candidates = {filename(url) for source in sources for url in qr_urls(source)}
    present = {name for name in candidates if (destination / name).is_file()}
    new = candidates - present

    result: dict[str, int | bool] = {
        "candidate_qr_count": len(candidates),
        "already_present_qr_count": len(present),
        "new_qr_count": len(new),
        "contains_new_qr": bool(new),
        "reconciled": len(candidates) == len(present) + len(new),
    }
    if not result["reconciled"]:
        raise RuntimeError("QR reconciliation invariant failed")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--destination", required=True, type=Path)
    parser.add_argument(
        "messages",
        nargs="*",
        type=Path,
        help="raw RFC822 message files; omit to read one message from stdin",
    )
    args = parser.parse_args()

    if not args.destination.is_dir():
        parser.error("--destination must be an existing directory")

    sources = [path.read_bytes() for path in args.messages] if args.messages else [sys.stdin.buffer.read()]
    print(json.dumps(reconcile(sources, args.destination), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
