# NeoVim Configuration

A modern, modular, and performance-focused Neovim configuration built with [Lazy.nvim](https://github.com/folke/lazy.nvim). Tailored for embedded systems, C/C++, Python, and Lua development with out-of-the-box LSP integration, Treesitter syntax highlighting, and an elegant VSCode-inspired interface.

---

## Table of Contents

- [Directory Structure](#directory-structure)
- [Prerequisites & Installation](#prerequisites--installation)
- [Theme Configuration (Light / Dark Mode)](#theme-configuration-light--dark-mode)
- [Language Server Protocol (LSP)](#language-server-protocol-lsp)
  - [Supported Languages](#supported-languages)
  - [Compilation Database & .clangd Scanning](#compilation-database--clangd-scanning)
  - [LSP Keybindings](#lsp-keybindings)
- [Debugging & Diagnostics](#debugging--diagnostics)
- [Keybindings Overview](#keybindings-overview)
- [Troubleshooting](#troubleshooting)

---

## Directory Structure

```text
~/.config/nvim/
├── init.lua                    # Main entry point (loads ngxxfus module)
├── lazy-lock.json              # Locked plugin versions
├── readme.md                   # Documentation
└── lua/ngxxfus/
    ├── init.lua                # Bootstrap: leader key, set, remap, lazy loader
    ├── remap.lua               # Grouped keybindings (VSCode style, LSP, mouse, etc.)
    ├── set.lua                 # Core editor options (tabs, line numbers, clipboard)
    └── lazy/                   # Plugin specifications (managed by Lazy.nvim)
        ├── bufferline.lua      # Buffer tabs UI
        ├── cmp.lua             # Autocompletion (nvim-cmp + LuaSnip)
        ├── colorizer.lua       # Inline hex/rgb color previews
        ├── colorscheme.lua     # VSCode theme (Light/Dark toggle)
        ├── comment.lua         # Fast line/block commenting
        ├── dashboard.lua       # Startup dashboard
        ├── grug-far.lua        # Search and replace tool
        ├── icons.lua           # Nerd Font icons & devicons
        ├── lazygit.lua         # LazyGit UI integration
        ├── lsp.lua             # LSP configuration (clangd, pyright, lua_ls)
        ├── lualine.lua         # Statusline configuration
        ├── neotree.lua         # Dual-mode file explorer (Dock / Float)
        ├── sessions.lua        # Session management (Persistence.nvim)
        ├── telescope.lua       # Fuzzy finder (fzf native)
        ├── toggleterm.lua      # Floating/persistent terminal windows
        ├── treesitter.lua      # Treesitter syntax highlighting & parsers
        ├── trouble.lua         # Pretty diagnostic list
        ├── ufo.lua             # Modern code folding
        ├── vim-illuminate.lua  # Cursor word highlighting
        └── whichkey.lua        # Keybinding hints popup
```

---

## Prerequisites & Installation

### Prerequisites

- **Neovim** >= 0.9.0 (0.10+ recommended)
- **Git**
- **C/C++ Compiler & Clangd**: `gcc`, `g++`, `clang`, `clangd`
- **Node.js & npm** (required by Mason for language servers such as `pyright`)
- **Python 3 & pip**
- **Ripgrep & fd** (for fast Telescope fuzzy finding)
- **Clipboard Provider**: `xclip` or `wl-clipboard` (Linux)
- **Nerd Font** (recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font)

### Package Manager Commands

#### Void Linux
```bash
sudo xbps-install -S neovim git nodejs python3 ripgrep fd xclip clang-tools-extra
```

#### Ubuntu / Debian
```bash
sudo apt update
sudo apt install -y neovim git nodejs npm python3 python3-pip ripgrep fd-find xclip clangd
# Symlink fdfind to fd if needed:
mkdir -p ~/.local/bin && ln -sf $(which fdfind) ~/.local/bin/fd
```

#### Arch Linux
```bash
sudo pacman -S neovim git nodejs npm python python-pip ripgrep fd xclip clang
```

#### macOS (Homebrew)
```bash
brew install neovim git node python ripgrep fd llvm
```

### Setup Steps

1. **Clone the repository:**
   ```bash
   # Back up existing configuration if present
   mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

   # Clone into nvim config directory
   git clone https://github.com/ngxx-fus/neovim-conf.git ~/.config/nvim
   ```

2. **Launch Neovim:**
   ```bash
   nvim
   ```
   On first launch, Lazy.nvim will automatically clone itself, install all plugins, and configure Mason to install the core language servers (`clangd`, `pyright`, `lua_ls`).

---

## Theme Configuration (Light / Dark Mode)

The colorscheme is powered by `Mofiqul/vscode.nvim` and configured in `lua/ngxxfus/lazy/colorscheme.lua`.

### Switching Between Light and Dark Mode

Open [colorscheme.lua](file:///home/coder/.config/nvim/lua/ngxxfus/lazy/colorscheme.lua) and modify the `EnableDarkMode` variable at line 7:

```lua
--- @brief Toggle theme: 1 for Dark Mode, 0 for Light Mode.
local EnableDarkMode = 1  -- Set to 1 for Dark Mode, or 0 for Light Mode
```

- **`EnableDarkMode = 0`**: Activates VSCode Light theme with high-contrast text and clean UI highlights.
- **`EnableDarkMode = 1`**: Activates VSCode Dark theme with standard dark gray background.

### Switching to Another Theme

To use another theme (e.g., Tokyonight, Catppuccin, Gruvbox):
1. Add the plugin specification inside `lua/ngxxfus/lazy/` or replace `Mofiqul/vscode.nvim` in `colorscheme.lua`.
2. Apply the scheme with:
   ```lua
   vim.cmd.colorscheme("tokyonight") -- or "catppuccin", "gruvbox"
   ```

---

## Language Server Protocol (LSP)

LSP setup is configured in [lsp.lua](file:///home/coder/.config/nvim/lua/ngxxfus/lazy/lsp.lua) using `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, and `cmp-nvim-lsp`.

### Supported Languages

| Language | LSP Server | Package Manager | Features |
| :--- | :--- | :--- | :--- |
| **C / C++** | `clangd` | Mason / System clangd | Background indexing, clang-tidy, detailed completion, query-driver |
| **Python** | `pyright` | Mason | Type inference, workspace analysis, auto-import resolution |
| **Lua** | `lua_ls` | Mason | LuaJIT runtime, Neovim runtime (`vim.*`) awareness |

Servers defined in `ensure_installed` are automatically downloaded and managed by Mason.

### Compilation Database & .clangd Scanning

`clangd` requires a `compile_commands.json` file to recognize project include paths, compiler flags, and definitions (e.g., in CMake or ESP-IDF projects).

This configuration includes automated detection:
1. When opening a C/C++ file, `root_dir` detects the project root via:
   - `.clangd` folder or configuration file
   - `compile_commands.json`
   - `build/compile_commands.json`
   - `.git`
2. In `on_new_config`, clangd dynamically checks:
   - `<project_root>/.clangd/compile_commands.json`
   - `<project_root>/build/compile_commands.json`
   If found, it automatically appends `--compile-commands-dir=<path>` to clangd's execution command without needing manual flags.

#### Generating `compile_commands.json`:
- **CMake**:
  ```bash
  cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  ```
- **ESP-IDF**:
  ```bash
  idf.py reconfigure   # generates build/compile_commands.json
  ```
- **Using a `.clangd` folder**:
  You can place or symlink `compile_commands.json` directly into a `.clangd/` directory in your project root:
  ```bash
  mkdir -p .clangd
  ln -sf ../build/compile_commands.json .clangd/compile_commands.json
  ```

### LSP Keybindings

When an LSP server attaches to a buffer, the following keybindings become active:

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `gd` / `<F12>` | Go to Definition | Jump to symbol definition |
| `gD` | Go to Declaration | Jump to symbol declaration |
| `gi` / `gI` | Go to Implementation | Jump to interface/function implementation |
| `gr` | Go to References | Search all references across workspace |
| `K` | Hover Documentation | Display type signature, docs, and docstrings |
| `<leader>k` | Signature Help | Display function parameter signatures |
| `<leader>rn` | Rename Symbol | Smart rename symbol across the project |
| `<leader>ca` | Code Action | Quick fixes and refactoring options |
| `<leader>f` | Format Document | Format current buffer via active LSP |
| `<C-d>` | Float Diagnostics | Show diagnostic message under cursor |
| `<leader>xx` | Trouble Diagnostics | Open interactive diagnostics list |

---

## Debugging & Diagnostics

Use these built-in commands to inspect and troubleshoot LSP, parser, and plugin issues:

### 1. Check LSP Status (`:LspInfo`)
Inside any open file, run:
```vim
:LspInfo
```
- Verifies if an LSP client (e.g., `clangd`, `pyright`, `lua_ls`) is **attached** to the active buffer.
- Displays the identified **Root directory**.
- Shows active client **command arguments** (verify if `--compile-commands-dir` was applied).

### 2. Inspect LSP Log Output (`:LspLog`)
If a language server crashes or fails to analyze headers:
```vim
:LspLog
```
This opens `~/.local/state/nvim/lsp.log`. Look for error codes, missing toolchains, or path errors.

### 3. Check Mason Package Status (`:Mason`)
```vim
:Mason
```
- Interactive UI to view installed, available, and outdated servers/linters/formatters.
- Press `i` to install a server, `X` to uninstall, `u` to update.
- Run `:MasonLog` if server installation fails.

### 4. Check Treesitter Parsers (`:checkhealth nvim-treesitter`)
```vim
:checkhealth nvim-treesitter
```
Verifies installed syntax parsers (`c`, `cpp`, `python`, `lua`, `json`, `yaml`, `cmake`).
- Run `:TSUpdate` to update all parsers.
- Run `:TSInstall <language>` to manually install a parser.

### 5. General Neovim Health Check (`:checkhealth`)
```vim
:checkhealth
```
Checks system dependencies, clipboard utilities, Python/Node provider status, and terminal capability.

---

## Keybindings Overview

All keybindings are centralized and documented in [remap.lua](file:///home/coder/.config/nvim/lua/ngxxfus/remap.lua). Global leader is `<Space>`.

### Navigation & Editing
- `<A-j>` / `<A-k>`: Move line up / down (Normal and Visual modes)
- `<A-Down>` / `<A-Up>`: Move line up / down (Normal and Visual modes)
- `<C-Left>` / `<C-Right>`: Move cursor by word (Normal and Insert modes)
- `<C-a>`: Jump to beginning of line (Insert mode)
- `<C-e>`: Smart jump to end of line or dismiss autocomplete popup (Insert mode)
- `<Tab>` / `<S-Tab>`: Indent / unindent lines (Visual and Normal modes)
- `<M-ScrollWheelUp>` / `<M-ScrollWheelDown>`: Horizontal scroll left / right (Normal, Visual, Insert)
- `<Esc>`: Close floating preview windows and clear search highlight

### Buffer & Tab Management
- `<leader>h` / `<leader>l` or `<leader><Left>` / `<leader><Right>`: Previous / Next buffer
- `<leader>H` / `<leader>L`: Move buffer left / right in tabline
- `<leader>n`: New tab
- `<leader>q`: Close buffer (`:bdelete`)
- `<leader>Q`: Force close buffer (`:bdelete!`)
- `<A-1>` .. `<A-9>`: Jump directly to buffer 1–9

### File Explorer & Search
- `<leader>e`: Toggle Neo-tree explorer (Docked on left)
- `<leader>E`: Open Neo-tree explorer (Floating center)
- `<leader>ff`: Find files (Telescope)
- `<leader>fg`: Live grep text across project (Telescope)
- `<leader>fb`: List open buffers (Telescope)
- `<leader>fh`: Help tags (Telescope)

### Terminal & Git
- `<C-\>`: Toggle persistent floating terminal (`toggleterm`)
- `<leader>t`: Open horizontal terminal split (1/4 height)
- `<leader>th`: Hide terminal
- `<leader>tq`: Close terminal
- `<leader>gg`: Open LazyGit GUI

### Code Commenting
- `<C-/>` or `<C-_>`: Toggle comment on current line (Normal) or selection (Visual)
- `<C-k>`: Toggle comment on current line (Normal) or selection (Visual)

---

## Troubleshooting

### Clangd cannot locate standard library headers or project includes
1. Ensure `clangd` or `clang-tools-extra` is installed on your system.
2. Generate a `compile_commands.json` (via CMake or ESP-IDF).
3. If using a custom path, place it in `.clangd/compile_commands.json` or `build/compile_commands.json`.
4. Open a C/C++ file and run `:LspInfo` to confirm clangd attached and `--compile-commands-dir` was detected.

### Pyright cannot find virtual environment packages
In your project root, create a `pyrightconfig.json` or `pyproject.toml` pointing to your virtualenv:
```json
{
  "venvPath": ".",
  "venv": ".venv"
}
```

### Clipboard does not work
Install system clipboard tools:
- **X11**: `sudo apt install xclip` or `sudo xbps-install -S xclip`
- **Wayland**: `sudo apt install wl-clipboard` or `sudo xbps-install -S wl-clipboard`
- Run `:checkhealth provider` to verify Neovim detects the clipboard tool.

### Plugins fail to load or have syntax errors
Clean Lazy cache and reinstall:
```bash
rm -rf ~/.local/share/nvim/lazy/
nvim
```
Inside Neovim, run `:Lazy sync`.
