# 🎮 Vim Grimory - Keymaps Reference

> **Leader key**: `<Space>`

## 📋 Mapa Completo de Comandos

| Tecla | Modo | Descrição |
|-------|------|-----------|
| **COMANDOS PADRÃO (LazyVim)** |||
| `<leader>l` | n | Lazy - Gerenciador de plugins |
| `<leader>x` | n | Lazy Extras - Extras do LazyVim |
| `<leader>cm` | n | Mason - Gerenciador de LSP/DAP/linters |
| `<C-h/j/k/l>` | n | Navegar entre janelas (← ↓ ↑ →) |
| `<C-Up/Down>` | n | Aumentar/diminuir altura da janela |
| `<C-Left/Right>` | n | Aumentar/diminuir largura da janela |
| `<leader>-` | n | Split horizontal |
| `<leader>\|` | n | Split vertical |
| `<leader>wd` | n | Fechar janela |
| `<leader>w-` | n | Split horizontal |
| `<leader>w\|` | n | Split vertical |
| `<leader>qq` | n | Sair do Neovim |
| `<leader>qa` | n | Sair de todas as janelas |
||||
| **BUFFER MANAGEMENT** |||
| `<S-h>` | n | Buffer anterior |
| `<S-l>` | n | Próximo buffer |
| `[b` | n | Buffer anterior |
| `]b` | n | Próximo buffer |
| `[B` | n | Mover buffer para esquerda |
| `]B` | n | Mover buffer para direita |
| `<leader>bb` | n | Mudar para outro buffer |
| `<leader>bd` | n | Deletar buffer |
| `<leader>bD` | n | Deletar buffer (force) |
| `<leader>bp` | n | Toggle pin buffer |
| `<leader>bP` | n | Deletar buffers não-pinados |
| `<leader>br` | n | Deletar buffers à direita |
| `<leader>bl` | n | Deletar buffers à esquerda |
||||
| **TELESCOPE - Busca de Arquivos** |||
| `<leader><space>` | n | **Find Files** (root dir) |
| `<leader>ff` | n | Find Files (root dir) |
| `<leader>fF` | n | Find Files (cwd) |
| `<leader>fg` | n | Find Files (git files) |
| `<leader>fr` | n | Recent files |
| `<leader>fR` | n | Recent files (cwd) |
| `<leader>fc` | n | Find Config File |
| `<leader>fb` | n | Switch Buffer |
| `<leader>,` | n | Switch Buffer (alternate) |
||||
| **TELESCOPE - Busca de Conteúdo** |||
| `<leader>/` | n | **Live Grep** (root dir) |
| `<leader>sg` | n | Live Grep (root dir) |
| `<leader>sG` | n | Live Grep (cwd) |
| `<leader>sw` | n | Word under cursor (root) |
| `<leader>sW` | n | Word under cursor (cwd) |
| `<leader>sw` | v | Selection (root dir) |
| `<leader>sW` | v | Selection (cwd) |
| `<leader>sb` | n | Fuzzy find no buffer atual |
||||
| **TELESCOPE - Busca de Sistema** |||
| `<leader>sa` | n | Auto Commands |
| `<leader>sc` | n | Command History |
| `<leader>sC` | n | Commands |
| `<leader>sh` | n | Help Pages |
| `<leader>sH` | n | Search Highlight Groups |
| `<leader>sk` | n | Key Maps |
| `<leader>sM` | n | Man Pages |
| `<leader>sm` | n | Jump to Mark |
| `<leader>so` | n | Options |
| `<leader>sR` | n | Resume last search |
| `<leader>s"` | n | Registers |
| `<leader>:` | n | Command History |
||||
| **TELESCOPE - Diagnósticos & Símbolos** |||
| `<leader>sd` | n | Document Diagnostics |
| `<leader>sD` | n | Workspace Diagnostics |
| `<leader>sy` | n | Document Symbols |
| `<leader>sY` | n | Workspace Symbols |
| `<leader>st` | n | Treesitter Symbols |
| `<leader>sl` | n | Location List |
| `<leader>sq` | n | Quickfix List |
| `<leader>sj` | n | Jumplist |
||||
| **TELESCOPE - Git** |||
| `<leader>gc` | n | Git Commits |
| `<leader>gs` | n | Git Status |
| `<leader>gb` | n | Git Branches |
| `<leader>gf` | n | Git Files |
| `<leader>gS` | n | Git Stash |
||||
| **TELESCOPE - LSP** |||
| `<leader>lr` | n | LSP References |
| `<leader>li` | n | LSP Implementations |
| `<leader>ld` | n | LSP Definitions |
| `<leader>lt` | n | LSP Type Definitions |
| `<leader>ss` | n | Goto Symbol |
| `<leader>sS` | n | Goto Symbol (Workspace) |
||||
| **TELESCOPE - Outros** |||
| `<leader>sn` | n | Notifications (Snacks) |
| `<leader>sp` | n | Telescope Pickers |
| `<leader>uC` | n | Colorscheme with Preview |
||||
| **GITHUB COPILOT - Inline Suggestions** |||
| `<Tab>` | i | Aceitar sugestão |
| `<C-]>` | i | Próxima sugestão |
| `<C-[>` | i | Sugestão anterior |
| `<C-\>` | i | Demitir sugestão |
||||
| **GITHUB COPILOT - Chat** |||
| `<leader>aa` | n,v | **Prompt Actions** (Telescope) |
| `<leader>ae` | n,v | **Explain** code |
| `<leader>at` | n,v | **Generate Tests** |
| `<leader>ar` | n,v | **Review** code |
| `<leader>aR` | n,v | **Refactor** |
| `<leader>an` | n,v | **Better Namings** |
| `<leader>ad` | n,v | **Documentation** |
| `<leader>af` | n,v | **Fix Code** |
| `<leader>aq` | n,v | Quick Chat |
||||
| **LSP - Navegação** |||
| `gd` | n | Goto Definition |
| `gr` | n | Goto References |
| `gI` | n | Goto Implementation |
| `gy` | n | Goto Type Definition |
| `gD` | n | Goto Declaration |
| `K` | n | Hover Documentation |
| `gK` | n | Signature Help |
||||
| **LSP - Code Actions** |||
| `<leader>ca` | n,v | Code Action |
| `<leader>cA` | n | Source Action |
| `<leader>cr` | n | Rename |
| `<leader>cc` | n | Run Codelens |
| `<leader>cC` | n | Refresh Codelens |
| `<leader>cf` | n,v | Format Document/Range |
| `<leader>cn` | n | Conform Info |
| `<leader>cl` | n | LSP Info |
||||
| **LSP - Diagnósticos** |||
| `]d` | n | Próximo Diagnostic |
| `[d` | n | Diagnostic Anterior |
| `]e` | n | Próximo Error |
| `[e` | n | Error Anterior |
| `]w` | n | Próximo Warning |
| `[w` | n | Warning Anterior |
| `<leader>cd` | n | Line Diagnostics |
||||
| **TESTING (Neotest)** |||
| `<leader>tt` | n | **Run File** (todos os testes) |
| `<leader>tT` | n | **Run All** (todos do projeto) |
| `<leader>tr` | n | **Run Nearest** (teste mais próximo) |
| `<leader>tl` | n | **Run Last** (reexecutar último) |
| `<leader>ts` | n | **Toggle Summary** |
| `<leader>to` | n | **Show Output** |
| `<leader>tO` | n | **Toggle Output Panel** |
| `<leader>tS` | n | **Stop** tests |
| `<leader>tw` | n | **Toggle Watch** mode |
| `<leader>td` | n | **Debug Nearest** test |
| `<leader>tc` | n | **Toggle Coverage** |
| `<leader>tC` | n | **Coverage Summary** |
| `<leader>tL` | n | **Load Coverage** |
||||
| **DEBUGGING (DAP) - Controle** |||
| `<leader>dB` | n | **Breakpoint Condition** |
| `<leader>db` | n | **Toggle Breakpoint** |
| `<leader>dc` | n | **Continue** / Start |
| `<leader>dC` | n | **Run to Cursor** |
| `<leader>dg` | n | **Go to Line** (sem executar) |
| `<leader>di` | n | **Step Into** |
| `<leader>dj` | n | **Down** (stack frame) |
| `<leader>dk` | n | **Up** (stack frame) |
| `<leader>dl` | n | **Run Last** |
| `<leader>do` | n | **Step Out** |
| `<leader>dO` | n | **Step Over** |
| `<leader>dp` | n | **Pause** |
| `<leader>dr` | n | **Toggle REPL** |
| `<leader>ds` | n | **Session** |
| `<leader>dt` | n | **Terminate** |
| `<leader>dw` | n | **Widgets** |
||||
| **DEBUGGING (DAP) - UI** |||
| `<leader>du` | n | **Toggle DAP UI** |
| `<leader>de` | n,v | **Eval** expression |
| `<leader>dE` | n | **Eval** (prompt) |
| `<leader>dw` | n | **Watches** window |
| `<leader>ds` | n | **Scopes** window |
| `<leader>dr` | n | **REPL** window |
| `<leader>dc` | n | **Console** window |
||||
| **REFACTORING** |||
| `<leader>rs` | n,v | **Refactor** (Telescope) |
| `<leader>ri` | n,v | **Inline Variable** |
| `<leader>rb` | n | **Extract Block** |
| `<leader>rbf` | n | **Extract Block to File** |
| `<leader>rp` | n | **Debug Print** |
| `<leader>rpv` | n,v | **Debug Print Variable** |
| `<leader>rc` | n | **Debug Cleanup** |
| `<leader>rf` | v | **Extract Function** |
| `<leader>rff` | v | **Extract Function to File** |
| `<leader>rx` | v | **Extract Variable** |
| `<leader>rv` | v | **Debug Print Variable** |
||||
| **RUST (Rustacean)** |||
| `<leader>cR` | n | **Rust Runnables** |
| `<leader>ct` | n | **Rust Testables** |
| `<leader>cD` | n | **Rust Debuggables** |
| `<leader>ca` | n | **Code Action** (rust-analyzer) |
| `K` | n | **Hover Actions** |
| `<leader>cdr` | n | **Rust Debuggables** |
| `<leader>rcu` | n | **Move Item Up** |
| `<leader>rcd` | n | **Move Item Down** |
| `<leader>rcJ` | n | **Join Lines** |
| `<leader>rss` | n | **Structural Search Replace** |
| `<leader>re` | n | **Explain Error** |
| `<leader>rc` | n | **Open Cargo.toml** |
| `<leader>rp` | n | **Parent Module** |
||||
| **GO (go-tools)** |||
| `<leader>gsj` | n | **Add JSON tags** |
| `<leader>gsy` | n | **Add YAML tags** |
| `<leader>gst` | n | **Modify struct tags** (prompt) |
| `<leader>gi` | n | **Generate Interface Implementation** |
| `<leader>gf` | n | **Fill Struct Fields** |
| `<leader>td` | n | Debug Go Test (nearest) |
| `<leader>tl` | n | Debug Last Go Test |
||||
| **HASKELL (haskell-tools)** |||
| `<leader>hs` | n | **Start HLS** |
| `<leader>hS` | n | **Stop HLS** |
| `<leader>hr` | n | **Restart HLS** |
| `<leader>hh` | n | **Hoogle Signature** |
| `<leader>rr` | n | **Toggle GHCi REPL** |
| `<leader>rf` | n | **REPL for current file** |
| `<leader>rq` | n | **Quit REPL** |
||||
| **JAVA (jdtls)** |||
| `<leader>cxv` | v | **Extract Variable** |
| `<leader>cxc` | n | **Extract Constant** |
| `<leader>cxm` | v | **Extract Method** |
| `<leader>cgs` | n | **Goto Super** |
| `<leader>cgS` | n | **Goto Subjects** (tests) |
| `<leader>co` | n | **Organize Imports** |
| `<leader>tc` | n | **Run All Tests** (Java) |
| `<leader>tr` | n | **Run Nearest Test** (Java) |
| `<leader>tT` | n | **Pick Test** (Java) |
||||
| **C/C++ (clangd)** |||
| `<leader>ch` | n | **Switch Source/Header** |
| `<leader>cH` | n | **Toggle Inlay Hints** |
||||
| **TYPESCRIPT/JAVASCRIPT** |||
| `<leader>co` | n | **Organize Imports** |
| `<leader>cM` | n | **Add missing imports** |
| `<leader>cR` | n | **Remove unused imports** |
| `<leader>cD` | n | **Fix all diagnostics** |
| `<leader>cV` | n | **Select TS workspace version** |
||||
| **ELIXIR** |||
| `<leader>cp` | n | **To Pipe** |
| `<leader>cP` | n | **From Pipe** |
||||
| **FLASH (Navegação Rápida)** |||
| `s` | n,x,o | **Flash Jump** |
| `S` | n,x,o | **Flash Treesitter** |
| `r` | o | **Remote Flash** |
| `R` | o,x | **Treesitter Search** |
| `<C-s>` | c | **Toggle Flash Search** |
||||
| **EDIÇÃO & PRODUTIVIDADE** |||
| `<leader>cf` | n,v | **Format** |
| `<leader>cg` | n | **Neogen** (gerar documentação) |
| `<leader>sr` | n,v | **Search and Replace** (grug-far) |
| `p` | v | Paste sem sobrescrever clipboard |
| `<C-/>` | i,n,t | Toggle terminal |
||||
| **SESSÕES (Persistence)** |||
| `<leader>qs` | n | **Restore Session** |
| `<leader>qS` | n | **Select Session** |
| `<leader>ql` | n | **Restore Last Session** |
| `<leader>qd` | n | **Don't Save Session** |
||||
| **TROUBLE (Diagnósticos)** |||
| `<leader>xx` | n | **Diagnostics** (Trouble) |
| `<leader>xX` | n | **Buffer Diagnostics** |
| `<leader>cs` | n | **Symbols** (Trouble) |
| `<leader>cS` | n | **LSP references** (Trouble) |
| `<leader>xL` | n | **Location List** |
| `<leader>xQ` | n | **Quickfix List** |
||||
| **NPM (package-info)** |||
| `<leader>ns` | n | **Telescope Package Info** |
||||
| **MARKDOWN PREVIEW** |||
| `<leader>cp` | n | **Markdown Preview** |

