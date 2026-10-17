# Local AI in Vim Grimory (Qwen3.8 / manual by default)

Grimory's local AI features are **opt-in per action**. Opening Neovim,
entering insert mode and typing do not start an AI request. Conventional
Blink.cmp completion (LSP, snippets, paths, buffer) stays automatic.

The tracked model tag for OpenCode and manual Minuet is `qwen3.8:27b`
(Ollama). This is **Qwen3.8 27B**, not `qwen3:8b` or `qwen3.5:9b`.
Before using AI, check the tag installed on your own server:

```sh
curl -fsS http://127.0.0.1:11434/api/tags
# Or inside the selfhosted-qwen-codeagent directory:
docker compose exec ollama ollama list
```

If your local tag is different, edit `opencode.json` (both `model` and
`provider.ollama.models`), or override Minuet independently with
`GRIMORY_AI_MODEL=your-tag nvim`. Ollama is expected on
`http://127.0.0.1:11434` on the host. The 27B model may need RAM
offloading on a 16 GB GPU; first response latency can be substantial.

## 1. Manual inline completion (Minuet)

- `Alt+]` in Insert mode: load Minuet lazily and request a suggestion.
- `Alt+A`: accept the suggestion; `Alt+a`: accept a line.
- `Alt+[` / `Alt+]`: navigate/request suggestions.
- `Alt+e`: dismiss.

Minuet uses `openai_compatible` with Ollama's
`/v1/chat/completions` for Qwen3.8. Automatic filetype triggers are
disabled (`auto_trigger_ft = {}`). `Minuet` is command-loaded,
not loaded during startup.

The terminal may not transmit some Alt combinations; diagnose mappings with
`:verbose imap <A-]>`. `:Minuet virtualtext enable` **opts in to automatic**
suggestions for the current buffer; this is not needed for manual completion.
Use `:Minuet virtualtext disable` to switch it off again.

The Blink/LSP menu does **not** use Minuet as a completion source.

## 2. Manual agent chat (CodeCompanion + OpenCode ACP)

- `<leader>ac`: toggle a CodeCompanion chat.
- `<leader>an`: new OpenCode Build chat.
- `<leader>aN`: new OpenCode Plan chat.
- `<leader>ao`: CodeCompanion actions.

The OpenCode process starts when a chat is opened, not when Neovim starts.
CodeCompanion's ACP adapters receive `OPENCODE_CONFIG` pointing to Grimory's
tracked `opencode.json`. This setting is scoped to OpenCode's subprocess;
it does not override configuration globally. An individual project's
`opencode.json` may still override the tracked settings (OpenCode precedence).

The tracked configuration uses `ollama/qwen3.8:27b`, `num_ctx=16384`,
`keep_alive=1m` and human approval for edits and shell commands. Ollama may
keep weights loaded briefly after the last request, but no requests should be
sent automatically by the editor.

Verify the OpenCode binary before testing Neovim:

```sh
command -v opencode
opencode --version
curl -fsS http://127.0.0.1:11434/api/tags
```

If the chat cannot initialize, inspect the CodeCompanion debug/log output
and confirm that the requested model is listed in Ollama.

## 3. Legacy local Agent Core / Hermes (independent process)

Hermes uses the separate `selfhosted-qwen-codeagent` Node.js API; it is
not OpenCode/Minuet and does not automatically start with Neovim.

Commands: `:HermesHealth`, `:HermesAsk`, `:HermesFile`,
`:HermesEdit`, `:HermesPreview`.
Keys: `<leader>ah`, `<leader>aa`, `<leader>af`,
`<leader>ae`, `<leader>ap`.

Grimory's Hermes client defaults to `http://127.0.0.1:8766` and workspace
`~/dev/vim-grimory`. It **rejects** requests when Neovim's current
directory differs from the configured workspace. The server and client
must use matching repository paths. To serve another checkout, start the
agent from the `selfhosted-qwen-codeagent` repository:

```sh
npm run infra:up
AGENT_MODEL=qwen3.8:27b npm run agent:up -- \
  --workspace "$HOME/dev/quant-dev-roadmap" \
  --repository quant-dev-roadmap \
  --port 8766
```

From Neovim opened at that same project root, run:

```vim
:lua vim.g.qwen_agent_workspace = vim.fn.getcwd()
:HermesHealth
```

The legacy Agent Core has its own model configuration (`AGENT_MODEL`
via the agent repository's `.env` or the process environment); editing
Grimory's `opencode.json` does not change this separate server.
For a health check from the agent repository, use:

```sh
npm run agent:health -- --port 8766
```

This API requires a local token at
`~/.config/qwen-codeagent/token`, created by the agent launcher.
File ASK/EDIT requires saved buffers and matching workspaces.

## Troubleshooting checklist

1. `docker compose ps` in the agent repository: Ollama is up.
2. `curl http://127.0.0.1:11434/api/tags`: expected model tag exists.
3. `command -v opencode`: OpenCode is installed on the Neovim host.
4. `:Lazy`: Minuet and CodeCompanion should not be active on startup.
5. Insert `Alt+]`: **manual** Minuet request; no requests while typing.
6. `<leader>an`: OpenCode Build chat; observe startup and any errors.
7. `:HermesHealth`: checks the **independent** Node Agent Core, not Ollama.
8. `:verbose nmap <leader>an` and `:verbose imap <A-]>`: check keymaps.

Do not remove Blink, Treesitter, Neovim LSP, or Rustaceanvim to fix an
AI connection issue. Those plugins are independent.
