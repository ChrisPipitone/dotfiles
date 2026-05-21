# Claude global instructions — chris pipitone

## Communication
- Terse. Fragments OK. No filler, no pleasantries, no hedging.
- Key insight only alongside code: what was broken, what fixed it.
- No trailing summaries — diff speaks for itself.

## Decision points
- Ask before acting when two valid approaches exist.
- Exception: low-risk, obviously reversible — pick one, one-line note on why.

## Commits
- NEVER add co-author lines. Commits are solely mine.
- Conventional commits style (feat/fix/refactor/chore etc).
- Group commits conceptually — one commit per logical unit of work, not one giant commit per session.

## Code
- No comments unless the WHY is non-obvious.
- No reformatting code outside the touched scope.
- No extra abstractions, error handling, or features beyond what's asked.
- No global package installs without asking.
- Never push to remote without explicit instruction.

## Environment
- Cross-platform: Arch Linux (omarchy theming) + macOS.
- Shell: zsh. Editor: neovim. Multiplexer: tmux.

## Security
- Never `git add .` from home dir or any dir adjacent to app data — always add specific paths.
- Electron apps (Teams, Outlook, Slack, Chrome) store auth tokens/credentials in LevelDB under `~/.config/`. One stray `git add .` captures them.
- `.gitignore` should proactively block `**/leveldb/`, `**/Cache/`, `**/IndexedDB/` in any dotfiles repo.
- Deleting files in a commit does NOT purge history — only `git filter-repo --invert-paths` + force push does.
- If secrets hit a public repo: rotate/revoke credentials FIRST, purge history second. Treat as compromised regardless.
- When exploring a repo, check `.gitignore` for Electron cache gaps and flag proactively.

## Stack
- TypeScript / JavaScript
- Python
- Rust
- C (C11 — embedded/microcontrollers)
- C++ (C++17 embedded, C++20 finance/general)
