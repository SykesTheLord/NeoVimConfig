" Begin plugin block
call plug#begin('~/.local/share/nvim/plugged')

" Mason and LSP configuration plugins
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Additional useful plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'
Plug 'preservim/nerdtree'
Plug 'mfussenegger/nvim-dap'

call plug#end()

" Basic Neovim settings
set number
syntax on
set mouse=a
set hidden
set cursorline
set expandtab
set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set encoding=utf8
set history=5000
set clipboard=unnamedplus

" Open NERDTree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree

let g:NERDTreeGitStatusWithFlags = 1

"let g:WebDevIconsUnicodeDecorateFolderNodes = 1

"let g:NERDTreeGitStatusNodeColorization = 1

let NERDTreeShowHidden=1
let g:NERDTreeFileLines = 1

"let g:NERDTreeColorMapCustom = {
"    "\ "Staged"    : "#0ee375",  
"    "\ "Modified"  : "#d9bf91",  
"    "\ "Renamed"   : "#51C9FC",  
"    "\ "Untracked" : "#FCE77C",  
"    "\ "Unmerged"  : "#FC51E6",  
"    "\ "Dirty"     : "#FFBD61",  
"    "\ "Clean"     : "#87939A",   
"    "\ "Ignored"   : "#808080"   
"    "\ }                         

let g:NERDTreeIgnore = ['^node_modules$']

" Mason and native LSP setup via Lua
lua <<EOF
-- Initialize Mason and ensure installation of LSP servers
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",                          -- C/C++/ObjC
        "ts_ls",                           -- JavaScript/TypeScript
        "eslint",                          -- Linting for JS/TS
        "pyright",                         -- Python
        "jsonls",                          -- JSON
        "yamlls",                          -- YAML
        "omnisharp",                       -- C#/.NET
       -- "omnisharp-extended-lsp",         -- Added: Extended OmniSharp LSP
        "terraformls",                     -- Terraform
        "dockerls",                        -- Docker (Dockerfiles)
        "bashls",                          -- Shell scripting
        "docker_compose_language_service", -- Docker Compose
        -- "cmake",                        -- CMake
        "jdtls",                           -- Java
        "lua_ls",                          -- Lua
        "marksman",                        -- Markdown
        -- "nginx-language-server",         -- Nginx (if name mismatch, try "nginxls")
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

-- Corrected OmniSharp configuration
lspconfig.omnisharp.setup {
  cmd = { "dotnet", "/home/jasb/omnisharp/OmniSharp.dll" },
  filetypes = { "cs", "vb" },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = nil,
    },
    MsBuild = {
      LoadProjectsOnDemand = nil,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = nil,
      EnableImportCompletion = nil,
      AnalyzeOpenDocumentsOnly = nil,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
}

lspconfig.ts_ls.setup {}
lspconfig.eslint.setup {}
lspconfig.pyright.setup {}
lspconfig.jsonls.setup {}
lspconfig.yamlls.setup {}
lspconfig.terraformls.setup {}
lspconfig.dockerls.setup {}
lspconfig.bashls.setup {}
lspconfig.docker_compose_language_service.setup {}
lspconfig.jdtls.setup {}
lspconfig.lua_ls.setup {}
lspconfig.marksman.setup {}
lspconfig.powershell_es.setup {}
lspconfig.sqls.setup {}
lspconfig.vimls.setup {}
lspconfig.ansiblels.setup {}
lspconfig.bicep.setup {}
lspconfig.azure_pipelines_ls.setup {}

EOF

