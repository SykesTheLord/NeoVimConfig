" Plugin setup using vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" LSP and Mason plugins
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" OmniSharp Extended LSP plugin
Plug 'Hoffs/omnisharp-extended-lsp.nvim'

" Autocompletion plugins (nvim-cmp and sources)
Plug 'hrsh7th/nvim-cmp'               " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'           " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'            " Buffer word completion source
Plug 'hrsh7th/cmp-path'              " Filesystem path completion source
Plug 'L3MON4D3/LuaSnip'               " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'        " LuaSnip source for nvim-cmp
Plug 'rafamadriz/friendly-snippets'   " Snippet collection

" Additional useful plugins
Plug 'nvim-lua/plenary.nvim'          " Required by telescope.nvim
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree'
Plug 'mfussenegger/nvim-dap'
Plug 'Mofiqul/dracula.nvim'
Plug 'aquasecurity/vim-trivy'

call plug#end()

" Basic Neovim settings
set number
set relativenumber
syntax on
set mouse=a
set hidden
set cursorline
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set completeopt=menu,menuone,noselect   " Better completion menu behavior
set clipboard=unnamedplus
set encoding=utf-8
set history=5000

colorscheme dracula

" Open NERDTree automatically on Vim start (if no file specified via stdin)
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['^node_modules$']

" ===============================
" Mason, LSP, and Completion Setup
" ===============================
lua <<EOF
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "eslint",
        "pyright",
        "jsonls",
        "yamlls",
        "omnisharp",  -- Removed because OmniSharp Extended plugin handles OmniSharp
        "terraformls",
        "dockerls",
        "bashls",
        "docker_compose_language_service",
        "jdtls",
        "lua_ls",
        "marksman",
        "powershell_es",
        "sqls",
        "vimls",
        "bicep",
        "azure_pipelines_ls",
        "ansiblels",
    },
    automatic_installation = true,
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup LSP servers (except OmniSharp, which uses the extended plugin)
lspconfig.clangd.setup { capabilities = capabilities }
lspconfig.eslint.setup { capabilities = capabilities }
lspconfig.pyright.setup { capabilities = capabilities }
lspconfig.jsonls.setup { capabilities = capabilities }
lspconfig.yamlls.setup { capabilities = capabilities }
lspconfig.terraformls.setup { capabilities = capabilities }
lspconfig.dockerls.setup { capabilities = capabilities }
lspconfig.bashls.setup { capabilities = capabilities }
lspconfig.docker_compose_language_service.setup { capabilities = capabilities }
lspconfig.jdtls.setup { capabilities = capabilities }
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = {"vim"} }
    }
  }
}
lspconfig.marksman.setup { capabilities = capabilities }
lspconfig.powershell_es.setup { capabilities = capabilities }
lspconfig.sqls.setup { capabilities = capabilities }
lspconfig.vimls.setup { capabilities = capabilities }
lspconfig.ansiblels.setup { capabilities = capabilities }
lspconfig.bicep.setup { capabilities = capabilities }
lspconfig.azure_pipelines_ls.setup { capabilities = capabilities }


-- Setup Omnisharp
require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", "/home/jasb/omnisharp/OmniSharp.dll" },

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
        EnableAnalyzersSupport = true,
        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        EnableImportCompletion = true,
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
	capabilities = capabilities,
}



-- Setup nvim-cmp autocompletion
local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"]  = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  })
})
EOF


" ===============================
" Additional Key Mappings
" ===============================
" Terminal mode mapping: allow <Esc> to exit terminal insert mode
tnoremap <Esc> <C-\><C-n>
" Terminal mode mappings: window navigation using Alt+h/j/k/l
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

" Insert mode mappings: window navigation using Alt+h/j/k/l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

" Normal mode mappings: window navigation using Alt+h/j/k/l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Commands for omnisharp-extended
nnoremap gr <cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>
nnoremap gd <cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = "vsplit" })<cr>
nnoremap <leader>D <cmd>lua require('omnisharp_extended').telescope_lsp_type_definition()<cr>
nnoremap gi <cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<cr>
" replaces vim.lsp.buf.definition()
nnoremap gd <cmd>lua require('omnisharp_extended').lsp_definition()<cr>

" replaces vim.lsp.buf.type_definition()
nnoremap <leader>D <cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>

" replaces vim.lsp.buf.references()
nnoremap gr <cmd>lua require('omnisharp_extended').lsp_references()<cr>

" replaces vim.lsp.buf.implementation()
nnoremap gi <cmd>lua require('omnisharp_extended').lsp_implementation()<cr>