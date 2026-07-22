#!/usr/bin/env python3
"""Tests for reconcile_qr_codes.py using synthetic, non-live QR values."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from reconcile_qr_codes import filename, reconcile


class ReconcileQrCodesTests(unittest.TestCase):
    def test_reports_only_aggregate_status_for_mixed_existing_and_new_codes(self) -> None:
        first = b"https://my.parcelpending.com/bc/test-existing"
        second = b"https://my.parcelpending.com/bc/test-new"
        raw = b"Content-Transfer-Encoding: quoted-printable\r\n\r\n" + first + b"=\r\n\n" + second

        with tempfile.TemporaryDirectory() as temporary_directory:
            destination = Path(temporary_directory)
            (destination / filename(first)).write_bytes(b"placeholder")
            result = reconcile([raw], destination)

        self.assertEqual(result["candidate_qr_count"], 2)
        self.assertEqual(result["already_present_qr_count"], 1)
        self.assertEqual(result["new_qr_count"], 1)
        self.assertTrue(result["contains_new_qr"])
        self.assertTrue(result["reconciled"])

    def test_deduplicates_the_same_code_across_messages(self) -> None:
        raw = b"https://my.parcelpending.com/bc/test-duplicate"

        with tempfile.TemporaryDirectory() as temporary_directory:
            result = reconcile([raw, raw], Path(temporary_directory))

        self.assertEqual(result["candidate_qr_count"], 1)
        self.assertEqual(result["already_present_qr_count"], 0)
        self.assertEqual(result["new_qr_count"], 1)
        self.assertTrue(result["reconciled"])


if __name__ == "__main__":
    unittest.main()
