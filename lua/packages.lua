-- All plugins declared via vim.pack (Neovim 0.12 built-in package manager).
-- Run :lua vim.pack.update() to update.
-- First install: :TSUpdate for treesitter parsers.

local plugins = {
    { src = "https://github.com/AlexvZyl/nordic.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
    { src = "https://github.com/s1n7ax/nvim-window-picker" },
    { src = "https://github.com/antosha417/nvim-lsp-file-operations" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "https://github.com/RaafatTurki/corn.nvim" },
    { src = "https://github.com/Decodetalkers/csharpls-extended-lsp.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/Weissle/persistent-breakpoints.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/mfussenegger/nvim-lint" },
    { src = "https://github.com/aquasecurity/vim-trivy" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/catgoose/nvim-colorizer.lua" },
    { src = "https://github.com/iamcco/markdown-preview.nvim" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/jiaoshijie/undotree" },
    { src = "https://github.com/hiphish/rainbow-delimiters.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/folke/trouble.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
}

vim.pack.add(plugins)

for _, p in ipairs(plugins) do
    local name = p.name or vim.fs.basename(p.src)
    pcall(vim.cmd.packadd, name)
end

-- Build blink.cmp's rust fuzzy matcher on install/update.
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(args)
        local d = args.data
        if d and d.spec and d.spec.name == "blink.cmp" and (d.kind == "install" or d.kind == "update") then
            local ok, blink = pcall(require, "blink.cmp")
            if ok and blink.build then
                vim.notify("Building blink.cmp...", vim.log.levels.INFO)
                blink.build():wait(60000)
            end
        end
    end,
})

-- First-run build: build blink.cmp's rust matcher if the shared library isn't present yet.
do
    local lib_dir = vim.fn.stdpath("data") .. "/site/lib"
    local has_lib = false
    local fd = vim.uv.fs_scandir(lib_dir)
    while fd do
        local name = vim.uv.fs_scandir_next(fd)
        if not name then break end
        if name:match("^libblink_cmp_fuzzy") then has_lib = true; break end
    end
    if not has_lib and vim.uv.fs_stat(vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp") then
        vim.schedule(function()
            local ok, blink = pcall(require, "blink.cmp")
            if ok and blink.build then
                vim.notify("Building blink.cmp (first run)...", vim.log.levels.INFO)
                blink.build():wait(60000)
            end
        end)
    end
end
