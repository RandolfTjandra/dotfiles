#!/usr/bin/env python3
"""Manage a standard repo-local Markdown issue tracker."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from datetime import date
from pathlib import Path

STATUSES = ("backlog", "active", "done")
PRIORITY_ORDER = {"high": 0, "medium": 1, "low": 2}
FRONTMATTER_KEYS = (
    "id",
    "title",
    "status",
    "priority",
    "created",
    "updated",
    "related",
    "blocked_by",
)


@dataclass
class Issue:
    path: Path
    meta: dict
    body: str


def today() -> str:
    return date.today().isoformat()


def abort(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def derive_prefix(repo_name: str) -> str:
    tokens = [token for token in re.findall(r"[A-Za-z0-9]+", repo_name) if token]
    if not tokens:
        return "PRJ"
    if len(tokens) == 1:
        token = re.sub(r"[^A-Za-z0-9]", "", tokens[0]).upper()
        return (token[:3] or "PRJ").ljust(3, "X")

    prefix = "".join(token[0].upper() for token in tokens)
    if len(prefix) < 3:
        filler = re.sub(r"[^A-Za-z0-9]", "", tokens[-1]).upper()[1:]
        prefix = f"{prefix}{filler}"
    return (prefix[:3] or "PRJ").ljust(3, "X")


def slugify(text: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", text.lower()).strip("-")
    return slug or "untitled"


def tracker_dir(root: Path) -> Path:
    return root / "planning"


def config_path(root: Path) -> Path:
    return tracker_dir(root) / "config.json"


def readme_path(root: Path) -> Path:
    return tracker_dir(root) / "README.md"


def status_dir(root: Path, status: str) -> Path:
    return tracker_dir(root) / status


def issue_sort_key(issue: Issue) -> tuple[int, int, str]:
    match = re.search(r"-(\d+)$", issue.meta["id"])
    number = int(match.group(1)) if match else 0
    priority = PRIORITY_ORDER.get(issue.meta.get("priority", "medium"), 99)
    return (priority, number, issue.meta["id"])


def load_config(root: Path) -> dict:
    path = config_path(root)
    if not path.exists():
        abort(f"missing tracker config at {path}")
    return json.loads(path.read_text())


def write_config(root: Path, config: dict) -> None:
    config_path(root).write_text(json.dumps(config, indent=2) + "\n")


def parse_frontmatter(text: str) -> tuple[dict, str]:
    if not text.startswith("---\n"):
        abort("issue file is missing frontmatter")
    remainder = text[4:]
    end_marker = "\n---\n"
    end_index = remainder.find(end_marker)
    if end_index == -1:
        abort("malformed frontmatter")
    raw_meta = remainder[:end_index]
    body = remainder[end_index + len(end_marker) :]

    meta: dict[str, object] = {}
    for line in raw_meta.splitlines():
        if not line.strip():
            continue
        key, _, value = line.partition(":")
        key = key.strip()
        value = value.strip()
        if value.startswith("["):
            meta[key] = json.loads(value)
        elif value.startswith('"') and value.endswith('"') and len(value) >= 2:
            # Strip YAML double-quotes and unescape
            meta[key] = value[1:-1].replace('\\"', '"').replace("\\\\", "\\")
        elif value.startswith("'") and value.endswith("'") and len(value) >= 2:
            meta[key] = value[1:-1].replace("''", "'")
        else:
            meta[key] = value
    return meta, body


def yaml_quote(s: str) -> str:
    """Return s as a YAML scalar, double-quoting it when necessary."""
    # Characters/patterns that make a bare YAML string ambiguous or invalid:
    # a colon anywhere means "key: value" ambiguity; leading special chars
    # trigger other YAML interpretations.
    needs_quoting = (
        ":" in s
        or s.startswith(("#", "&", "*", "?", "|", "-", "<", ">", "=", "!", "%", "@", "`", "'", '"', "{", "}", "[", "]"))
    )
    if needs_quoting:
        return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'
    return s


def serialize_frontmatter(meta: dict) -> str:
    lines = ["---"]
    for key in FRONTMATTER_KEYS:
        value = meta.get(key, [] if key in {"related", "blocked_by"} else "")
        if isinstance(value, list):
            rendered = json.dumps(value)
        else:
            rendered = yaml_quote(str(value))
        lines.append(f"{key}: {rendered}")
    lines.append("---")
    return "\n".join(lines)


def load_issue(path: Path) -> Issue:
    meta, body = parse_frontmatter(path.read_text())
    return Issue(path=path, meta=meta, body=body.lstrip("\n"))


def find_issue_paths(root: Path) -> list[Path]:
    paths: list[Path] = []
    for status in STATUSES:
        paths.extend(sorted(status_dir(root, status).glob("*.md")))
    return paths


def load_issues(root: Path) -> list[Issue]:
    issues = [load_issue(path) for path in find_issue_paths(root)]
    return sorted(issues, key=issue_sort_key)


def ensure_tracker_root(root: Path) -> None:
    planning = tracker_dir(root)
    if planning.exists() and not config_path(root).exists():
        abort(
            f"{planning} exists without config.json; refusing to overwrite a custom planning folder"
        )


def render_issue(issue_id: str, title: str, status: str, priority: str, related: list[str], blocked_by: list[str], problem: str, goal: str, acceptance: list[str], notes: str, execution_hints: str) -> str:
    meta = {
        "id": issue_id,
        "title": title,
        "status": status,
        "priority": priority,
        "created": today(),
        "updated": today(),
        "related": related,
        "blocked_by": blocked_by,
    }
    acceptance_lines = acceptance or ["- [ ] Define implementation steps and verification."]
    acceptance_block = "\n".join(acceptance_lines)
    sections = [
        serialize_frontmatter(meta),
        "",
        f"# {issue_id} {title}",
        "",
        "## Problem",
        problem,
        "",
        "## Goal",
        goal,
        "",
        "## Acceptance Criteria",
        acceptance_block,
        "",
        "## Notes",
        notes,
        "",
        "## Execution Hints",
        execution_hints,
        "",
    ]
    return "\n".join(sections)


def write_issue(path: Path, text: str) -> None:
    path.write_text(text)


def refresh_readme(root: Path) -> Path:
    config = load_config(root)
    sections = {status: [] for status in STATUSES}
    for issue in load_issues(root):
        title = issue.meta["title"]
        priority = issue.meta.get("priority", "medium")
        sections[issue.meta["status"]].append(
            f"- `{issue.meta['id']}` {title} ({priority})"
        )

    lines = [
        "# Planning Tracker",
        "",
        "This repo uses a file-based issue tracker under `planning/`.",
        "",
        "## Source of Truth",
        "",
        "- `config.json` stores tracker metadata and the next issue number.",
        "- Issue file location is the status source of truth:",
        "  - `backlog/`",
        "  - `active/`",
        "  - `done/`",
        "- Issue frontmatter `status` must match the containing folder.",
        "",
        "## Workflow",
        "",
        "Use the global Codex skills to manage issues:",
        "",
        "- `issue-tracker`",
        "- `issue-create`",
        "- `issue-triage`",
        "- `issue-next`",
        "",
        "Those skills regenerate this file after each mutation.",
        "",
        "## Tracker Config",
        "",
        f"- Project: `{config['project_name']}`",
        f"- Prefix: `{config['project_prefix']}`",
        f"- Next issue number: `{config['next_issue_number']}`",
        "",
    ]
    for status in STATUSES:
        lines.append(f"## {status.title()}")
        lines.append("")
        lines.extend(sections[status] or ["No issues."])
        lines.append("")

    path = readme_path(root)
    path.write_text("\n".join(lines).rstrip() + "\n")
    return path


def bootstrap(root: Path, prefix: str | None, project_name: str | None) -> None:
    ensure_tracker_root(root)
    planning = tracker_dir(root)
    planning.mkdir(exist_ok=True)
    for status in STATUSES:
        status_dir(root, status).mkdir(exist_ok=True)

    if not config_path(root).exists():
        repo_name = project_name or root.name
        config = {
            "tracker_version": 1,
            "project_name": repo_name,
            "project_prefix": prefix or derive_prefix(repo_name),
            "next_issue_number": 1,
            "statuses": list(STATUSES),
        }
        write_config(root, config)
    refresh_readme(root)


def create_issue(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    bootstrap(root, args.prefix, args.project_name)
    config = load_config(root)
    issue_number = int(config["next_issue_number"])
    issue_id = f"{config['project_prefix']}-{issue_number:03d}"
    file_name = f"{issue_id}-{slugify(args.title)}.md"
    path = status_dir(root, "backlog") / file_name
    acceptance = [item if item.startswith("- [ ] ") else f"- [ ] {item}" for item in args.acceptance]
    text = render_issue(
        issue_id=issue_id,
        title=args.title,
        status="backlog",
        priority=args.priority,
        related=args.related,
        blocked_by=args.blocked_by,
        problem=args.problem or f"Track and deliver: {args.title}.",
        goal=args.goal or f"Implement and verify {args.title}.",
        acceptance=acceptance,
        notes=args.notes or "Capture context, decisions, and links here.",
        execution_hints=args.execution_hints or "Add concrete implementation notes before starting work.",
    )
    write_issue(path, text)
    config["next_issue_number"] = issue_number + 1
    write_config(root, config)
    refresh_readme(root)
    print(path)


def find_issue(root: Path, issue_id: str) -> Issue:
    matches = [
        load_issue(path)
        for path in find_issue_paths(root)
        if path.name.startswith(f"{issue_id}-")
    ]
    if not matches:
        abort(f"could not find issue {issue_id}")
    if len(matches) > 1:
        abort(f"found multiple files for {issue_id}")
    return matches[0]


def triage_issue(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    issue = find_issue(root, args.issue_id)
    destination = status_dir(root, args.status) / issue.path.name
    issue.meta["status"] = args.status
    issue.meta["updated"] = today()
    if args.blocked_by is not None:
        issue.meta["blocked_by"] = args.blocked_by
    destination.write_text(serialize_frontmatter(issue.meta) + "\n\n" + issue.body)
    if destination != issue.path:
        issue.path.unlink()
    refresh_readme(root)
    print(destination)


def summarize_next(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    issues = load_issues(root)
    active = [issue for issue in issues if issue.meta["status"] == "active"]
    backlog = [issue for issue in issues if issue.meta["status"] == "backlog"]

    print(f"project: {load_config(root)['project_name']}")
    print(f"active: {len(active)}")
    print(f"backlog: {len(backlog)}")

    if active:
        issue = active[0]
        print(f"recommended: {issue.meta['id']} {issue.meta['title']} (active)")
        return
    if backlog:
        issue = backlog[0]
        print(f"recommended: {issue.meta['id']} {issue.meta['title']} (backlog)")
        return
    print("recommended: none")


def refresh(args: argparse.Namespace) -> None:
    root = args.root.resolve()
    refresh_path = refresh_readme(root)
    print(refresh_path)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    bootstrap_parser = subparsers.add_parser("bootstrap")
    bootstrap_parser.add_argument("--root", type=Path, required=True)
    bootstrap_parser.add_argument("--prefix")
    bootstrap_parser.add_argument("--project-name")
    bootstrap_parser.set_defaults(
        handler=lambda args: bootstrap(args.root.resolve(), args.prefix, args.project_name)
    )

    create_parser = subparsers.add_parser("create")
    create_parser.add_argument("--root", type=Path, required=True)
    create_parser.add_argument("--title", required=True)
    create_parser.add_argument("--priority", default="medium", choices=tuple(PRIORITY_ORDER))
    create_parser.add_argument("--prefix")
    create_parser.add_argument("--project-name")
    create_parser.add_argument("--problem")
    create_parser.add_argument("--goal")
    create_parser.add_argument("--acceptance", action="append", default=[])
    create_parser.add_argument("--notes")
    create_parser.add_argument("--execution-hints")
    create_parser.add_argument("--related", action="append", default=[])
    create_parser.add_argument("--blocked-by", action="append", default=[])
    create_parser.set_defaults(handler=create_issue)

    triage_parser = subparsers.add_parser("triage")
    triage_parser.add_argument("--root", type=Path, required=True)
    triage_parser.add_argument("--issue-id", required=True)
    triage_parser.add_argument("--status", required=True, choices=STATUSES)
    triage_parser.add_argument("--blocked-by", action="append")
    triage_parser.set_defaults(handler=triage_issue)

    next_parser = subparsers.add_parser("next")
    next_parser.add_argument("--root", type=Path, required=True)
    next_parser.set_defaults(handler=summarize_next)

    refresh_parser = subparsers.add_parser("refresh")
    refresh_parser.add_argument("--root", type=Path, required=True)
    refresh_parser.set_defaults(handler=refresh)

    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    args.handler(args)


if __name__ == "__main__":
    main()
