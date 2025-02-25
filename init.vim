" Begin plugin block
call plug#begin('~/.local/share/nvim/plugged')

" Mason and LSP configuration plugins
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Additional useful plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

" Basic Neovim settings
set number
syntax on

" Mason and native LSP setup via Lua
lua <<EOF
-- Initialize Mason and ensure installation of LSP servers
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",                          -- C/C++/ObjC
        "tsserver",                        -- JavaScript/TypeScript
        "eslint",                          -- Linting for JS/TS
        "pyright",                         -- Python
        "jsonls",                          -- JSON
        "yamlls",                          -- YAML
        "omnisharp",                       -- C#/.NET
        "omnisharp-extended-lsp",          -- Added: Extended OmniSharp LSP
        "terraformls",                     -- Terraform
        "dockerls",                        -- Docker (Dockerfiles)
        "bashls",                          -- Shell scripting
        "docker_compose_language_service", -- Docker Compose
        "cmake",                           -- CMake
        "jdtls",                           -- Java
        "lua_ls",                          -- Lua
        "marksman",                        -- Markdown
        "nginx-language-server",           -- Nginx (if name mismatch, try "nginxls")
        "powershell_es",                   -- Powershell
        "sqls",                            -- SQL
        "vimls",                           -- VIMscript
        "bicep",                           -- Bicep
        "azure_pipelines_ls",              -- Azure Pipelines
        "ansiblels",                       -- Ansible
    },
    automatic_installation = true,
})

local lspconfig = require('lspconfig')

-- Custom configuration for clangd (example for C/C++/ObjC)
lspconfig.clangd.setup {
  cmd = {"clangd"},
  filetypes = {"c", "cc", "cpp", "c++", "objc", "objcpp"},
  root_dir = lspconfig.util.root_pattern("compile_flags.txt", "compile_commands.json")
}

-- Loop through all servers (except clangd which is configured separately) and set them up with default configurations
local servers = {
  "tsserver",
  "eslint",
  "pyright",
  "jsonls",
  "yamlls",
  "omnisharp",
  "omnisharp-extended-lsp",
  "terraformls",
  "dockerls",
  "bashls",
  "docker_compose_language_service",
  "cmake",
  "jdtls",
  "lua_ls",
  "marksman",
  "nginx-language-server",
  "powershell_es",
  "sqls",
  "vimls",
  "bicep",
  "azure_pipelines_ls",
  "ansiblels",
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {}
end
EOF
