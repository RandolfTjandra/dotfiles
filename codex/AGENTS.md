When generating git commit messages, provide enough context for yourself so you can scan it for useful information when asked about commits.

If a commit is made to resolve some linear task, then the commit message should start with that linear task code like this: [{project}-{issue number}]. For example: `[DEV-1]`. If there is no issue, just start with `[None] ` Then enter the description of the changes.

When the user discusses physical belongings, home inventory, storage locations, rooms, or where an item is kept, prefer the `stash` MCP as the source of truth.

When the user implies an add, move, update, rename, or removal of owned items or locations, update `stash` instead of only answering in prose.

On macOS, GitHub CLI credentials are stored in the Keychain. Always run `/opt/homebrew/bin/gh auth status -h github.com` with sandbox escalation. Never conclude that GitHub authentication is invalid from a sandboxed check; retry with host access before asking the user to log in.
