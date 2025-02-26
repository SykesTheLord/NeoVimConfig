" Plugin setup using vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" LSP and Mason plugins
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" OmniSharp Extended LSP plugin
Plug 'git@github.com:Hoffs/omnisharp-extended-lsp.nvim'

" Autocompletion plugins (nvim-cmp and sources)
Plug 'hrsh7th/nvim-cmp'               " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'           " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'            " Buffer word completion source
Plug 'hrsh7th/cmp-path'              " Filesystem path completion source
Plug 'L3MON4D3/LuaSnip'              " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'       " LuaSnip source for nvim-cmp
Plug 'rafamadriz/friendly-snippets'  " Snippet collection

" Additional useful plugins
Plug 'nvim-lua/plenary.nvim'         " Required by telescope.nvim
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree'
Plug 'mfussenegger/nvim-dap'
Plug 'Mofiqul/dracula.nvim'

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
		"omnisharp",
        -- Note: OmniSharp will be handled by the extended plugin below
        "terraformls",
        "dockerls",
        "bashls",
        "docker_compose_language_service",
        -- "cmake",        -- example of additional LSP
        "jdtls",
        "lua_ls",
        "marksman",
        -- "nginxls",      -- Nginx LSP (ensure correct name if using)
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

-- Setup OmniSharp Extended LSP
-- This plugin provides extended support for OmniSharp.
require("omnisharp").setup({
  serverOptions = {
    cmd = { "dotnet", "/home/jasb/omnisharp/OmniSharp.dll" },  -- adjust path as needed
  },
  capabilities = capabilities,
  filetypes = { "cs", "vb" },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = nil,
    },
    RoslynExtensionsOptions = {
      EnableImportCompletion = nil,
      AnalyzeOpenDocumentsOnly = nil,
	  enableDecompilationSupport = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
})

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

-- ===============================
-- Additional Key Mappings
-- ===============================
-- Terminal mode mapping: allow <Esc> to exit terminal insert mode
tnoremap <Esc> <C-\><C-n>
-- Terminal mode mappings: window navigation using Alt+h/j/k/l
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

-- Insert mode mappings: window navigation using Alt+h/j/k/l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

-- Normal mode mappings: window navigation using Alt+h/j/k/l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


-- Commands for omnisharp-extended

nnoremap gr <cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>
-- options are supported as well
nnoremap gd <cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = "vsplit" })<cr>
nnoremap <leader>D <cmd>lua require('omnisharp_extended').telescope_lsp_type_definition()<cr>
nnoremap gi <cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<cr>