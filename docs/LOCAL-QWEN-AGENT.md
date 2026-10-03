# Local AI integration (Grimory)

Grimory runs two separate local AI components:

- **Minuet:** inline FIM suggestions from Ollama (`qwen2.5-coder:1.5b-base`, `127.0.0.1:11434`). Keep `lua/plugins/minuet.lua` unchanged. Blink remains responsible for LSP, path, snippets, and buffer completions, with its own ghost text disabled.
- **Qwen Code Agent:** project-aware ASK and supervised EDIT through `selfhosted-qwen-codeagent` (`qwen2.5-coder:7b` behind its local API). This integration is implemented by `lua/grimory/agent.lua` and bound centrally in `lua/config/keymaps.lua`. No CopilotChat, Copilot, CodeCompanion, or cloud provider is part of this setup.

## Prerequisites

Neovim >= 0.11, `curl`, Node.js and the selfhosted agent's Ollama/Qdrant containers. Ensure `~/.config/nvim` resolves to this Grimory checkout, and start Neovim in the workspace served by the agent. Its token is read from `~/.config/qwen-codeagent/token` and is never committed.

From the **selfhosted-qwen-codeagent** repository:

```sh
npm run infra:up
npm run agent:ingest -- --workspace "$HOME/dev/vim-grimory" --repository vim-grimory --extensions .lua,.md,.json,.toml,.yml,.yaml
npm run agent:up -- --workspace "$HOME/dev/vim-grimory" --repository vim-grimory --port 8766
```

Leave `agent:up` running in its terminal. The default Grimory client uses `http://127.0.0.1:8766`, while Minuet uses Ollama directly on port 11434. Start `nvim .` from the Grimory root; the v1 client intentionally checks the configured workspace. If needed, configure `vim.g.qwen_agent_url` and `vim.g.qwen_agent_workspace` before using the client.

## Keymaps and corresponding Ex commands

| Normal mode | Command | Operation |
| --- | --- | --- |
| `<leader>ah` | `:GrimoryAgentHealth` | Check local API health |
| `<leader>aa` | `:GrimoryAgentAsk` | ASK about the indexed workspace |
| `<leader>af` | `:GrimoryAgentFile` | ASK about the **saved** current file with additional context |
| `<leader>ae` | `:GrimoryAgentEdit` | Stage an EDIT proposal for the **saved** current file |
| `<leader>ap` | `:GrimoryAgentPreview` | Show the last pending proposal diff (or prompt for UUID) |

The API **never applies the patch**. Run the agent's separate, interactive CLI APPLY command and type the exact `APPLY <id>` approval after inspecting the diff. A proposed edit does not alter the buffer or file. REVIEW exists in the underlying HTTP API but has no Vim mapping yet.

Minuet accepts a complete suggestion with `<A-A>` and has its own keymaps in `lua/plugins/minuet.lua`. Qwen Agent actions use the `<leader>a` group and do not consume insert-mode completion mappings.

## First-run verification

1. Restart Neovim, run `:Lazy sync` (and `:Lazy clean` to remove unreferenced historical plugin installations if desired), then reopen `nvim .`.
2. Run `:verbose nmap <leader>ae`: it must identify **Qwen: propose file edit**, not `CopilotChatExplain` or a CodeCompanion mapping.
3. Run `:GrimoryAgentHealth`, then `:GrimoryAgentAsk`.
4. Save a disposable `.lua` file, run `:GrimoryAgentEdit`, review the diff and verify that the source file is untouched.

If the model mentions a source that is absent from the API response's `sources`, treat that claim as **unverified**: automatic retrieval still has known limitations on exact symbol discovery.

## Troubleshooting

- `Model not found: gpt-5-mini`, in a buffer titled **Copilot**: old CopilotChat config or mappings are still loaded. Restart Neovim after applying the removal patch. Search remaining files with `rg -n 'CopilotChat|CodeCompanion|blink-cmp-copilot' lua/`.
- `API` connection refused: start the `8766` agent instance and run `npm run agent:health -- --port 8766` from the agent repository.
- Workspace mismatch: start Neovim from the workspace served by the agent; the v1 client enforces this boundary.
- An edited buffer is unsaved: save it before ASK FILE / EDIT, because the server operates on actual workspace files, not unsaved Neovim state.
