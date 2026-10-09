# Vim Grimory on Android / Termux

This file applies only to the `android-version` branch. The desktop
`master` branch is not part of the Android configuration.

## Design constraints

- Keep existing portable features: Telescope, Tree-sitter, Blink, snippets,
  tmux navigator, UI, LSP, formatting, tests and debugger plugin definitions.
- Prefer `pkg` or language-native installers for tools: Mason's upstream
  download packages may not provide Android-compatible binaries.
- Compile Tree-sitter parsers with the native Termux Clang toolchain.
- Keep AI integrations disabled on Android.
- Never use desktop `wl-copy`, `wl-paste`, `xclip` or `xsel` in Termux.

## Prerequisites / smoke checks

In the Termux shell (not inside Neovim):

```sh
nvim --version | head -n 2
command -v clang rg fd git
command -v termux-clipboard-set termux-clipboard-get
printf 'Termux clipboard check' | termux-clipboard-set
termux-clipboard-get
```

If Clang, ripgrep or fd is missing, install with the Termux repository:

```sh
pkg install clang make cmake ripgrep fd
```

Tree-sitter's `main` branch needs its own compatible `tree-sitter` CLI
and a C compiler; verify `tree-sitter --version` before attempting parser
installation. Binary compatibility and parser compilation must be tested
on the actual Android device.

In Neovim:

```vim
:Lazy
:checkhealth
:Telescope find_files
:TSInstall c
:InspectTree
```

Open a C source buffer before running `:InspectTree`. An LSP server
requires its actual executable in PATH: `:LspInfo` or `:checkhealth vim.lsp`
helps inspect activation.

## Keybindings

- `Ctrl+V` retains Neovim visual block selection.
- Android clipboard: in normal mode use `"+p`, in visual mode `"+y`.
  With the Termux provider detected, normal yanks also use the system clipboard.
- `<leader>cM` copies Neovim messages; `<leader>ce` copies the last errors.
- `<leader>cm` remains available for Mason.
- `Ctrl+H/J/K/L` is handled by `vim-tmux-navigator`, which also requires
  matching tmux-side mappings in `~/.tmux.conf`. That file is not in this repo.

## Limitations

A plugin being restored does not establish that its external executable
runs on Android: native DAP adapters (especially CodeLLDB), Java tools,
Haskell tools, and some optional plugin build steps still need on-device
validation. No plugin is removed merely for lacking that validation.

This PR does **not** make any change to `master` or the tablet's local files.
