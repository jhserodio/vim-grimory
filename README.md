# Vim Grimory 🌟

```
      ██╗   ██╗███╗   ██╗ █████╗ ████████╗ ██████╗ ██████╗ 
      ██║   ██║████╗  ██║██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
      ██║   ██║██╔██╗ ██║███████║   ██║   ██║   ██║██████╔╝
      ╚██╗ ██╔╝██║╚██╗██║██╔══██║   ██║   ██║   ██║██╔══██╗
       ╚████╔╝ ██║ ╚████║██║  ██║   ██║   ╚██████╔╝██║  ██║
        ╚═══╝  ╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝

               _.zZ SERODIO - SOFTWARE CRAFTER ZZ._
        
                           ⚔   ☩  ⚔
        
                  Carambolas Never Die Edition
```

[![Neovim](https://img.shields.io/badge/Neovim-0.11.2+-green.svg)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![LazyVim](https://img.shields.io/badge/LazyVim-v15.13.0-blueviolet.svg)](https://github.com/LazyVim/LazyVim)

## 📖 Sobre o Repositório

**Vim Grimory** é uma configuração altamente otimizada e moderna do Neovim, construída sobre o LazyVim, especialmente projetada para desenvolvedores que trabalham com múltiplas linguagens de programação. Esta configuração oferece suporte avançado para **Rust**, **Go**, **Haskell**, **Java**, **C/C++**, **Julia**, **TypeScript/JavaScript**, **Elixir**, **Zig** e muito mais.

### ✨ Principais Características

- 🚀 **Performance Otimizada**: Carregamento lazy de plugins e configurações otimizadas
- 🧠 **AI-Powered**: Integração completa com GitHub Copilot (code + chat)
- 🔧 **LSP Completo**: Suporte a 10+ linguagens com autocompletion, diagnostics e refactoring
- 🧪 **Testing Framework**: Neotest integrado para Rust, Go, Haskell, Elixir e Zig
- 🐛 **Debug Suite**: DAP configurado com UI para debugging visual
- 📦 **Workflow Automation**: Templates de projeto, auto-save, auto-format e snippets inteligentes
- 🎨 **UI Moderna**: Dashboard customizado, statusline, bufferline e which-key

---

## 📁 Estrutura do Repositório

```
vim-grimory/
├── init.lua                    # Ponto de entrada principal
├── lazy-lock.json             # Lock file do gerenciador Lazy.nvim
├── lazyvim.json              # Configurações do LazyVim
├── stylua.toml               # Configuração do formatador Lua
│
├── lua/
│   ├── config/               # Configurações principais
│   │   ├── autocmds.lua     # Autocommands personalizados
│   │   ├── clipboard.lua    # Gerenciamento de clipboard
│   │   ├── keymaps.lua      # Keymaps globais (mantido limpo, keymaps nos plugins)
│   │   ├── lazy.lua         # Configuração do Lazy.nvim
│   │   ├── mason-lsp.lua    # Configuração Mason para LSP
│   │   ├── options.lua      # Opções do Neovim
│   │   └── workflow.lua     # Automações de workflow (auto-save, templates, etc)
│   │
│   └── plugins/             # Plugins e configurações
│       ├── core.lua         # Plugins core do LazyVim
│       ├── disabled.lua     # Plugins desabilitados
│       │
│       ├── # UI & Interface
│       ├── snacks.lua       # Dashboard e notificações
│       ├── bufferline.lua   # Gerenciador de buffers
│       ├── lualine.lua      # Statusline
│       ├── which-key.lua    # Menu de atalhos
│       ├── mini-icons.lua   # Ícones modernos
│       │
│       ├── # Navegação & Busca
│       ├── telescope.lua    # Fuzzy finder (12+ pickers)
│       ├── flash.lua        # Navegação rápida
│       ├── grug-far.lua     # Search and replace
│       │
│       ├── # LSP & Completion
│       ├── lsp.lua          # Configuração LSP (10+ linguagens)
│       ├── mason.lua        # Gerenciador de LSP servers
│       ├── blink.lua        # Completion engine
│       ├── blink-cmp-copilot.lua  # Integração Copilot com completion
│       ├── lazydev.lua      # LSP para desenvolvimento Lua/Neovim
│       │
│       ├── # AI Assistants
│       ├── copilot.lua      # GitHub Copilot code suggestions
│       ├── copilot-chat.lua # GitHub Copilot Chat (10+ prompts)
│       │
│       ├── # Language-Specific
│       ├── rustacean.lua    # Ferramentas avançadas para Rust
│       ├── haskell-tools.lua # Ferramentas para Haskell
│       ├── jdtls.lua        # Java LSP avançado
│       ├── clangd_extensions.lua # Extensões C/C++
│       ├── cpp-tools.lua    # Ferramentas adicionais C/C++
│       ├── go-tools.lua     # Ferramentas Go (tags, impl, fill struct)
│       ├── julia.lua        # Suporte Julia
│       ├── deno.lua         # Runtime TypeScript/JavaScript
│       ├── conjure.lua      # REPL para Lisp/Clojure
│       ├── crates.lua       # Gerenciamento de crates Rust
│       ├── npm.lua          # Gerenciamento de pacotes npm
│       │
│       ├── # Testing & Debugging
│       ├── neotest.lua      # Framework de testes
│       ├── neotest-golang.lua     # Adapter Go
│       ├── neotest-haskell.lua    # Adapter Haskell
│       ├── neotest-elixir.lua     # Adapter Elixir
│       ├── neotest-zig.lua        # Adapter Zig
│       ├── nvim-dap.lua     # Debug Adapter Protocol
│       ├── nvim-dap-ui.lua  # UI para debugger
│       ├── nvim-dap-go.lua  # DAP para Go
│       ├── mason-nvim-dap.lua     # Mason para DAP
│       ├── coverage.lua     # Visualização de cobertura de testes
│       │
│       ├── # Code Quality
│       ├── conform.lua      # Formatação de código
│       ├── refactoring.lua  # Refactoring avançado
│       ├── neogen.lua       # Geração de documentação
│       ├── trouble.lua      # Lista de diagnósticos
│       │
│       ├── # Treesitter & Syntax
│       ├── treesitter.lua   # Parser de sintaxe
│       ├── treesitter-textobjects.lua  # Text objects
│       ├── nvim-treesitter-sexp.lua    # S-expressions
│       ├── nvim-ts-autotag.lua         # Auto-close tags
│       ├── ts-comments.lua  # Comentários inteligentes
│       │
│       ├── # Snippets
│       ├── luasnip.lua      # Engine de snippets
│       ├── friendly-snippets.lua  # Snippets prontos
│       ├── snippets-lang.lua      # Snippets customizados (27 snippets/6 linguagens)
│       ├── haskell-snippets.lua   # Snippets Haskell
│       │
│       ├── # Productivity
│       ├── persistence.lua  # Gerenciamento de sessões
│       ├── markdown-preview.lua   # Preview de Markdown
│       ├── baleia.lua       # Colorização de logs
│       ├── vimbegood.lua    # Treinamento de Vim motions
│       ├── tmux.lua         # Integração com tmux
│       ├── minipairs.lua    # Auto-pairs
│       └── miniai.lua       # Text objects AI-powered
│
└── README.md                # Este arquivo
```

---

## 🔌 Catálogo de Plugins

### 🎨 **Interface & UI**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **snacks.nvim** | Dashboard moderno, notificações e utilitários UI | [folke/snacks.nvim](https://github.com/folke/snacks.nvim) |
| **lualine.nvim** | Statusline altamente configurável | [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) |
| **bufferline.nvim** | Gerenciador visual de buffers como abas | [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) |
| **which-key.nvim** | Menu popup de keymaps com 16 grupos organizados | [folke/which-key.nvim](https://github.com/folke/which-key.nvim) |
| **mini.icons** | Ícones modernos para arquivos e tipos | [echasnovski/mini.icons](https://github.com/echasnovski/mini.icons) |
| **gruvbox.nvim** | Tema Gruvbox moderno | [ellisonleao/gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim) |

### 🔍 **Navegação & Busca**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **telescope.nvim** | Fuzzy finder com 12+ pickers customizados | [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) |
| **flash.nvim** | Navegação rápida por caracteres/palavras | [folke/flash.nvim](https://github.com/folke/flash.nvim) |
| **grug-far.nvim** | Search and replace avançado | [MagicDuck/grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) |

### 🧠 **LSP & Inteligência**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **nvim-lspconfig** | Configurações LSP para 10+ linguagens | [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) |
| **mason.nvim** | Gerenciador de LSP servers, DAP, linters | [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) |
| **mason-lspconfig** | Bridge entre Mason e LSP config | [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) |
| **blink.cmp** | Completion engine moderno e rápido | [saghen/blink.cmp](https://github.com/saghen/blink.cmp) |
| **lazydev.nvim** | LSP para desenvolvimento Lua/Neovim | [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim) |

### 🤖 **AI Assistants**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **copilot.lua** | GitHub Copilot com sugestões inline | [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua) |
| **CopilotChat.nvim** | Chat com Copilot (10+ prompts: Review, Tests, Refactor...) | [CopilotC-Nvim/CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) |

### 🔧 **Ferramentas por Linguagem**

| Plugin | Linguagens | Descrição | Link |
|--------|-----------|-----------|------|
| **rustaceanvim** | Rust | Ferramentas avançadas (runnables, debuggables, cargo) | [mrcjkb/rustaceanvim](https://github.com/mrcjkb/rustaceanvim) |
| **haskell-tools.nvim** | Haskell | HLS, GHCi REPL, Hoogle integration | [mrcjkb/haskell-tools.nvim](https://github.com/mrcjkb/haskell-tools.nvim) |
| **nvim-jdtls** | Java | Eclipse JDT.LS com refactoring e DAP | [mfussenegger/nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) |
| **clangd_extensions** | C/C++ | Extensões para clangd (inlay hints, AST) | [p00f/clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim) |
| **crates.nvim** | Rust | Gerenciamento de crates do Cargo | [Saecki/crates.nvim](https://github.com/Saecki/crates.nvim) |
| **package-info.nvim** | JavaScript/TypeScript | Informações de pacotes npm | [vuki656/package-info.nvim](https://github.com/vuki656/package-info.nvim) |
| **conjure** | Lisp/Clojure | REPL interativo | [Olical/conjure](https://github.com/Olical/conjure) |

### 🧪 **Testing & Debugging**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **neotest** | Framework unificado de testes | [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest) |
| **neotest-golang** | Adapter para Go tests | [nvim-neotest/neotest-go](https://github.com/nvim-neotest/neotest-go) |
| **neotest-haskell** | Adapter para Haskell tests | [mrcjkb/neotest-haskell](https://github.com/mrcjkb/neotest-haskell) |
| **neotest-elixir** | Adapter para Elixir tests | [jfpedroza/neotest-elixir](https://github.com/jfpedroza/neotest-elixir) |
| **neotest-zig** | Adapter para Zig tests | [lawrence-laz/neotest-zig](https://github.com/lawrence-laz/neotest-zig) |
| **nvim-dap** | Debug Adapter Protocol | [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) |
| **nvim-dap-ui** | Interface visual para debugging | [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) |
| **nvim-dap-go** | DAP específico para Go | [leoluz/nvim-dap-go](https://github.com/leoluz/nvim-dap-go) |
| **coverage.nvim** | Visualização de cobertura de testes | [andythigpen/nvim-coverage](https://github.com/andythigpen/nvim-coverage) |

### ✏️ **Edição & Produtividade**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **conform.nvim** | Formatação de código (formatter runner) | [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) |
| **refactoring.nvim** | Refactoring avançado com Telescope | [ThePrimeagen/refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) |
| **neogen** | Geração automática de documentação | [danymat/neogen](https://github.com/danymat/neogen) |
| **trouble.nvim** | Lista de diagnósticos e quickfix moderna | [folke/trouble.nvim](https://github.com/folke/trouble.nvim) |
| **persistence.nvim** | Gerenciamento de sessões | [folke/persistence.nvim](https://github.com/folke/persistence.nvim) |
| **mini.pairs** | Auto-pairs inteligente | [echasnovski/mini.pairs](https://github.com/echasnovski/mini.pairs) |
| **mini.ai** | Text objects AI-powered | [echasnovski/mini.ai](https://github.com/echasnovski/mini.ai) |

### 🌳 **Treesitter & Sintaxe**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **nvim-treesitter** | Parser de sintaxe moderno | [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) |
| **nvim-treesitter-textobjects** | Text objects baseados em sintaxe | [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) |
| **ts-comments.nvim** | Comentários contextuais | [folke/ts-comments.nvim](https://github.com/folke/ts-comments.nvim) |

### 📝 **Snippets**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **LuaSnip** | Engine de snippets | [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| **friendly-snippets** | Coleção de snippets prontos | [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) |
| **Custom Snippets** | 27 snippets customizados para Rust, Go, Haskell, Java, C/C++, Julia | - |

### 🔌 **Utilitários**

| Plugin | Descrição | Link |
|--------|-----------|------|
| **vim-tmux-navigator** | Navegação integrada Neovim ↔ tmux | [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) |
| **markdown-preview** | Preview de Markdown no browser | [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) |
| **baleia.nvim** | Colorização de logs ANSI | [m00qek/baleia.nvim](https://github.com/m00qek/baleia.nvim) |
| **vim-be-good** | Treinamento de Vim motions | [ThePrimeagen/vim-be-good](https://github.com/ThePrimeagen/vim-be-good) |

---

## ⚙️ Instalação

### 📋 Pré-requisitos

#### 🐧 **Linux (Debian/Ubuntu)**

```bash
# Neovim 0.11.2+
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Dependências essenciais
sudo apt install -y \
  git curl wget \
  ripgrep fd-find fzf \
  build-essential cmake \
  python3 python3-pip python3-venv \
  nodejs npm \
  unzip tar gzip

# Compiladores (opcional mas recomendado)
sudo apt install -y gcc g++ clang rustup golang-go

# Ferramentas extras
sudo apt install -y lazygit xclip wl-clipboard
```

#### 🏔️ **Linux (Arch)**

```bash
# Neovim e dependências
sudo pacman -S \
  neovim git curl wget \
  ripgrep fd fzf \
  base-devel cmake \
  python python-pip \
  nodejs npm \
  unzip tar gzip

# Compiladores (opcional)
sudo pacman -S gcc clang rust go

# Ferramentas extras
sudo pacman -S lazygit xclip wl-clipboard
```

#### 🍎 **macOS**

```bash
# Homebrew (se não instalado)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Neovim e dependências
brew install neovim git curl wget
brew install ripgrep fd fzf cmake
brew install python node

# Compiladores (opcional)
brew install gcc llvm rust go

# Ferramentas extras
brew install lazygit
```

### 📥 Instalação do Vim Grimory

```bash
# 1. Backup da configuração existente (se houver)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup

# 2. Clone o repositório
git clone https://github.com/jhserodio/vim-grimory.git ~/.config/nvim

# 3. Abra o Neovim (plugins serão instalados automaticamente)
nvim
```

### 🔧 Configuração Pós-instalação

#### GitHub Copilot

```vim
" No Neovim, execute:
:Copilot setup

" Siga as instruções para autenticar com GitHub
" Após autenticação, reabra o Neovim
```

#### LSP Servers (instalados automaticamente via Mason)

Os seguintes LSP servers serão instalados automaticamente:
- **Rust**: `rust-analyzer`, `bacon-ls`
- **Go**: `gopls`
- **Haskell**: `haskell-language-server`
- **Java**: `jdtls`
- **C/C++**: `clangd`
- **Julia**: `julia-lsp`
- **TypeScript/JavaScript**: `vtsls`, `denols`
- **Python**: `pyright`, `ruff`
- **Lua**: `lua-ls`

Para instalar manualmente um server adicional:
```vim
:Mason
" Navegue e pressione 'i' para instalar
```

---

## ⌨️ Keymaps Completos

> **Nota**: Leader key = `<Space>`

### 🎯 **Comandos Padrão (LazyVim)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>l` | n | **Lazy** - Gerenciador de plugins |
| `<leader>x` | n | **Lazy Extras** - Extras do LazyVim |
| `<leader>cm` | n | **Mason** - Gerenciador de LSP/DAP/linters |
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

### 📂 **Buffer Management**

| Tecla | Modo | Descrição |
|-------|------|-----------|
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

### 🔍 **Telescope - Busca & Navegação**

#### Busca de Arquivos

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader><space>` | n | **Find Files** (root dir) |
| `<leader>ff` | n | Find Files (root dir) |
| `<leader>fF` | n | Find Files (cwd) |
| `<leader>fg` | n | Find Files (git files) |
| `<leader>fr` | n | Recent files |
| `<leader>fR` | n | Recent files (cwd) |
| `<leader>fc` | n | Find Config File |
| `<leader>fb` | n | Switch Buffer |
| `<leader>,` | n | Switch Buffer (alternate) |

#### Busca de Conteúdo

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>/` | n | **Live Grep** (root dir) |
| `<leader>sg` | n | Live Grep (root dir) |
| `<leader>sG` | n | Live Grep (cwd) |
| `<leader>sw` | n | Word under cursor (root) |
| `<leader>sW` | n | Word under cursor (cwd) |
| `<leader>sw` | v | Selection (root dir) |
| `<leader>sW` | v | Selection (cwd) |
| `<leader>sb` | n | Fuzzy find no buffer atual |

#### Busca de Sistema

| Tecla | Modo | Descrição |
|-------|------|-----------|
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

#### Busca de Diagnósticos & Símbolos

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>sd` | n | Document Diagnostics |
| `<leader>sD` | n | Workspace Diagnostics |
| `<leader>sy` | n | Document Symbols |
| `<leader>sY` | n | Workspace Symbols |
| `<leader>st` | n | Treesitter Symbols |
| `<leader>sl` | n | Location List |
| `<leader>sq` | n | Quickfix List |
| `<leader>sj` | n | Jumplist |

#### Busca Git

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>gc` | n | Git Commits |
| `<leader>gs` | n | Git Status |
| `<leader>gb` | n | Git Branches |
| `<leader>gf` | n | Git Files |
| `<leader>gS` | n | Git Stash |

#### Busca LSP

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>lr` | n | LSP References |
| `<leader>li` | n | LSP Implementations |
| `<leader>ld` | n | LSP Definitions |
| `<leader>lt` | n | LSP Type Definitions |
| `<leader>ss` | n | Goto Symbol |
| `<leader>sS` | n | Goto Symbol (Workspace) |

#### Outras Buscas

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>sn` | n | Notifications (Snacks) |
| `<leader>sp` | n | Telescope Pickers |
| `<leader>uC` | n | Colorscheme with Preview |

### 🤖 **GitHub Copilot**

#### Copilot Code (Inline Suggestions)

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<Tab>` | i | Aceitar sugestão |
| `<C-]>` | i | Próxima sugestão |
| `<C-[>` | i | Sugestão anterior |
| `<C-\>` | i | Demitir sugestão |

#### Copilot Chat

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>aa` | n,v | **Prompt Actions** (Telescope) |
| `<leader>ae` | n,v | **Explain** code |
| `<leader>at` | n,v | **Generate Tests** |
| `<leader>ar` | n,v | **Review** code |
| `<leader>aR` | n,v | **Refactor** |
| `<leader>an` | n,v | **Better Namings** |
| `<leader>ad` | n,v | **Documentation** |
| `<leader>af` | n,v | **Fix Code** |
| `<leader>aq` | n,v | Quick Chat |

**Prompts Disponíveis:**
- **Explain**: Explica como o código funciona
- **Review**: Revisa código e sugere melhorias
- **Tests**: Gera unit tests
- **Refactor**: Refatora para melhorar clareza
- **FixCode**: Corrige bugs
- **FixError**: Explica e resolve erros
- **BetterNamings**: Sugere nomes melhores
- **Documentation**: Gera documentação
- **SwaggerApiDocs**: Documentação Swagger
- **Summarize**: Resume texto
- **Spelling**: Corrige gramática
- **Wording**: Melhora redação
- **Concise**: Torna texto conciso

### 💻 **LSP (Language Server)**

#### Navegação

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `gd` | n | Goto Definition |
| `gr` | n | Goto References |
| `gI` | n | Goto Implementation |
| `gy` | n | Goto Type Definition |
| `gD` | n | Goto Declaration |
| `K` | n | Hover Documentation |
| `gK` | n | Signature Help |

#### Code Actions

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>ca` | n,v | Code Action |
| `<leader>cA` | n | Source Action |
| `<leader>cr` | n | Rename |
| `<leader>cc` | n | Run Codelens |
| `<leader>cC` | n | Refresh Codelens |
| `<leader>cf` | n,v | Format Document/Range |
| `<leader>cn` | n | Conform Info |
| `<leader>cl` | n | LSP Info |

#### Diagnósticos

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `]d` | n | Próximo Diagnostic |
| `[d` | n | Diagnostic Anterior |
| `]e` | n | Próximo Error |
| `[e` | n | Error Anterior |
| `]w` | n | Próximo Warning |
| `[w` | n | Warning Anterior |
| `<leader>cd` | n | Line Diagnostics |

### 🧪 **Testing (Neotest)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>tt` | n | **Run File** (todos os testes do arquivo) |
| `<leader>tT` | n | **Run All** (todos os testes do projeto) |
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

### 🐛 **Debugging (DAP)**

#### Controle de Execução

| Tecla | Modo | Descrição |
|-------|------|-----------|
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

#### DAP UI

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>du` | n | **Toggle DAP UI** |
| `<leader>de` | n,v | **Eval** expression |
| `<leader>dE` | n | **Eval** (prompt) |
| `<leader>dw` | n | **Watches** window |
| `<leader>ds` | n | **Scopes** window |
| `<leader>dr` | n | **REPL** window |
| `<leader>dc` | n | **Console** window |

#### DAP Go (específico)

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>td` | n | Debug Go Test (nearest) |
| `<leader>tl` | n | Debug Last Go Test |

### ✏️ **Refactoring**

| Tecla | Modo | Descrição |
|-------|------|-----------|
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

### 🦀 **Rust (Rustacean)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
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

### 🏃 **Go (go-tools)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>gsj` | n | **Add JSON tags** |
| `<leader>gsy` | n | **Add YAML tags** |
| `<leader>gst` | n | **Modify struct tags** (prompt) |
| `<leader>gi` | n | **Generate Interface Implementation** |
| `<leader>gf` | n | **Fill Struct Fields** |

### 🎩 **Haskell (haskell-tools)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>hs` | n | **Start HLS** |
| `<leader>hS` | n | **Stop HLS** |
| `<leader>hr` | n | **Restart HLS** |
| `<leader>hh` | n | **Hoogle Signature** |
| `<leader>rr` | n | **Toggle GHCi REPL** |
| `<leader>rf` | n | **REPL for current file** |
| `<leader>rq` | n | **Quit REPL** |

### ☕ **Java (jdtls)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>cxv` | v | **Extract Variable** |
| `<leader>cxc` | n | **Extract Constant** |
| `<leader>cxm` | v | **Extract Method** |
| `<leader>cgs` | n | **Goto Super** |
| `<leader>cgS` | n | **Goto Subjects** (tests) |
| `<leader>co` | n | **Organize Imports** |
| `<leader>tc` | n | **Run All Tests** (Java) |
| `<leader>tr` | n | **Run Nearest Test** (Java) |
| `<leader>tT` | n | **Pick Test** (Java) |

### 🔧 **C/C++ (clangd)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>ch` | n | **Switch Source/Header** |
| `<leader>cH` | n | **Toggle Inlay Hints** |

### 📝 **TypeScript/JavaScript**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>co` | n | **Organize Imports** |
| `<leader>cM` | n | **Add missing imports** |
| `<leader>cR` | n | **Remove unused imports** |
| `<leader>cD` | n | **Fix all diagnostics** |
| `<leader>cV` | n | **Select TS workspace version** |

### 📦 **Elixir**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>cp` | n | **To Pipe** |
| `<leader>cP` | n | **From Pipe** |

### ⚡ **Flash (Navegação Rápida)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `s` | n,x,o | **Flash Jump** |
| `S` | n,x,o | **Flash Treesitter** |
| `r` | o | **Remote Flash** |
| `R` | o,x | **Treesitter Search** |
| `<C-s>` | c | **Toggle Flash Search** |

### 📋 **Clipboard & Edição**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>cf` | n,v | **Format** |
| `<leader>cg` | n | **Neogen** (gerar documentação) |
| `<leader>sr` | n,v | **Search and Replace** (grug-far) |
| `p` | v | Paste sem sobrescrever clipboard |
| `<C-/>` | i,n,t | Toggle terminal |

### 🔖 **Sessões (Persistence)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>qs` | n | **Restore Session** |
| `<leader>qS` | n | **Select Session** |
| `<leader>ql` | n | **Restore Last Session** |
| `<leader>qd` | n | **Don't Save Session** |

### 📑 **Trouble (Diagnósticos)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>xx` | n | **Diagnostics** (Trouble) |
| `<leader>xX` | n | **Buffer Diagnostics** |
| `<leader>cs` | n | **Symbols** (Trouble) |
| `<leader>cS` | n | **LSP references** (Trouble) |
| `<leader>xL` | n | **Location List** |
| `<leader>xQ` | n | **Quickfix List** |

### 📦 **NPM (package-info)**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>ns` | n | **Telescope Package Info** |

### 📄 **Markdown Preview**

| Tecla | Modo | Descrição |
|-------|------|-----------|
| `<leader>cp` | n | **Markdown Preview** |

### 🎮 **Vim-be-good**

```vim
:VimBeGood  " Inicia treinamento de Vim motions
```

### 🏠 **Dashboard (Snacks)**

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
" Criar novo projeto Rust
:RustNew nome_do_projeto

" Criar novo módulo Go
:GoNew nome_do_modulo

" Criar novo projeto Haskell
:HaskellNew nome_do_projeto

" Informações de conformação
:ConformInfo

" Mason (gerenciar LSP/DAP/linters)
:Mason
```

---

## 🎨 Temas

O tema padrão é **Gruvbox**. Para mudar:

```lua
-- Em ~/.config/nvim/lua/config/options.lua
vim.cmd.colorscheme("gruvbox")  -- ou outro tema instalado
```

Temas disponíveis via `:Telescope colorscheme`

---

## 🧪 Linguagens Suportadas

### ✅ Suporte Completo (LSP + Testing + Debugging + Snippets)

- **Rust** - rust-analyzer, rustfmt, clippy, cargo, DAP, neotest
- **Go** - gopls, gofmt, golangci-lint, DAP, neotest
- **Haskell** - HLS, GHCi REPL, Hoogle, neotest
- **Java** - jdtls, refactoring, DAP, junit
- **C/C++** - clangd, clang-format, DAP
- **Julia** - julia-lsp, formatter

### 🟢 Suporte LSP + Snippets

- **TypeScript/JavaScript** - vtsls/denols, prettier, eslint
- **Python** - pyright, ruff, black
- **Lua** - lua-ls (otimizado para Neovim dev)
- **Elixir** - elixirls, neotest
- **Zig** - zls, neotest

### 🟡 Suporte Básico (LSP)

- **Ruby**, **PHP**, **Bash**, **YAML**, **JSON**, **TOML**, **Markdown**

---

## 📚 Documentação Adicional

### LazyVim

Este projeto é construído sobre [LazyVim](https://www.lazyvim.org/), um starter config para Neovim. Consulte a documentação oficial para:

- [Configuração Geral](https://www.lazyvim.org/configuration)
- [Plugins Extras](https://www.lazyvim.org/extras)
- [Keymaps Padrão](https://www.lazyvim.org/keymaps)

### Plugins Principais

- **Telescope**: [Documentação](https://github.com/nvim-telescope/telescope.nvim)
- **LSP**: [Neovim LSP Guide](https://neovim.io/doc/user/lsp.html)
- **Neotest**: [Documentação](https://github.com/nvim-neotest/neotest)
- **DAP**: [Debug Adapter Protocol](https://github.com/mfussenegger/nvim-dap)
- **Copilot**: [GitHub Copilot Docs](https://docs.github.com/en/copilot)

---

## 🛠️ Troubleshooting

### LSP não está funcionando

```vim
:checkhealth     " Verifica saúde geral
:LspInfo         " Informações do LSP
:Mason           " Reinstalar servers
```

### Copilot não sugere código

```vim
:Copilot status  " Verifica status
:Copilot setup   " Reautenticar
```

### Plugins não carregam

```vim
:Lazy sync       " Sincronizar plugins
:Lazy clean      " Limpar plugins não usados
:Lazy restore    " Restaurar do lockfile
```

### Performance lenta

```vim
:Lazy profile    " Analisar tempo de carregamento
```

Limpar cache:
```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

---

## 🔄 Atualizações

### Atualizar Vim Grimory

```bash
cd ~/.config/nvim
git pull
```

### Atualizar Plugins

```vim
:Lazy sync
```

### Atualizar LSP Servers

```vim
:Mason
" Pressione 'U' para atualizar todos
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -am 'Add: MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 📜 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

**jhserodio** - [GitHub](https://github.com/jhserodio)

---

## 🙏 Agradecimentos

- [LazyVim](https://github.com/LazyVim/LazyVim) - Framework base
- [Neovim](https://neovim.io/) - Editor moderno
- Comunidade open-source de plugins Neovim
- GitHub Copilot pela integração AI

---

## 📊 Estatísticas do Projeto

- **60+ Plugins** cuidadosamente selecionados
- **10+ Linguagens** com suporte completo
- **200+ Keymaps** organizados
- **27 Snippets** customizados
- **5 Fases** de desenvolvimento concluídas

---

<div align="center">

### ⚔ Carambolas Never Die ⚔

**Software Crafter Edition** 🌟

Made with ❤️ and ☕

</div>
