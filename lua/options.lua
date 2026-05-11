local o = vim.opt

o.number = true
o.relativenumber = false
o.wrap = false
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.incsearch = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.termguicolors = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 6
o.sidescrolloff = 8
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.completeopt = { "menu", "menuone", "noselect", "noinsert" }
o.fillchars = { eob = " " }
o.list = true
o.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
o.confirm = true
o.laststatus = 3
o.winborder = "rounded"

vim.g.markdown_recommended_style = 0

vim.diagnostic.config({
    virtual_text = false, -- corn.nvim renders these
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "󰌵",
        },
    },
    severity_sort = true,
    update_in_insert = false,
    float = { border = "rounded", source = true },
})
