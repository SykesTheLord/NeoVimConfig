# Keybind reference

`<leader>` = `-` &nbsp;·&nbsp; `<localleader>` = `_`

> **Discover bindings live:** `<leader>sk` (snacks keymap picker). `which-key`
> shows hints as you type any leader prefix.

---

## Core editing

| Key | Mode | Action |
|---|---|---|
| `<leader>w`, `<C-s>` | n, i | Save |
| `<leader>q` | n | Quit |
| `<leader>bd` | n | Delete buffer (without closing window) |
| `<Esc>` | n | Clear search highlight |
| `<` / `>` | v | Indent and re-select |
| `J` / `K` | v | Move selected lines down/up |
| `<leader>cf` | n, v | Format buffer / selection (conform.nvim) |
| `<leader>cR` | n | Rename current file (snacks) |

## Window navigation

| Key | Action |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left/down/up/right split |

## File explorer (neo-tree)

| Key | Action |
|---|---|
| `<leader>e` | Toggle file tree |
| `<leader>o` | Reveal current file in tree |

Sources inside neo-tree: filesystem / buffers / git status / document symbols
(top-bar tabs). Inside the tree: `o`/`l` open, `h` close, `s` h-split,
`v` v-split, `P` preview.

## Fuzzy / search (snacks picker)

| Key | Action |
|---|---|
| `<leader><space>` | Smart find files |
| `<leader>,` / `<leader>fb` | Buffers |
| `<leader>/`, `<leader>fg`, `<leader>sg` | Live grep |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fp` | Projects |
| `<leader>fc` | Find file in nvim config |
| `<leader>sw` | Grep word under cursor (n/x) |
| `<leader>sb` | Search lines in current buffer |
| `<leader>sB` | Grep open buffers |
| `<leader>:` / `<leader>sc` | Command history |
| `<leader>sC` | Commands |
| `<leader>s/` | Search history |
| `<leader>sd` / `<leader>sD` | Diagnostics (workspace / buffer) |
| `<leader>sh` | Help pages |
| `<leader>sH` | Highlight groups |
| `<leader>si` | Icons |
| `<leader>sj` | Jumplist |
| `<leader>sk` | Keymaps |
| `<leader>sl` | Location list |
| `<leader>sm` | Marks |
| `<leader>sM` | Man pages |
| `<leader>sq` | Quickfix list |
| `<leader>sR` | Resume last picker |
| `<leader>su` | Undo history |
| `<leader>s"` | Registers |
| `<leader>sa` | Autocmds |
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss notifications |
| `<leader>uC` | Pick colorscheme |

## LSP

| Key | Action |
|---|---|
| `K` | Hover docs |
| `gd` | Definitions (snacks picker) |
| `gD` | Declarations |
| `gr` | References |
| `gI` | Implementations |
| `gy` | Type definitions |
| `<C-k>` | Signature help (insert mode) |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (n/v) |
| `<leader>ss` | Document symbols |
| `<leader>sS` | Workspace symbols |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>e` (when LSP attached) | Show diagnostic float |
| `<leader>ld` | Diagnostics to location list |
| `<leader>uh` | Toggle inlay hints |

## Diagnostics / Trouble

| Key | Action |
|---|---|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xd` | Buffer diagnostics |
| `<leader>xs` | Symbols panel |
| `<leader>xS` | LSP refs / defs / impls panel |
| `<leader>xq` | Quickfix in Trouble |
| `<leader>xl` | Location list in Trouble |
| `<leader>xt` | TODO list in Trouble |

## Completion (blink.cmp)

| Key | Mode | Action |
|---|---|---|
| `<Tab>` / `<S-Tab>` | i, s | Next / prev completion |
| `<CR>` | i | Accept completion |
| `<C-y>` | i | Confirm (preset default) |
| `<C-Space>` | i | Trigger / show menu |
| `<C-e>` | i | Cancel |
| `<C-n>` / `<C-p>` | i | Next / prev item |
| `<C-b>` / `<C-f>` | i | Scroll docs up / down |

## Git

| Key | Action |
|---|---|
| `<leader>gs` | Git status (snacks) |
| `<leader>gl` / `<leader>gL` | Git log / git log for current line |
| `<leader>gb` | Branches |
| `<leader>gd` | Git diff (hunks) |
| `<leader>gf` | Git log for current file |
| `<leader>gS` | Git stash |
| `<leader>gB` | Open in browser (n/v) |
| `]h` / `[h` | Next / prev hunk (gitsigns) |
| `<leader>hp` | Preview hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hB` | Toggle line-blame virtual text |
| `<leader>hd` | Diff this |

## TODO comments

| Key | Action |
|---|---|
| `]t` / `[t` | Next / prev TODO |
| `<leader>xt` | TODOs in Trouble panel |

## Debugging (DAP)

| Key | Action |
|---|---|
| `<F5>` / `<leader>dc` | Continue / launch |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | DAP REPL |
| `<leader>dt` | Terminate session |
| `db` | Toggle breakpoint (persistent) |
| `dc` | Conditional breakpoint (persistent) |
| `bc` | Clear all breakpoints |
| `lp` | Log point |

## Undotree

| Key | Action |
|---|---|
| `<leader>u` | Toggle |
| `<leader>uo` | Open |
| `<leader>uc` | Close |

## UI toggles

| Key | Toggles |
|---|---|
| `<leader>us` | Spell check |
| `<leader>uw` | Word wrap |
| `<leader>ud` | Diagnostics |
| `<leader>uh` | Inlay hints |
| `<leader>ul` | Line numbers |
| `<leader>uL` | Relative line numbers |
| `<leader>uc` | Conceal level |
| `<leader>uT` | Treesitter highlight |
| `<leader>ug` | Indent guides |
| `<leader>uD` | Dim inactive |
| `<leader>uC` | Pick colorscheme |

## Terminal

| Key | Mode | Action |
|---|---|---|
| `<C-/>` (or `<C-_>`) | n | Toggle floating terminal (snacks) |
| `<Esc>` | t | Exit terminal mode |

## Treesitter textobjects

Inside / around motions (operator-pending and visual):

| Key | Object |
|---|---|
| `af` / `if` | Function (outer / inner) |
| `ac` / `ic` | Class |
| `aa` / `ia` | Parameter / argument |
| `al` / `il` | Loop |
| `ai` / `ii` | Conditional |

Movement:

| Key | Action |
|---|---|
| `]m` / `[m` | Next / prev function start |
| `]M` / `[M` | Next / prev function end |
| `]]` / `[[` | Next / prev class start |
| `][` / `[]` | Next / prev class end |

Snacks word motions (also active in terminal mode):

| Key | Action |
|---|---|
| `]]` / `[[` (in terminal/normal when no class) | Next / prev reference |

## Misc

| Key | Action |
|---|---|
| `<leader>z` | Zen mode |
| `<leader>Z` | Zoom current window |
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |
| `<leader>mp` | Toggle markdown preview |
| `<leader>N` | Open Neovim NEWS |
