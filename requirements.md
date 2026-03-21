# Requirements

Most installable dependencies now live in `Brewfile`.

Use:

```bash
brew bundle --file Brewfile
```

Refresh the manifest after package changes with:

```bash
./scripts/update-brewfile.sh
```

Keep this file for setup details that Homebrew cannot express cleanly, such as:

- macOS permissions needed for Yabai, SKHD, SketchyBar, Karabiner, and Hammerspoon
- Environment-specific tools or credentials that should not be tracked in the repo
- Manual post-install steps for apps that need extra configuration
