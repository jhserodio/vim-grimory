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

## PR #3: native Android tooling and workflow

This change preserves **all portable Vim Grimory plugins** (Telescope,
Tree-sitter, Blink, Conform, Neotest, DAP, Rust tools and the UI). It
does not alter the PC's master branch.

### No automatic Mason downloads

Mason's UI stays available via `:Mason`. Its automatic tool installation,
mason-lspconfig bridge and PATH injection are disabled **on Android only**.
This matters because Mason downloads may target glibc Linux binaries rather
than Termux/Android. The original Neovim LSP configs still use executables
on the system PATH; their existing settings and keymaps are kept.

**Use Termux native packages or language-specific builds**, not
`:MasonInstall`, for language servers and formatters. Opening a language
buffer followed by `:LspInfo` or `:checkhealth vim.lsp` verifies LSP
attachment. The presence of an executable alone is not sufficient.

### Exactly one formatter on save

The extra `BufWritePre` call to `vim.lsp.buf.format()` was removed from
`lua/config/workflow.lua`. LazyVim and Conform continue to format on save;
otherwise the same file could be formatted twice by different tools.
Run `:ConformInfo` in a source file to inspect the formatter, then install
that formatter natively if needed.

### Telescope, Tree-sitter and native build tools

The original Telescope FZF extension and Tree-sitter parser selections are
**not disabled**. Use Termux's Clang, Make/CMake and native `tree-sitter`
CLI. If the CLI is not present, compile/install it for Android with a
native Rust toolchain. Do not download x86-64 Linux executables.

```sh
pkg install clang make cmake ninja ripgrep fd fzf
command -v clang
command -v tree-sitter
```

Optional Tree-sitter CLI source installation (needs working Rust/Cargo):
`cargo install tree-sitter-cli`. This build may take significant resources;
no build is run automatically by this PR.

### System browser for Markdown Preview

When `termux-open-url` is present in PATH, Markdown Preview uses it as the
browser command. The normal `:MarkdownPreview` command is unchanged.
The plugin may still need Node/npm to build on the tablet.

### Integrated tmux + Neovim navigation

The Neovim `vim-tmux-navigator` bindings are already in this repository.
To use Ctrl+H/J/K/L across both Neovim splits and tmux panes, you must
also configure tmux; the previous prefix-only bindings are insufficient.
An optional snippet is provided at `termux/tmux-navigation.conf`.

After this PR is merged and pulled on Termux, add this **one line** to your
existing `~/.tmux.conf` (do not overwrite the file):

```tmux
source-file ~/.config/nvim/termux/tmux-navigation.conf
```

Reload from a tmux session:

```sh
tmux source-file ~/.tmux.conf
tmux list-keys -T root | grep -E 'C-[hjkl]'
```

The process detection calls `ps`; the Termux `procps` package may be
needed. Your existing Ctrl+B split, close and pane bindings are preserved.

### Read-only Android Doctor

Inside Neovim, use:

```vim
:AndroidDoctor
:checkhealth
:ConformInfo
:Telescope find_files
:TSInstall c
:LspInfo
```

`:AndroidDoctor` shows which expected executables are present in PATH,
the clipboard provider and whether Neovim is inside tmux. It **does not**
install packages, edit settings or change the clipboard.

Manually verify Android clipboard roundtrip in both directions using the
instructions above. Validate the JS, Go and Rust LSPs by opening project
files. DAP adapters (CodeLLDB, Delve, JS Debug) and test runners are kept,
but require **native executable tests on the tablet** before claiming full
debugging/test support. Do not attempt `:MasonInstall codelldb` as an
Android workaround.

No claim of on-device validation is made by this PR.
