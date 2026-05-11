-- Leader keys must be set before plugins are loaded
vim.g.mapleader = "-"
vim.g.maplocalleader = "_"

require("packages")
require("options")

require("configs.snacks")
require("configs.treesitter")
require("configs.mason")
require("configs.blink")
require("configs.lsp")
require("configs.conform")
require("configs.lint")
require("configs.dap")
require("configs.git")
require("configs.statusline")
require("configs.ts-misc")
require("configs.trouble")
require("configs.todo")
require("configs.neotree")
require("configs.corn")
require("configs.misc")

require("keymap")
require("ui")
require("workarounds")
