require("todo-comments").setup({})

local map = vim.keymap.set
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<CR>",              { desc = "TODOs (Trouble)" })
map("n", "<leader>st", "<cmd>TodoTelescope<CR>",                    { desc = "Search TODOs" })
