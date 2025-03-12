" Neovim 0.10.4 init.vim - Updated for WSL environment

" ========== Plugin Installation (vim-plug) ==========
call plug#begin('~/.local/share/nvim/plugged')
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
" Plug 'Hoffs/omnisharp-extended-lsp.nvim'       C# LSP extensions
Plug 'hrsh7th/nvim-cmp'                       " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'                   " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'                     " Buffer words source
Plug 'hrsh7th/cmp-path'                       " Filesystem paths source
Plug 'hrsh7th/cmp-cmdline'                    " Vim command-line source
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}                      " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'               " Snippet source for nvim-cmp
Plug 'rafamadriz/friendly-snippets'           " Predefined snippet sets
Plug 'ray-x/cmp-sql'                          " SQL completion source
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'    " Signature help source
Plug 'nvim-lua/plenary.nvim'                  " Lua utilities (required by Telescope)
Plug 'nvim-telescope/telescope.nvim'          " Fuzzy finder
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Treesitter syntax
Plug 'preservim/nerdtree'                     " File tree explorer
Plug 'mfussenegger/nvim-dap'                  " Debug Adapter Protocol
Plug 'Mofiqul/dracula.nvim'                   " Colorscheme
Plug 'aquasecurity/vim-trivy'                 " Trivy integration
Plug 'lewis6991/gitsigns.nvim'                " Git change signs
Plug 'nvim-treesitter/nvim-treesitter-context' " Show code context at top
Plug 'hiphish/rainbow-delimiters.nvim'        " Rainbow brackets
Plug 'ryanoasis/vim-devicons'
Plug 'Decodetalkers/csharpls-extended-lsp.nvim' 
call plug#end()

" ========== Basic Settings ==========
set number              " Show line numbers
set relativenumber      " Relative line numbers
syntax on               " Enable syntax highlighting
" set guifont=CaskaydiaCove\ Nerd\ Font 11
set mouse=a             " Enable mouse support
set hidden              " Allow unsaved buffers in background
set cursorline          " Highlight current line
set expandtab           " Use spaces instead of tabs
set tabstop=4           " 1 tab = 4 spaces
set shiftwidth=4        " Indent by 4 spaces
set autoindent          " Copy indent from current line on newline
set smartindent         " Smarter autoindent for new lines
set completeopt=menu,menuone,noselect  " Better completion menu
set clipboard=unnamedplus            " Use system clipboard by default
set encoding=utf-8      " Ensure UTF-8 encoding
set history=5000        " Increase command history size
filetype plugin indent on  " Enable filetype-specific plugins & indent

colorscheme dracula     " Set colorscheme (requires dracula.nvim)

" ========== LSP, Mason, and Completion Setup ==========
lua <<EOF
-- Mason Package Manager setup
require("mason").setup()

-- Mason-LSPconfig integration (automatic LSP installation)
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "eslint",
        "pyright",
        "jsonls",
        "yamlls",
        -- "omnisharp", -- (Handled separately below)
        "terraformls",
        "dockerls",
        "bashls",
        "docker_compose_language_service",
        "jdtls",
        "lua_ls",
        "marksman",
        "powershell_es",
        "cmake",
        "vimls",
        "bicep",
        "sqls",
        "csharp_ls"
    },
    automatic_installation = true,
})

-- Setup snippets


local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

require("luasnip.loaders.from_vscode").lazy_load()

local lspconfig = require("lspconfig")

-- Define a custom function to determine project root using common markers.
local lsp_util = require("lspconfig.util")
local function get_project_root()
  return lsp_util.root_pattern(".git", "package.json", "pyproject.toml", "setup.py")(vim.fn.expand("%:p")) or vim.fn.getcwd()
end

-- nvim-cmp (completion) setup
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()  -- load VSCode-style snippets

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, vim_item)
      local icons = {
        Text = "",
        Method = "",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = ""
      }
      vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        sql = "[SQL]",
        nvim_lsp_signature_help = "[Signature]",
      })[entry.source.name] or ""
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
    ["<Tab>"]     = cmp.mapping(function(fallback)
                      if cmp.visible() then
                        cmp.select_next_item()
                      elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                      else
                        fallback()
                      end
                    end, {"i", "s"}),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
                      if cmp.visible() then
                        cmp.select_prev_item()
                      elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                      else
                        fallback()
                      end
                    end, {"i", "s"}),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path", option = { get_cwd = get_project_root } },
    { name = "sql" },
    { name = "nvim_lsp_signature_help" }
  })
})

-- Setup command-line (:) completion for NeoVim commands.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", option = { get_cwd = get_project_root } }
  }, {
    { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } }
  })
})


