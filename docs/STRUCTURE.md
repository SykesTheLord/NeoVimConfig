# Project structure

## Layout

```
~/.config/nvim/
├── init.lua                       -- entry point: leader keys + ordered requires
├── install.sh                     -- distro-aware bootstrap script
├── README.md
├── docs/
│   ├── KEYBINDS.md
│   └── STRUCTURE.md               (this file)
└── lua/
    ├── packages.lua               -- vim.pack plugin list + build hook for blink.cmp
    ├── options.lua                -- vim.opt settings + diagnostic.config
    ├── keymap.lua                 -- global keymaps not tied to any plugin
    ├── ui.lua                     -- colorscheme, bufferline, startup neo-tree
    ├── workarounds.lua            -- clipboard provider detection (WSL/Wayland/X11)
    └── configs/
        ├── blink.lua              -- blink.cmp completion setup
        ├── conform.lua            -- formatters_by_ft + format-on-save
        ├── corn.lua               -- floating diagnostic display
        ├── dap.lua                -- adapters (Python/C#/Java/C/C++/Rust) + dap-ui + persistent-breakpoints + keymaps
        ├── git.lua                -- gitsigns (per-buffer hunk keymaps on attach)
        ├── lint.lua               -- nvim-lint linters_by_ft + autocmd
        ├── lsp.lua                -- vim.lsp.config/enable for every server, on_attach, root detection
        ├── mason.lua              -- mason + mason-lspconfig + mason-tool-installer
        ├── misc.lua               -- which-key, markdown-preview globals
        ├── neotree.lua            -- neo-tree, window-picker, lsp-file-operations, doc-symbols autocmd
        ├── snacks.lua             -- snacks.nvim opts + ~80 keymaps (pickers, terminal, zen, words, toggles)
        ├── statusline.lua         -- lualine
        ├── todo.lua               -- todo-comments + jumps
        ├── treesitter.lua         -- parser install + treesitter-context + textobjects
        ├── trouble.lua            -- trouble.nvim diagnostics/symbols panels
        └── ts-misc.lua            -- rainbow-delimiters, autopairs, colorizer
```

## Load order

`init.lua` requires modules in dependency order:

```
packages    -- vim.pack.add() + packadd: every plugin reachable after this
options     -- vim.opt + diagnostic.config (before plugins draw anything)
configs.snacks
configs.treesitter
configs.mason       -- before configs.lsp (so mason_bin() paths resolve)
configs.blink       -- before configs.lsp (lsp.lua reads blink capabilities)
configs.lsp
configs.conform
configs.lint
configs.dap
configs.git
configs.statusline
configs.ts-misc
configs.trouble
configs.todo
configs.neotree
configs.corn
configs.misc
keymap, ui, workarounds  -- last
```

## How it works

### Plugin manager — `vim.pack` (built-in)
`lua/packages.lua` declares every plugin as `{ src = "https://github.com/..." }`
and calls `vim.pack.add(plugins)`. After install, every plugin lives in
`~/.local/share/nvim/site/pack/core/opt/<name>` and is loaded eagerly via
`vim.cmd.packadd`. Updates: `:lua vim.pack.update()`.

`PackChanged` autocmd in `packages.lua` rebuilds `blink.cmp`'s Rust matcher
on install/update of that plugin. A first-run guard rebuilds it if the shared
library is missing.

### LSP — `vim.lsp.config` / `vim.lsp.enable` (built-in, Neovim 0.11+)
`lua/configs/lsp.lua`:
- Pulls completion capabilities from `require('blink.cmp').get_lsp_capabilities()`.
- Defines a `servers` table keyed by server name with `cmd` / `filetypes` /
  `root_markers`.
- `mason_bin(exe)` resolves the Mason-managed binary path; falls back to `$PATH`.
- `root_dir_fn(markers)` provides a robust single-file fallback so LSP attaches
  even outside a git repo.
