from __future__ import annotations

import json
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "issue_tracker.py"


class IssueTrackerTests(unittest.TestCase):
    def test_bootstrap_derives_prefix_for_multi_word_repo(self) -> None:
        with tempfile.TemporaryDirectory(prefix="issue-tracker-") as temp_dir:
            root = Path(temp_dir) / "my-inventory"
            root.mkdir()

            subprocess.run(
                ["python3", str(SCRIPT), "bootstrap", "--root", str(root)],
                check=True,
                capture_output=True,
                text=True,
            )

            config = json.loads((root / "planning" / "config.json").read_text())
            self.assertEqual(config["project_prefix"], "MIN")
            self.assertTrue((root / "planning" / "README.md").exists())

    def test_create_and_triage_issue(self) -> None:
        with tempfile.TemporaryDirectory(prefix="issue-tracker-") as temp_dir:
            root = Path(temp_dir) / "dotfiles"
            root.mkdir()

            create = subprocess.run(
                [
                    "python3",
                    str(SCRIPT),
                    "create",
                    "--root",
                    str(root),
                    "--prefix",
                    "DOT",
                    "--title",
                    "Add repo issue tracker",
                    "--acceptance",
                    "Tracker bootstraps in a clean repo.",
                ],
                check=True,
                capture_output=True,
                text=True,
            )

            issue_path = Path(create.stdout.strip())
            self.assertTrue(issue_path.exists())
            self.assertIn("DOT-001", issue_path.name)

            subprocess.run(
                [
                    "python3",
                    str(SCRIPT),
                    "triage",
                    "--root",
                    str(root),
                    "--issue-id",
                    "DOT-001",
                    "--status",
                    "active",
                ],
                check=True,
                capture_output=True,
                text=True,
            )

            active_files = list((root / "planning" / "active").glob("DOT-001-*.md"))
            self.assertEqual(len(active_files), 1)
            content = active_files[0].read_text()
            self.assertIn("status: active", content)
            self.assertIn("`DOT-001` Add repo issue tracker (medium)", (root / "planning" / "README.md").read_text())

    def test_next_summary_prefers_active_then_backlog(self) -> None:
        with tempfile.TemporaryDirectory(prefix="issue-tracker-") as temp_dir:
            root = Path(temp_dir) / "dotfiles"
            root.mkdir()

            subprocess.run(
                [
                    "python3",
                    str(SCRIPT),
                    "create",
                    "--root",
                    str(root),
                    "--prefix",
                    "DOT",
                    "--title",
                    "First issue",
                    "--priority",
                    "high",
                ],
                check=True,
                capture_output=True,
                text=True,
            )

            summary = subprocess.run(
                ["python3", str(SCRIPT), "next", "--root", str(root)],
                check=True,
                capture_output=True,
                text=True,
            )
            self.assertIn("recommended: DOT-001 First issue (backlog)", summary.stdout)


if __name__ == "__main__":
    unittest.main()
