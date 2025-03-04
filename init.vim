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
Plug 'hrsh7th/cmp-cmdline'           " nvim-cmp source for vim's cmdline.
Plug 'L3MON4D3/LuaSnip'               " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'        " LuaSnip source for nvim-cmp
Plug 'rafamadriz/friendly-snippets'   " Snippet collection
Plug 'ray-x/cmp-sql' " nvim-cmp source for sql keywords.
Plug 'hrsh7th/cmp-nvim-lsp-signature-help' " nvim-cmp source for displaying function signatures with the current parameter emphasized

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
        "cmake",
        "vimls",
        "bicep",
		"sqls",
    },
    automatic_installation = true,
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")

-- Setup LSP servers (except OmniSharp, which uses the extended plugin)
lspconfig.clangd.setup { capabilities = capabilities }
lspconfig.eslint.setup { capabilities = capabilities }
lspconfig.pyright.setup { capabilities = capabilities }
lspconfig.jsonls.setup { capabilities = capabilities }
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
lspconfig.terraformls.setup { capabilities = capabilities }
lspconfig.sqls.setup { capabilities = capabilities }
lspconfig.vimls.setup { capabilities = capabilities }
lspconfig.bicep.setup { capabilities = capabilities }
lspconfig.yamlls.setup({
  capabilities = capabilities,
  filetypes = { "yaml", "yml" },
  root_dir = function(fname)
    return vim.loop.cwd()
  end,
  settings = {
    yaml = {
      validate = true,
      schemaStore = {
        enable = true, -- use schemastore for automatic schema resolution
        url = "https://www.schemastore.org/api/json/catalog.json"
      },
      -- Map the Azure Pipelines schema to azure-pipelines.yaml files
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines.yaml"
      }
    }
  }
})

-- Setup Treesitter
require("nvim-treesitter.install").prefer_git = true
require('nvim-treesitter.configs').setup {
  highlight = { 
	enable = true, 
	additional_vim_regex_highlighting = false,
  },
  ensure_installed = { "bash", "c", "cpp", "lua", "python", "yaml", "javascript", "dockerfile", "c_sharp", "java", "json", "markdown_inline", "sql", "terraform", "vim", "vimdoc" },
  -- ... any other modules
}


-- Setup Omnisharp
require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", vim.fn.expand("~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll") },

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
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
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
    { name = "sql" },
    { name = "nvim_lsp_signature_help" },
    
  })
  
})
cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }
          }
        }
      })
    })

-- Setup clipboard handling
if vim.fn.has("wsl") == 1 then
  -- WSL: Use win32yank for clipboard operations
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf"
    },
    cache_enabled = 0,
  }
elseif vim.env.XDG_SESSION_TYPE == "wayland" or vim.env.WAYLAND_DISPLAY then
  -- Wayland: Use wl-copy and wl-paste
  vim.g.clipboard = {
    name = "wayland",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy"
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste"
    },
    cache_enabled = 0,
  }
else
  -- Fallback for X11: Use xclip
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



 -- Setup Telescope
local pickers = require("telescope.pickers")
local conf = require('telescope.config').values
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local Job = require("plenary.job")

-- Do not preview binaries
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end


-- Actual Telescope setup
require('telescope').setup{
  defaults = {
    buffer_previewer_maker = new_maker,
    preview = { -- Preview images
      mime_hook = function(filepath, bufnr, opts)
        local is_image = function(filepath)
          local image_extensions = {'png','jpg'}   -- Supported image formats
          local split_path = vim.split(filepath:lower(), '.', {plain=true})
          local extension = split_path[#split_path]
          return vim.tbl_contains(image_extensions, extension)
        end
        if is_image(filepath) then
          local term = vim.api.nvim_open_term(bufnr, {})
          local function send_output(_, data, _ )
            for _, d in ipairs(data) do
              vim.api.nvim_chan_send(term, d..'\r\n')
            end
          end
          vim.fn.jobstart(
            {
              'catimg', filepath  -- Terminal image viewer command
            }, 
            {on_stdout=send_output, stdout_buffered=true, pty=true})
        else
          require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
        end
      end
    },
      -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
      find_files = {
      mappings = {
        n = {
          ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            actions.close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("silent lcd %s", dir))
          end
        }
      },
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
-- Implement YAML support to Telescope
local function visit_yaml_node(node, name, yaml_path, result, file_path, bufnr)
    local key = ''
    if node:type() == "block_mapping_pair" then
        local field_key = node:field("key")[1]
        key = vim.treesitter.query.get_node_text(field_key, bufnr)
    end

    if key ~= nil and string.len(key) > 0 then
        table.insert(yaml_path, key)
        local line, col = node:start()
        table.insert(result, {
            lnum = line + 1,
            col = col + 1,
            bufnr = bufnr,
            filename = file_path,
            text = table.concat(yaml_path, '.'),
        })
    end

    for node, name in node:iter_children() do
        visit_yaml_node(node, name, yaml_path, result, file_path, bufnr)
    end

    if key ~= nil and string.len(key) > 0 then
        table.remove(yaml_path, table.maxn(yaml_path))
    end
end

local function gen_from_yaml_nodes(opts)
    local displayer = entry_display.create {
        separator = " │ ",
        items = {
            { width = 5 },
            { remaining = true },
        },
    }

    local make_display = function(entry)
        return displayer {
            { entry.lnum, "TelescopeResultsSpecialComment" },
            { entry.text, function() return {} end },
        }
    end

    return function(entry)
        return make_entry.set_default_entry_mt({
            ordinal = entry.text,
            display = make_display,
            filename = entry.filename,
            lnum = entry.lnum,
            text = entry.text,
            col = entry.col,
        }, opts)
    end
end

local yaml_symbols = function(opts)
    local yaml_path = {}
    local result = {}
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
    local tree = vim.treesitter.get_parser(bufnr, ft):parse()[1]
    local file_path = vim.api.nvim_buf_get_name(bufnr)
    local root = tree:root()
    for node, name in root:iter_children() do
        visit_yaml_node(node, name, yaml_path, result, file_path, bufnr)
    end

  -- return result
  pickers.new(opts, {
      prompt_title = "YAML symbols",
      finder = finders.new_table {
          results = result,
          entry_maker = opts.entry_maker or gen_from_yaml_nodes(opts),
      },
      sorter = conf.generic_sorter(opts),
      previewer = conf.grep_previewer(opts),
  })
  :find()
end

EOF


" =============================== "
" Additional Key Mappings "
" ==============================="
" Terminal mode mapping: allow <Esc> to exit terminal insert mode"
tnoremap <Esc> <C-\><C-n>
" Terminal mode mappings: window navigation using Alt+h/j/k/l "
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

" Insert mode mappings: window navigation using Alt+h/j/k/l "
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

" Normal mode mappings: window navigation using Alt+h/j/k/l"
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Commands for omnisharp-extended (Telescope-based)
nnoremap gr <cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>
nnoremap gd <cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = "vsplit" })<cr>
nnoremap <leader>D <cmd>lua require('omnisharp_extended').telescope_lsp_type_definition()<cr>
nnoremap gi <cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<cr>

" Find files using Telescope command-line sugar."
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
