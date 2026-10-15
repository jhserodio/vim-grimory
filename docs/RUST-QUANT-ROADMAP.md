# Rust Analyzer and the quantitative roadmap

The Rust exercises in [quant-dev-roadmap](https://github.com/vnator/quant-dev-roadmap)
are **not individual Cargo packages**. Their source files live under
`development/P*/.../rust/main.rs` and `main_test.rs`, while
`development/config/rust/Cargo.toml` defines the shared crate. Its
`src/lib.rs` incorporates the exercise files with `include!()`.

`lua/plugins/rustacean.lua` detects that layout at the Git worktree root
and configures Rust Analyzer with `linkedProjects`. Other Rust projects
continue using rustaceanvim's ordinary root discovery.

The global `vim.g.rustaceanvim` configuration must be initialized in
lazy.nvim's `init` callback, **before** its Rust filetype plugin starts.
Putting it only in `config` could leave Rust Analyzer without the intended
project root and linked manifest when the first Rust file is opened.

## Validate on the workstation

Run from the **quant-dev-roadmap** repository:

```sh
cd development
rustup show active-toolchain
rustc --version
cargo --version
cargo metadata --no-deps --format-version 1 --manifest-path config/rust/Cargo.toml
cargo check --manifest-path config/rust/Cargo.toml
cargo clippy --manifest-path config/rust/Cargo.toml --all-targets
cargo test --manifest-path config/rust/Cargo.toml P0_1_1_euclidean_algorithm
```

If Rust Analyzer still reports `the option 'Z' is only accepted on the
nightly compiler`, first verify it is no longer checking a standalone
`main.rs` or `main_test.rs` package. In the reported error, Cargo passed
`-Z crate-attr=feature(frontmatter)` and
`-Z crate-attr=allow(unused_features)` while compiling `main_test.rs`
as a standalone script with the stable compiler. That does **not** by
itself imply user-defined `RUSTFLAGS`. If the error persists after the
workspace is correctly linked, inspect:

```sh
env | grep -E '^(RUSTFLAGS|CARGO_ENCODED_RUSTFLAGS|RUSTUP_TOOLCHAIN|CARGO_TARGET_DIR)='
rustup show active-toolchain
cargo check -vv --manifest-path config/rust/Cargo.toml
```

To isolate injected flags without permanently changing your environment:

```sh
env -u RUSTFLAGS -u CARGO_ENCODED_RUSTFLAGS \
  cargo check --manifest-path config/rust/Cargo.toml
```

Also inspect `~/.cargo/config.toml`, any project-local `.cargo/config.toml`,
and `rust-toolchain.toml` if they exist. Do not switch all projects to
nightly or delete the shared Cargo cache just to silence a `-Z` error.

## Neovim checks

1. Restart Neovim after updating plugins; use `:Lazy sync` if needed.
2. Open an exercise's `rust/main.rs` and run `:LspInfo`.
3. Verify Rust Analyzer is attached at the quant-dev-roadmap repository
   root, rather than running a standalone `main.rs` package.
4. Use `:RustAnalyzer restart` if you had an earlier standalone LSP session.
5. Save a Rust file once; it should use Conform's rustfmt mapping, not a
   second independent `vim.lsp.buf.format()` autocmd.
6. Open an exercise's `main_test.rs`; run `:LspInfo` and `:LazyRoot`.
   The workspace/project root should remain at `quant-dev-roadmap`.
7. Toggle Snacks explorer with `<leader>e` or `<leader>fe`. The entire
   Git repository should remain visible even after navigating between
   Rust implementation/test files. These root-dir shortcuts do not call
   `:cd` or alter Neovim's working directory. Outside Git they fall back
   to normal LazyVim project-root detection.

## Tests and coverage: known limitations

Enabling LazyVim's `test.core` extra activates the existing optional
Neotest spec. The configured `neotest-rust` adapter requires
`cargo-nextest` and is designed around ordinary Cargo test files.
**Do not assume it discovers individually included `main_test.rs` files.**
Use the repository's shared Cargo `cargo test --manifest-path ...`
command as the authoritative test path until discovery is verified locally.

For Rust LCOV produced by `cargo llvm-cov`, use
`:CoverageLoadLcov {file}` (and `:CoverageShow`) rather than
expecting `:Coverage` to parse LCOV as the JSON format from grcov.
The coverage generator and report path are project-specific and have not
been changed by this PR.

This PR cannot verify compiler environment variables, external tool
installation, or runtime Neovim behavior on the workstation.
