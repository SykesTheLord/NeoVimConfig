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

" open NERDTree automatically

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree

let g:NERDTreeGitStatusWithFlags = 1

"let g:WebDevIconsUnicodeDecorateFolderNodes = 1

"let g:NERDTreeGitStatusNodeColorization = 1

let NERDTreeShowHidden=1

let g:NERDTreeFileLines = 1

"let g:NERDTreeColorMapCustom = {
    "\ "Staged"    : "#0ee375",  
    "\ "Modified"  : "#d9bf91",  
    "\ "Renamed"   : "#51C9FC",  
    "\ "Untracked" : "#FCE77C",  
    "\ "Unmerged"  : "#FC51E6",  
    "\ "Dirty"     : "#FFBD61",  
    "\ "Clean"     : "#87939A",   
    "\ "Ignored"   : "#808080"   
    "\ }                         

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
       -- "omnisharp-extended-lsp",          -- Added: Extended OmniSharp LSP
        "terraformls",                     -- Terraform
        "dockerls",                        -- Docker (Dockerfiles)
        "bashls",                          -- Shell scripting
        "docker_compose_language_service", -- Docker Compose
        -- "cmake",                           -- CMake
        "jdtls",                           -- Java
        "lua_ls",                          -- Lua
        "marksman",                        -- Markdown
        -- "nginx-language-server",           -- Nginx (if name mismatch, try "nginxls")
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

lspconfig.omnisharp.setup = {
  cmd = { "dotnet", "/home/jasb/omnisharp/OmniSharp.dll" },

  filetypes = { "cs", "vb" }
    settings = {
      FormattingOptions = {
        -- Enables support for reading code style, naming convention and analyzer
        -- settings from .editorconfig.
        EnableEditorConfigSupport = true,
        -- Specifies whether 'using' directives should be grouped and sorted during
        -- document formatting.
        OrganizeImports = nil,
      },
      MsBuild = {
        -- If true, MSBuild project system will only load projects for files that
        -- were opened in the editor. This setting is useful for big C# codebases
        -- and allows for faster initialization of code navigation features only
        -- for projects that are relevant to code that is being edited. With this
        -- setting enabled OmniSharp may load fewer projects and may thus display
        -- incomplete reference lists for symbols.
        LoadProjectsOnDemand = nil,
      },
      RoslynExtensionsOptions = {
        -- Enables support for roslyn analyzers, code fixes and rulesets.
        EnableAnalyzersSupport = nil,
        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        EnableImportCompletion = nil,
        -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        -- true
        AnalyzeOpenDocumentsOnly = nil,
      },
      Sdk = {
        -- Specifies whether to include preview versions of the .NET SDK when
        -- determining which version to use for project loading.
        IncludePrereleases = true,
      },
    },
}

-- Loop through all servers (except clangd which is configured separately) and set them up with default configurations
local servers = {
  "ts_ls",
  "eslint",
  "pyright",
  "jsonls",
  "yamlls",
  "omnisharp",
  -- "omnisharp-extended-lsp",
  "terraformls",
  "dockerls",
  "bashls",
  "docker_compose_language_service",
  -- "cmake",
  "jdtls",
  "lua_ls",
  "marksman",
  -- "nginx-language-server",
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

set mouse=a
set number
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
