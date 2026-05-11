-- Rainbow delimiters
require("rainbow-delimiters.setup").setup({})

-- Autopairs
require("nvim-autopairs").setup({ check_ts = true })

-- Inline colour codes
require("colorizer").setup({
    user_default_options = { names = false, css = true, xterm = true },
})
