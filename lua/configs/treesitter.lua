-- nvim-treesitter v1 (Neovim 0.12+): highlight/indent are native;
-- only parser install + textobjects + context need explicit setup.

vim.schedule(function()
    pcall(function()
        require("nvim-treesitter.install").install({
            "bash", "bicep", "c", "cmake", "cpp", "c_sharp", "diff", "dockerfile",
            "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
            "hcl", "html", "java", "javascript", "jsdoc", "json",
            "lua", "luadoc", "luap", "markdown", "markdown_inline", "powershell",
            "printf", "python", "query", "regex", "rust", "sql", "terraform",
            "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
        })
    end)
end)

require("treesitter-context").setup({ mode = "cursor", max_lines = 3 })

-- Highlight + indent for any installed parser
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if lang and pcall(vim.treesitter.start, buf, lang) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- treesitter-textobjects v1 (loaded as nvim-treesitter module)
pcall(function()
    require("nvim-treesitter.configs").setup({
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer", ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
                    ["aa"] = "@parameter.outer",["ia"] = "@parameter.inner",
                    ["al"] = "@loop.outer",     ["il"] = "@loop.inner",
                    ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start     = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
                goto_next_end       = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
                goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
                goto_previous_end   = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
            },
        },
    })
end)
