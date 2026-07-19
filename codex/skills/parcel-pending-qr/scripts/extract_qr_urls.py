#!/usr/bin/env python3
"""Print unique Parcel Pending QR image URLs from an RFC822 message."""

from __future__ import annotations

import argparse
import quopri
import re
import sys


PATTERN = re.compile(r"https://my\.parcelpending\.com/bc/[A-Za-z0-9_-]+")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("message", nargs="?", help="RFC822 file; omit to read stdin")
    args = parser.parse_args()
    source = open(args.message, "rb").read() if args.message else sys.stdin.buffer.read()
    text = quopri.decodestring(source).decode("utf-8", errors="replace")

    seen: set[str] = set()
    for url in PATTERN.findall(text):
        if url not in seen:
            print(url)
            seen.add(url)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
