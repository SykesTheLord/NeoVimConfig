pcall(vim.cmd.colorscheme, "nordic")

require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count) return "(" .. count .. ")" end,
        offsets = {
            { filetype = "neo-tree", text = "File Explorer", text_align = "center", separator = true },
        },
        show_buffer_close_icons = false,
        show_close_icon = false,
    },
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            vim.cmd("Neotree reveal left")
        end
    end,
})