---

## 🏠 Dashboard (Snacks)

Ao abrir o Neovim sem arquivo:

| Tecla | Descrição |
|-------|-----------|
| `f` | Find File |
| `n` | New File |
| `g` | Find Text |
| `r` | Recent Files |
| `c` | Config |
| `s` | Restore Session |
| `x` | Lazy Extras |
| `l` | Lazy |
| `q` | Quit |

---

## 🚀 Comandos Personalizados

### Workflow Automation

```vim
:RustNew nome_do_projeto      " Criar novo projeto Rust
:GoNew nome_do_modulo         " Criar novo módulo Go
:HaskellNew nome_do_projeto   " Criar novo projeto Haskell
:ConformInfo                  " Informações de conformação
:Mason                        " Gerenciar LSP/DAP/linters
:VimBeGood                    " Treinamento de Vim motions
```

---

## 🎯 Prompts do Copilot Chat

Disponíveis via `<leader>aa`:

- **Explain** - Explica como o código funciona
- **Review** - Revisa código e sugere melhorias
- **Tests** - Gera unit tests
- **Refactor** - Refatora para melhorar clareza
- **FixCode** - Corrige bugs
- **FixError** - Explica e resolve erros
- **BetterNamings** - Sugere nomes melhores
- **Documentation** - Gera documentação
- **SwaggerApiDocs** - Documentação Swagger
- **Summarize** - Resume texto
- **Spelling** - Corrige gramática
- **Wording** - Melhora redação
- **Concise** - Torna texto conciso

---

<div align="center">

⚔ **Carambolas Never Die** ⚔

[← Voltar ao README](README.md)

</div>
