# Vim Grimory — Android / Termux

This is the lightweight **`android-version`** branch for native Neovim on
Android (Termux, aarch64). The complete desktop setup remains on `master`.

## Intent

- LazyVim with **Tokyo Night Storm** and Nerd Font glyphs
- Standard editing, Git integration, file search and local completion
- Android clipboard via `termux-clipboard-set/get` if both exist
- LSP only for language servers already installed in Termux and on PATH
- **No** AI, Copilot, Hermes, CodeCompanion, Minuet or OpenCode
- **No** automatic Mason downloads or Tree-sitter grammar builds
- No desktop-only debugger/test adapters or custom build hooks

## Installation / update on the tablet

Keep this Git repository inside Termux private storage
(`~/.config/nvim`), not Android shared storage.

```sh
cd ~/.config/nvim
git branch --show-current
git status --short
git pull --ff-only origin android-version
nvim
```

If the Git worktree has uncommitted changes, inspect and save them before
pulling. In Neovim run `:Lazy` and `:checkhealth`.

## Configuration

- `init.lua`: boot LazyVim
- `lua/config/lazy.lua`: import only core LazyVim + Android plugins
- `lua/config/options.lua`: Termux clipboard and terminal options
- `lua/android/plugins/core.lua`: platform-safe plugin overrides
- `lazyvim.json`: no optional language extras at baseline

The previous desktop plugin files were intentionally removed from this
branch and remain available in `master` and Git history.

## Notes

The native language servers must be installed explicitly and tested.
Tree-sitter parsers, debugger adapters, test adapters and per-language
tooling will be reintroduced after this baseline is verified on-device.
No direct modification to the tablet occurs when commits are made on GitHub.
