require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = { border = "rounded" },
        },
        menu = { border = "rounded" },
        ghost_text = { enabled = true },
        list = { selection = { preselect = false, auto_insert = true } },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    snippets = { preset = "default" },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})