- `on_attach`: sets buffer-local LSP keymaps (`K`, `gd`, `gD`, `gi`,
  `<leader>rn`, `<leader>ca`, etc.), enables `vim.lsp.inlay_hint`, and sets
  up `documentHighlight` on `CursorHold`.
- Final `vim.lsp.config('*', { capabilities, on_attach })` + per-server
  `vim.lsp.config(name, cfg)` + `vim.lsp.enable(enabled)`.

### Completion — `blink.cmp`
`lua/configs/blink.lua`: `default` keymap preset (`Tab`/`S-Tab` navigate,
`<CR>` accept, `<C-Space>` trigger). Sources: `lsp`, `path`, `snippets`,
`buffer`. Fuzzy matcher uses `prefer_rust_with_warning` — the Rust matcher
is built by the `PackChanged` hook; falls back to Lua otherwise.

### Treesitter — native (Neovim 0.12+)
`lua/configs/treesitter.lua` calls `nvim-treesitter.install.install(...)` once
to install parsers, then a `FileType` autocmd starts highlighting and sets
`indentexpr` using the new built-in indent. `treesitter-context` and
`treesitter-textobjects` are configured separately.

### Formatting & linting
- `conform.nvim` (`lua/configs/conform.lua`) runs on `BufWritePre`, falls back
  to LSP formatting. Override per-filetype in `formatters_by_ft`.
- `nvim-lint` (`lua/configs/lint.lua`) runs on `BufWritePost`/`BufReadPost`/
  `InsertLeave`. Add linters to `linters_by_ft`.

### Debugging
`lua/configs/dap.lua` defines adapters and configurations for Python, C#,
Java, C/C++ (also reused for Rust). `nvim-dap-virtual-text` shows inline
variable values; `persistent-breakpoints.nvim` survives restarts. Keymaps:
`F5`/`F10`/`F11`/`F12` and `db`/`dc`/`bc`/`lp`.

### Mason
`lua/configs/mason.lua` lists LSPs in `mason-lspconfig.ensure_installed`
(those start automatically), and formatters / linters / DAP adapters in
`mason-tool-installer.ensure_installed`. `csharp-language-server` is pinned
to `0.16.0` to avoid a known regression.

## Extending the config

### Add a plugin
1. Append `{ src = "https://github.com/user/repo" }` to the `plugins` table
   in `lua/packages.lua`.
2. Restart Neovim — `vim.pack` will install it.
3. Create or edit a file in `lua/configs/` to call its `setup()`.
4. `require` that file from `init.lua` (in the right load-order position).

### Add a language

| Concern | Where |
|---|---|
| LSP server | `lua/configs/lsp.lua` — add an entry to `servers = {...}` |
| Mason auto-install | `lua/configs/mason.lua` — add to `mason-lspconfig.ensure_installed` (or `mason-tool-installer.ensure_installed` for non-LSP tools) |
| Formatter | `lua/configs/conform.lua` — add to `formatters_by_ft` |
| Linter | `lua/configs/lint.lua` — add to `linters_by_ft` |
| DAP adapter | `lua/configs/dap.lua` — add `dap.adapters.<name>` and `dap.configurations.<filetype>` |
| Treesitter parser | `lua/configs/treesitter.lua` — add the parser name to the install list |

### Update plugins
`:lua vim.pack.update()` inside Neovim. The `PackChanged` autocmd rebuilds
`blink.cmp` if it changed.

## Built-ins this config relies on

- `vim.pack` — plugin manager (0.12)
- `vim.lsp.config` / `vim.lsp.enable` — server configuration (0.11+)
- `vim.snippet` — snippet engine used by blink's `default` preset
- Native treesitter highlighting + indent (0.12)
- `vim.diagnostic.config` — diagnostic UI, sign text, severity sort
- `vim.lsp.inlay_hint` — inlay hint toggle
- `vim.lsp.buf.document_highlight` — cursor symbol highlighting
