require("trouble").setup({})

local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",      { desc = "Symbols (Trouble)" })
map("n", "<leader>xS", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP refs/defs/impls" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   { desc = "Quickfix (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                  { desc = "Location List (Trouble)" })
