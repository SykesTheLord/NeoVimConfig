# Neovim Shortcuts Documentation

This document provides an overview of custom key bindings defined in the [init.vim](https://raw.githubusercontent.com/SykesTheLord/NeoVimConfig/refs/heads/main/init.vim) configuration as well as general Vim/Neovim key mappings categorized by mode. For additional background on Vim/Nvim mappings, refer to the [vim.rtorr.com cheat sheet](https://vim.rtorr.com/) :contentReference[oaicite:1]{index=1} and the [Neovim docs on mapping keys](https://neovim.io/doc/user/map.html) :contentReference[oaicite:2]{index=2}.

---

## Table of Contents

- [Basic Settings](#basic-settings)
- [General Vim/Neovim Key Mappings](#general-vimnvim-key-mappings)
  - [Normal Mode](#normal-mode)
  - [Insert Mode](#insert-mode)
  - [Visual Mode](#visual-mode)
  - [Command-Line Mode](#command-line-mode)
- [LSP Shortcuts](#lsp-shortcuts)
- [Telescope Shortcuts](#telescope-shortcuts)
- [Snippet Navigation Shortcuts](#snippet-navigation-shortcuts)
- [Window Navigation Shortcuts](#window-navigation-shortcuts)
- [DA Keyboard Remappings](#da-keyboard-remappings)
- [Debugger Shortcuts](#debugger-shortcuts)
- [Persistent Breakpoints Shortcuts](#persistent-breakpoints-shortcuts)
- [Terminal Mode Shortcut](#terminal-mode-shortcut)
- [Linting on Save](#linting-on-save)
- [Further Reading](#further-reading)

---

## Basic Settings

Several basic Neovim settings are configured in the file (line numbering, mouse support, tab settings, system clipboard, etc.). Although these aren’t key mappings per se, they set the stage for a streamlined editing experience.

---

## General Vim/Neovim Key Mappings

This section summarizes common Vim key bindings, organized by mode. These are the basic shortcuts you can use in any Vim or Neovim setup.

### Normal Mode

- **Navigation:**
  - `h`, `j`, `k`, `l`  
    *Move left, down, up, and right respectively.*
  - `w` / `b`  
    *Jump forward/backward by word.*
  - `0` / `$`  
    *Jump to the beginning or end of a line.*
  - `gg` / `G`  
    *Jump to the first/last line of the file.*

- **Editing & Text Operations:**
  - `dd`  
    *Delete the current line.*
  - `yy`  
    *Yank (copy) the current line.*
  - `p`  
    *Paste after the cursor.*
  - `x`  
    *Delete the character under the cursor.*
  - `dw`  
    *Delete from the cursor to the start of the next word.*
  - `cw` / `ciw`  
    *Change a word or the inner word.*
  - `u` / `CTRL-R`  
    *Undo / Redo changes.*

- **Searching & Substitution:**
  - `/pattern` / `?pattern`  
    *Search forward/backward for a pattern.*
  - `n` / `N`  
    *Repeat the search in the same/opposite direction.*
  - `:%s/old/new/g`  
    *Perform a global substitution within the file.*

### Insert Mode

- **Entering Text:**
  - `i`  
    *Insert before the cursor.*
  - `I`  
    *Insert at the beginning of the current line.*
  - `a`  
    *Append after the cursor.*
  - `A`  
    *Append at the end of the current line.*
  - `o`  
    *Open a new line below and enter Insert mode.*
  - `O`  
    *Open a new line above and enter Insert mode.*

- **Exiting:**
  - `Esc`  
    *Exit Insert mode and return to Normal mode.*

### Visual Mode

- **Selection:**
  - `v`  
    *Enter visual mode (character-wise selection).*
  - `V`  
    *Enter visual line mode (line-wise selection).*
  - `CTRL-V`  
    *Enter visual block mode.*

- **Editing Selected Text:**
  - `y`  
    *Yank (copy) the selected text.*
  - `d`  
    *Delete the selected text.*
  - `c`  
    *Change the selected text (delete and enter Insert mode).*

### Command-Line Mode

- **Command Execution:**
  - `:`  
    *Enter Command-line mode to execute Ex commands (e.g., saving `:w`, quitting `:q`).*

*For more detailed key mappings and usage, visit [vim.rtorr.com](https://vim.rtorr.com/) :contentReference[oaicite:3]{index=3}.*

---

## LSP Shortcuts

When an LSP server attaches to a buffer, the following Normal mode key mappings are configured:

- **`gd`**  
  *Action:* Opens Telescope’s definition finder (`Telescope lsp_definitions`).  
  *Description:* Jumps to the definition of the symbol under the cursor.

- **`gr`**  
  *Action:* Opens Telescope’s reference finder (`Telescope lsp_references`).  
  *Description:* Lists all references for the symbol.

- **`gi`**  
  *Action:* Opens Telescope’s implementation finder (`Telescope lsp_implementations`).  
  *Description:* Jumps to the implementation of the symbol.

- **`D`**  
  *Action:* Opens Telescope’s type definitions finder (`Telescope lsp_type_definitions`).  
  *Description:* Jumps to the type definition of the symbol.

- **`ds`**  
  *Action:* Opens Telescope’s document symbols (`Telescope lsp_document_symbols`).  
  *Description:* Lists symbols in the current file.

- **`ws`**  
  *Action:* Opens Telescope’s workspace symbols (`Telescope lsp_workspace_symbols`).  
  *Description:* Searches for symbols across the workspace.

- **`K`**  
  *Action:* Triggers LSP hover (`vim.lsp.buf.hover()`).  
  *Description:* Displays documentation or type information about the symbol.

- **`e`**  
  *Action:* Shows diagnostics for the current line (`vim.lsp.diagnostic.show_line_diagnostics()`).  
  *Description:* Provides error and warning messages.

- **`[d` and **`]d`**  
  *Actions:* Navigate to previous (`vim.lsp.diagnostic.goto_prev()`) and next (`vim.lsp.diagnostic.goto_next()`) diagnostics.

- **`q`**  
  *Action:* Populates the location list with diagnostics (`vim.lsp.diagnostic.set_loclist()`).  
  *Description:* Prepares diagnostics for an overview and quick navigation.

---

## Telescope Shortcuts

Telescope, the fuzzy finder, is bound to the following Normal mode shortcuts:

- **`ff`**  
  *Action:* Opens the file finder (`telescope.builtin.find_files()`).  
  *Description:* Search and open files.

- **`fg`**  
  *Action:* Launches live grep (`telescope.builtin.live_grep()`).  
  *Description:* Search text across files.

- **`fb`**  
  *Action:* Lists open buffers (`telescope.builtin.buffers()`).  
  *Description:* Switch between open buffers.

- **`fh`**  
  *Action:* Displays help tags (`telescope.builtin.help_tags()`).  
  *Description:* Access Vim’s help documentation.

---

## Snippet Navigation Shortcuts

Using LuaSnip for snippet management, these shortcuts (configured for Insert and Select modes) enable efficient snippet navigation:

- **`<C-k>`**  
  *Action:* Jump to the next snippet placeholder.

- **`<C-j>`**  
  *Action:* Jump to the previous snippet placeholder.

- **`<C-l>`**  
  *Action:* Cycle through available snippet choices (if a choice list is active).

*Note: These key strings are defined using `vim.keymap.set` in the configuration and can be adjusted based on personal preference.*

---

## Window Navigation Shortcuts

Enhance split window navigation without needing to rely solely on `<C-w>` commands:

- **`<A-h>`**  
  *Action:* Move to the left split window.

- **`<A-j>`**  
  *Action:* Move to the split below.

- **`<A-k>`**  
  *Action:* Move to the split above.

- **`<A-l>`**  
  *Action:* Move to the right split window.

---

## DA Keyboard Remappings

Adjustments for the Danish keyboard layout include the following remappings:

- **`^`**  
  *Remapped to:* `}`  
  *Description:* Jump to the next paragraph.

- **`&`**  
  *Remapped to:* `^`  
  *Description:* Facilitate easier navigation.

- **`Å`**  
  *Remapped to:* `{`  
  *Description:* Jump to the previous paragraph.

---

## Debugger Shortcuts

The configuration integrates debugging support via [nvim-dap](https://github.com/mfussenegger/nvim-dap). Key debugger actions—such as continue, step over, step into, and step out—are defined using `vim.api.nvim_set_keymap`. Customize these mappings further as needed.

---

## Persistent Breakpoints Shortcuts

For managing breakpoints persistently, the following Normal mode mappings are provided:

- **`db`**  
  *Action:* Toggle a breakpoint at the current line.  
  *Command:* `lua require('persistent-breakpoints.api').toggle_breakpoint()`

- **`dc`**  
  *Action:* Set a conditional breakpoint.  
  *Command:* `lua require('persistent-breakpoints.api').set_conditional_breakpoint()`

- **`bc`**  
  *Action:* Clear all breakpoints.  
  *Command:* `lua require('persistent-breakpoints.api').clear_all_breakpoints()`

- **`lp`**  
  *Action:* Set a log point.  
  *Command:* `lua require('persistent-breakpoints.api').set_log_point()`

---

## Terminal Mode Shortcut

- **`<C-\><C-n>`**  
  *Action:* Exit terminal insert mode and return to Normal mode.

---

## Linting on Save

An autocommand is set to trigger linting when a file is saved:

- **On file save (BufWritePost):**  
  *Action:* Automatically executes `lua require('lint').try_lint()`.  
  *Description:* This ensures that linting occurs immediately after saving the file.

---

## Further Reading

- [Neovim Key Mapping Documentation](https://neovim.io/doc/user/map.html) :contentReference[oaicite:4]{index=4}  
- [Vim Cheat Sheet (vim.rtorr.com)](https://vim.rtorr.com/) :contentReference[oaicite:5]{index=5}  
- [Neovim Lua API](https://neovim.io/doc/user/lua.html) :contentReference[oaicite:6]{index=6}  
- [Telescope.nvim README](https://github.com/nvim-telescope/telescope.nvim)  
- [nvim-dap Documentation](https://github.com/mfussenegger/nvim-dap)

---

*This documentation is based on the custom configuration available at [SykesTheLord/NeoVimConfig](https://raw.githubusercontent.com/SykesTheLord/NeoVimConfig/refs/heads/main/init.vim) :contentReference[oaicite:7]{index=7}. Adjust and extend these mappings to best fit your workflow.*
