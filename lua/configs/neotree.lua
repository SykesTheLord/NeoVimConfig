require("window-picker").setup({
    filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
        },
    },
})

require("lsp-file-operations").setup()

require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf", "Outline" },
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    source_selector = {
        winbar = true,
        sources = {
            { source = "filesystem",       display_name = " 󰉓 Files " },
            { source = "buffers",          display_name = " 󰈚 Bufs " },
            { source = "git_status",       display_name = " 󰊢 Git " },
            { source = "document_symbols", display_name = " 󰈇 Symbols " },
        },
    },
    default_component_configs = {
        indent = { with_markers = true, indent_marker = "│", last_indent_marker = "└" },
        modified = { symbol = "" },
        git_status = {
            symbols = {
                added = "", modified = "", deleted = "", renamed = "",
                untracked = "", ignored = "", unstaged = "", staged = "", conflict = "",
            },
        },
    },
    window = {
        width = 32,
        mappings = {
            ["<space>"] = "none",
            ["o"] = "open",
            ["l"] = "open",
            ["h"] = "close_node",
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["P"] = { "toggle_preview", config = { use_float = true } },
        },
    },
    filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            never_show = { ".DS_Store" },
        },
    },
    buffers = { follow_current_file = { enabled = true } },
    git_status = { window = { mappings = { ["A"] = "git_add_all", ["gu"] = "git_unstage_file" } } },
})

-- Auto-open document_symbols on the right for code filetypes (one-shot per buffer)
local ft_list = {
    "python", "java", "cs", "c", "cpp", "rust", "javascript", "javascriptreact",
    "typescript", "typescriptreact", "sh", "lua", "ps1", "go",
}
local group = vim.api.nvim_create_augroup("NeotreeDocumentSymbols", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    callback = function()
        local ft = vim.bo.filetype
        if vim.tbl_contains(ft_list, ft) and not vim.g.neotree_symbols_shown then
            local cur_win = vim.api.nvim_get_current_win()
            pcall(function()
                require("neo-tree.command").execute({
                    source = "document_symbols",
                    position = "right",
                    toggle = false,
                    focus = false,
                })
            end)
            vim.schedule(function()
                if type(cur_win) == "number" and vim.api.nvim_win_is_valid(cur_win) then
                    vim.api.nvim_set_current_win(cur_win)
                end
            end)
            vim.g.neotree_symbols_shown = true
        end
    end,
})
