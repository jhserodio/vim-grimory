# Guia de Instalação - Neovim no Fedora 43

## Problema Identificado

O erro que você está enfrentando ocorre porque:
1. O Neovim não está instalado no seu sistema
2. Você está usando VS Code via Flatpak, que tem acesso limitado ao sistema
3. O plugin `snacks.nvim` estava tentando carregar o módulo `statuscolumn` que não estava disponível

## Solução

### 1. Instalar Neovim no Fedora 43

Você tem duas opções:

#### Opção A: Instalar via DNF (Recomendado)

```bash
# Instalar Neovim estável
sudo dnf install neovim

# OU instalar a versão mais recente via COPR
sudo dnf copr enable agriffis/neovim-nightly
sudo dnf install neovim
```

#### Opção B: Instalar via AppImage (Mais recente)

```bash
# Baixar o AppImage mais recente
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

# Tornar executável
chmod +x nvim.appimage

# Mover para um local no PATH
mkdir -p ~/.local/bin
mv nvim.appimage ~/.local/bin/nvim

# Adicionar ao PATH se ainda não estiver
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 2. Verificar Instalação

```bash
nvim --version
```

Você deve ver algo como:
```
NVIM v0.10.x
Build type: Release
...
```

### 3. Primeira Execução do LazyVim

```bash
# Navegar até o diretório de configuração
cd ~/dev/vim-grimory

# Executar Neovim
nvim
```

Na primeira execução, o Lazy.nvim irá:
1. Baixar todos os plugins automaticamente
2. Compilar o que for necessário
3. Configurar tudo

### 4. Configurações Aplicadas

Eu já corrigi o arquivo `lua/plugins/snacks.lua` para:
- Desabilitar o `statuscolumn` que estava causando o erro
- Desabilitar o `bigfile` para evitar conflitos
- Manter as outras funcionalidades do snacks.nvim

### 5. Atualizar Plugins (após instalação)

Uma vez que o Neovim estiver funcionando:

```vim
:Lazy sync
```

## Comandos Úteis no LazyVim

- `:Lazy` - Abrir interface do gerenciador de plugins
- `:Lazy sync` - Atualizar todos os plugins
- `:Lazy clean` - Remover plugins não utilizados
- `:checkhealth` - Verificar saúde da instalação
- `:Mason` - Gerenciar LSP servers, formatters, etc.

## Troubleshooting

### Se ainda tiver erros:

1. **Limpar cache e plugins do Neovim:**
   ```bash
   rm -rf ~/.local/share/nvim
   rm -rf ~/.local/state/nvim
   rm -rf ~/.cache/nvim
   ```

2. **Reinstalar plugins:**
   ```vim
   :Lazy restore
   ```

3. **Verificar saúde:**
   ```vim
   :checkhealth
   :checkhealth mason
   ```

4. **Forçar atualização de plugins específicos:**
   ```vim
   :Lazy clean
   :Lazy sync
   ```

### Para usar com VS Code (opcional):

Se você quiser usar o Neovim como backend do VS Code:

1. Instalar a extensão "VSCode Neovim"
2. Configurar no VS Code settings.json:
   ```json
   {
     "vscode-neovim.neovimExecutablePaths.linux": "/usr/bin/nvim"
   }
   ```

## Configuração Específica para Fedora/Wayland

Sua configuração já está ajustada para Wayland (veja `lua/config/options.lua`):
- Usando `wl-copy` e `wl-paste` para clipboard
- Isso deve funcionar perfeitamente no Fedora com Wayland

## Próximos Passos

1. Instale o Neovim usando uma das opções acima
2. Execute `nvim` no diretório da configuração
3. Aguarde os plugins serem instalados
4. Aproveite sua configuração LazyVim personalizada! ⚔ ☩ ⚔
