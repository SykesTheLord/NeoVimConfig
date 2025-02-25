" Initialize plugin system
call plug#begin('~/.local/share/nvim/plugged')

" General plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Language-specific plugins
" C++, C
Plug 'dense-analysis/ale'
Plug 'rhysd/vim-clang-format'

" C#
Plug 'OmniSharp/omnisharp-vim'

" Python
Plug 'davidhalter/jedi-vim'
Plug 'psf/black', { 'do': ':update' }

" Terraform
Plug 'hashivim/vim-terraform'

" PowerShell
Plug 'PProvost/vim-ps1'

" Bash
Plug 'tpope/vim-eunuch'

" Docker
Plug 'ekalinin/dockerfile.vim'

" Kubernetes
Plug 'andrewstuart/vim-kubernetes'

" Initialize plugin system
call plug#end()

" General settings
syntax enable
filetype plugin indent on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set incsearch
set hlsearch
set ignorecase
set smartcase
set hidden
set clipboard=unnamedplus
set completeopt=menuone,noinsert,noselect

" COC settings
let g:coc_global_extensions = [
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-python',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-clangd',
      \ 'coc-omnisharp',
      \ 'coc-terraform',
      \ 'coc-docker',
      \ 'coc-sh'
      \ ]

" ALE settings
let g:ale_linters = {
      \ 'c': ['clang'],
      \ 'cpp': ['clang'],
      \ 'python': ['flake8'],
      \ 'sh': ['shellcheck'],
      \ 'terraform': ['terraform'],
      \ }
let g:ale_fixers = {
      \ 'c': ['clang-format'],
      \ 'cpp': ['clang-format'],
      \ 'python': ['black'],
      \ 'sh': ['shfmt'],
      \ }
let g:ale_fix_on_save = 1

" Treesitter settings
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "rust",
    "tsx",
    "typescript",
    "vim",
    "yaml",
    "terraform",
    "go",
    "java",
    "kotlin",
    "scala",
    "ruby",
    "php",
    "perl",
    "haskell",
    "elixir",
    "erlang",
    "solidity",
    "graphql",
    "sql",
    "make",
    "cmake",
    "proto",
    "regex",
    "toml",
    "xml",
    "http",
    "gitignore",
    "gitattributes",
    "gitcommit",
    "diff",
    "dot",
    "hcl",
    "ini",
    "meson",
    "ninja",
    "nix",
    "rst",
    "ssh_config",
    "todotxt",
    "vimdoc"
  },
  highlight = {
    enable = true,
  },
}
EOF

" Lualine settings
lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
  },
}
EOF

" Telescope settings
lua << EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = {"truncate"},
    winblend = 0,
    border = {},
    borderchars = {'|', '|', '-', '-', '+', '+', '+', '+'},
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
EOF

" Key mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Format on save
autocmd BufWritePre *.c,*.cpp,*.h,*.hpp,*.py,*.sh lua vim.lsp.buf.formatting_sync()