local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Set up LSP servers with basic capabilities (OmniSharp configured separately)
require'lspconfig'.clangd.setup { capabilities = capabilities }
require'lspconfig'.eslint.setup { capabilities = capabilities }
require'lspconfig'.pyright.setup { capabilities = capabilities }
require'lspconfig'.jsonls.setup { capabilities = capabilities }
require'lspconfig'.dockerls.setup { capabilities = capabilities }
require'lspconfig'.bashls.setup { capabilities = capabilities }
require'lspconfig'.docker_compose_language_service.setup { capabilities = capabilities }
require'lspconfig'.jdtls.setup { capabilities = capabilities }
require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    settings = { Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = {"vim"} }
    }}
}
require'lspconfig'.marksman.setup { capabilities = capabilities }
require'lspconfig'.powershell_es.setup { capabilities = capabilities }
require'lspconfig'.terraformls.setup { capabilities = capabilities }
require'lspconfig'.sqls.setup { capabilities = capabilities }
require'lspconfig'.vimls.setup { capabilities = capabilities }
require'lspconfig'.bicep.setup { capabilities = capabilities }
require'lspconfig'.yamlls.setup {
    capabilities = capabilities,
    filetypes = { "yaml", "yml" },
    root_dir = function() return vim.loop.cwd() end,
    settings = {
      yaml = {
        validate = true,
        schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
        schemas = { ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines.yaml" }
      }
    }
}

require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", vim.fn.expand("~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll") },
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = nil,
      },
      MsBuild = {
        LoadProjectsOnDemand = nil,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        AnalyzeOpenDocumentsOnly = nil,
      },
      Sdk = {
        IncludePrereleases = true,
      },
    },
    capabilities = capabilities,
}


local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"

local config = {
  handlers = {
    ["textDocument/definition"] = require('csharpls_extended').handler,
    ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
  },
  cmd = { "csharp-ls" },
  -- rest of your settings
  capabilities = capabilities,
}

require'lspconfig'.csharp_ls.setup(config)

-- Clipboard integration for WSL/Wayland/X11
if vim.fn.has("wsl") == 1 then
  -- WSL: Use win32yank.exe to access Windows clipboard
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
elseif vim.env.XDG_SESSION_TYPE == "wayland" or vim.env.WAYLAND_DISPLAY then
  -- Wayland: use wl-copy/wl-paste
  vim.g.clipboard = {
    name = "wayland",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 0,
  }
else
  -- X11: use xclip as fallback
  vim.g.clipboard = {
    name = "x11",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o",
    },
    cache_enabled = 0,
  }
end

-- Gitsigns setup (show git diff in sign column)
require("gitsigns").setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
  },
}

-- Telescope setup (with binary file preview filtering)
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file", args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

require("telescope").setup {
  defaults = {
    buffer_previewer_maker = new_maker,
    preview = {
      -- Display images with `catimg` if the file is an image
      mime_hook = function(filepath, bufnr, opts)
        local function is_image(path)
          local ext = string.match(path:lower(), "%.([^%.]+)$")
          local image_exts = { png=true, jpg=true, jpeg=true }
          return ext and image_exts[ext]
        end
        if is_image(filepath) then
          local term = vim.api.nvim_open_term(bufnr, {})
          vim.fn.jobstart({ "catimg", filepath }, {
            on_stdout = function(_, data)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d.."\r\n")
              end
            end,
            stdout_buffered = true, pty = true
          })
        else
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
      end
    }
  }
}
require("telescope").load_extension("csharpls_definition")
-- Rainbow Delimiters (colored brackets) configuration
local rainbow_delimiters = require("rainbow-delimiters")
vim.g.rainbow_delimiters = {
  strategy = {
    ['']  = rainbow_delimiters.strategy["global"],
    vim   = rainbow_delimiters.strategy["local"],
  },
  query = {
    ['']  = 'rainbow-delimiters',
    lua   = 'rainbow-blocks',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}
EOF

" ========== NERDTree Auto-open on Startup ==========
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
let g:NERDTreeShowHidden=1                   " Show hidden files"
let g:NERDTreeIgnore=['^node_modules$']      " Ignore node_modules folders"
let g:NERDTreeFileLines = 1                   " Show number of lines in file"

" ========== Setup Vim-Devicons ============
" change the default dictionary mappings for file extension matches
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} 
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cs'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tf'] = ''

let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {} 
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['.envrc'] = '󰒓'

" ========== Key Mappings ==========
" Terminal mode mapping: allow <Esc> to exit terminal insert mode
tnoremap <Esc> <C-\><C-n>
" Window navigation with Alt+h/j/k/l (works in terminal if Alt is not trapped)
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Leader key set to '-'
let mapleader = "-"


" Telescope fuzzy-finder shortcuts
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>

