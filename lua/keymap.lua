local map = vim.keymap.set

-- File explorer
map("n", "<leader>e", ":Neotree toggle<CR>",  { desc = "File Explorer (Neo-tree)", silent = true })
map("n", "<leader>o", ":Neotree reveal<CR>",  { desc = "Reveal current file in Neo-tree", silent = true })

-- Save / quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<C-s>",     "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>",     "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to split below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to split above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Better defaults
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Undotree
map("n", "<leader>u",  function() require("undotree").toggle() end, { desc = "Undotree toggle", silent = true })
map("n", "<leader>uo", function() require("undotree").open() end,   { desc = "Undotree open",   silent = true })
map("n", "<leader>uc", function() require("undotree").close() end,  { desc = "Undotree close",  silent = true })

-- Diagnostics
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1,  float = true }) end, { desc = "Next diagnostic" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Markdown preview
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown preview toggle" })
