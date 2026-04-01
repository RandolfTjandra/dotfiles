#!/bin/sh

set -eu

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
brewfile_path="$repo_root/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed." >&2
  exit 1
fi

brew bundle dump --file="$brewfile_path" --force --describe
echo "Updated $brewfile_path"
