# Neovim IDE Config

A Neovim 0.12+ configuration tuned to feel like a full IDE while leaning on
built-in tooling where the trade-off is small. Plugins are managed by the
native `vim.pack`, LSP via `vim.lsp.config`/`vim.lsp.enable`, and the only
heavy non-built-in pieces are `snacks.nvim` (picker/explorer/UI),
`blink.cmp` (completion), and `nvim-treesitter` (parsers).

**Leader keys:** `-` (global), `_` (local).

**Supported languages (LSP):** C/C++, C#, Python, JavaScript/TypeScript,
JSON, YAML, Terraform, Docker / Docker-Compose, Bash, Java, Lua, Markdown,
CMake, Vim, SQL, Rust, Bicep, PowerShell.

## Install

```bash
git clone <this-repo> ~/.config/nvim
~/.config/nvim/install.sh
```

`install.sh` detects your distro (Ubuntu / Debian / Fedora / Arch / openSUSE),
installs the required system packages, ensures Neovim ≥ 0.12 (falls back to
the official AppImage if your distro's package is too old), and bootstraps
plugins, LSPs, treesitter parsers, and the `blink.cmp` Rust fuzzy matcher.

Useful flags:

| Flag | Effect |
|------|--------|
| `--force` | Back up an existing `~/.config/nvim` and replace it |
| `--no-bootstrap` | Only install system packages; skip plugin/LSP setup |
| `--appimage` | Force AppImage install (default on Ubuntu/Debian) |
| `--no-appimage` | Use the distro's Neovim package even on Ubuntu/Debian |
| `--yes` / `-y` | Don't prompt — assume yes |

## Manual install

1. Install Neovim ≥ 0.12, `git`, `curl`, `rustc`/`cargo` (for `blink.cmp`),
   `ripgrep`, `fd`, `nodejs`/`npm`, `python3`, `xclip`, `wl-clipboard`,
   and a C toolchain.
2. Clone this repo to `~/.config/nvim`.
3. Launch `nvim` — `vim.pack` will fetch all plugins on first start. Mason
   will install LSPs/formatters/linters automatically. `blink.cmp`'s Rust
   matcher is built on first install via a `PackChanged` autocmd.
4. (Optional) Run `:TSUpdate` once to install treesitter parsers.
5. (Markdown preview only) `cd ~/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app && npm install`.

## First start

Expect roughly the following on a clean machine:

1. `vim.pack` clones ~35 plugins into `~/.local/share/nvim/site/pack/core/opt/`.
2. The `PackChanged` autocmd runs `require('blink.cmp').build()` — compiles the
   Rust fuzzy matcher (one-time, ~30s).
3. Mason kicks off `automatic_installation` for every LSP / formatter / linter
   declared in `lua/configs/mason.lua` (this happens in the background and may
   take a few minutes).
4. Treesitter parsers install asynchronously via `vim.schedule` in
   `lua/configs/treesitter.lua`.
5. `nordic` colorscheme + neo-tree open; you're in.

Run `:checkhealth` to verify everything (look at `lsp`, `mason`, `treesitter`,
`blink`).

## Docs

- [`docs/STRUCTURE.md`](docs/STRUCTURE.md) — file-by-file layout and how to extend (add a language, add a plugin)
- [`docs/KEYBINDS.md`](docs/KEYBINDS.md) — full keymap reference, grouped by purpose

Inside Neovim, `<leader>sk` (snacks keymap picker) shows every binding
interactively; `which-key` shows live hints as you type leader prefixes.
