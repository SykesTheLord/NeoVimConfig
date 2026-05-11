require("which-key").setup({
    preset = "modern",
    win = { border = "rounded" },
})

require("which-key").add({
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>h", group = "hunks" },
    { "<leader>s", group = "search" },
    { "<leader>u", group = "ui toggles" },
    { "<leader>x", group = "diagnostics/trouble" },
    { "<leader>d", group = "debug" },
    { "<leader>c", group = "code" },
    { "<leader>m", group = "markdown" },
})

-- markdown-preview defaults (set before plugin loads ideally — safe here for runtime use)
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"
