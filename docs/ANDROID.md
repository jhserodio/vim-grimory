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

The earlier `opts.install.compilers = { "clang", "cc" }` option was removed
because the **current LazyVim / Tree-sitter main branch no longer supports it**.
This does **not** remove Clang: `lua/config/options.lua` selects `CC=clang`
and `CXX=clang++` when available, without overriding your existing `CC/CXX`
choices. The Tree-sitter CLI uses the system native compiler.

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

## Clipboard: Neovim ↔ Android

The configuration uses Neovim's **built-in** `termux` provider if both
`termux-clipboard-set` and `termux-clipboard-get` exist. In that case,
`clipboard=unnamedplus` makes normal Vim yanks (`y`, `yy`) copy to the
tablet clipboard, while normal `p` reads the tablet clipboard.
This works independently of the Android application's copy/paste UI.

To verify both directions:

1. In another Android app, copy the text `FROM_ANDROID`. In Neovim, run
   `:put +` (or in Normal mode press `"+p`). The text should appear.
2. In a Neovim text file, put the cursor on a test line and press `yy`.
   In Termux, run `termux-clipboard-get`, or paste into another Android app.
   The yanked line should appear there.

Inside Neovim, `:set clipboard?` should display `unnamedplus` and
`:echo g:clipboard` should display `termux`. If the commands are missing
or their Android access fails, the clipboard integration is **not yet working**;
verify the command availability and permissions on the tablet first.

## Keybindings

- `Ctrl+V` retains Neovim Visual Block mode; terminal-level paste shortcuts
  depend on the terminal / Samsung DeX keyboard.
- Normal `y`/`p` synchronize with Android when the Termux provider is active.
  The explicit clipboard register commands `"+y` and `"+p` also work.
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
