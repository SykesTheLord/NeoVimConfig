-- Capabilities from blink.cmp so servers advertise completion features (snippets, additionalTextEdits, etc.)
local capabilities
do
    local ok, blink = pcall(require, "blink.cmp")
    if ok and blink.get_lsp_capabilities then
        capabilities = blink.get_lsp_capabilities()
    else
        capabilities = vim.lsp.protocol.make_client_capabilities()
    end
end

local function on_attach(client, bufnr)
    local bufmap = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
    end

    bufmap("n", "K",          vim.lsp.buf.hover,           "Hover Documentation")
    bufmap("n", "gd",         vim.lsp.buf.definition,      "Go to Definition")
    bufmap("n", "gD",         vim.lsp.buf.declaration,     "Go to Declaration")
    bufmap("n", "gi",         vim.lsp.buf.implementation,  "Go to Implementation")
    bufmap("n", "<leader>rn", vim.lsp.buf.rename,          "Rename Symbol")
    bufmap("n", "<leader>ca", vim.lsp.buf.code_action,     "Code Action")
    bufmap("v", "<leader>ca", vim.lsp.buf.code_action,     "Code Action")
    bufmap("n", "<leader>e",  vim.diagnostic.open_float,   "Show Diagnostics")
    bufmap("n", "<leader>ld", vim.diagnostic.setloclist,   "Diagnostics to LocList")
    bufmap("n", "<C-k>",      vim.lsp.buf.signature_help,  "Signature Help")

    if client and client.supports_method and client.supports_method("textDocument/inlayHint") then
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end

    -- Document highlight on cursor hold
    if client and client.supports_method and client.supports_method("textDocument/documentHighlight") then
        local hl_group = vim.api.nvim_create_augroup("LspDocHL." .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = hl_group, buffer = bufnr, callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = hl_group, buffer = bufnr, callback = vim.lsp.buf.clear_references,
        })
    end
end

local function is_win()
    return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

local function mason_bin(exe)
    local suffix = is_win() and ".cmd" or ""
    local path = vim.fn.stdpath("data") .. "/mason/bin/" .. exe .. suffix
    if vim.fn.executable(path) == 1 then
        return path
    end
    return exe
end

local function calc_root(bufnr, markers)
    local function try_root(marker_group)
        local group = marker_group
        if type(marker_group) == "string" then
            group = { marker_group }
        end
        return vim.fs.root(bufnr, group)
    end

    if type(markers) == "table" then
        for _, m in ipairs(markers) do
            local root = try_root(m)
            if root then return root end
        end
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then return vim.fn.getcwd() end
    return vim.fs.dirname(name)
end

local function root_dir_fn(markers)
    return function(bufnr, on_dir)
        on_dir(calc_root(bufnr, markers))
    end
end

local servers = {
    clangd = {
        cmd = { mason_bin("clangd") },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = { "compile_commands.json", "compile_flags.txt", ".git", "CMakeLists.txt", "meson.build" },
    },

    ts_ls = {
        cmd = { mason_bin("typescript-language-server"), "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    },

    eslint = {
        cmd = { mason_bin("vscode-eslint-language-server"), "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        root_markers = {
            { ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml" },
            "package.json",
            ".git",
        },
    },

    jedi_language_server = {
        cmd = { mason_bin("jedi-language-server") },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    },

    jsonls = {
        cmd = { mason_bin("vscode-json-language-server"), "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },
    },

    yamlls = {
        cmd = { mason_bin("yaml-language-server"), "--stdio" },
        filetypes = { "yaml", "yaml.ansible" },
        root_markers = { ".git" },
        settings = {
            yaml = {
                schemaStore = {
                    enable = false,
                    url = "https://www.schemastore.org/api/json/catalog.json",
                },
                schemas = {
                    kubernetes = "*.yaml",
                    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                    ["http://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                    ["http://json.schemastore.org/circleciconfig"] = ".circleci/config.yml",
                },
                format = { enable = true },
                validate = true,
                completion = true,
            },
        },
    },

    terraformls = {
        cmd = { mason_bin("terraform-ls"), "serve" },
        filetypes = { "terraform", "terraform-vars" },
        root_markers = { ".terraform", ".git", ".terraform.lock.hcl" },
    },

    dockerls = {
        cmd = { mason_bin("docker-langserver"), "--stdio" },
        filetypes = { "dockerfile" },
        root_markers = { ".git" },
    },

    docker_compose_language_service = {
        cmd = { mason_bin("docker-compose-langserver"), "--stdio" },
        filetypes = { "yaml.docker-compose" },
        root_markers = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml", ".git" },
    },

    bashls = {
        cmd = { mason_bin("bash-language-server"), "start" },
        filetypes = { "sh", "bash", "zsh" },
        root_markers = { ".git" },
    },

    jdtls = {
        cmd = { mason_bin("jdtls") },
        filetypes = { "java" },
        root_markers = {
            ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle",
            "build.gradle.kts", "settings.gradle.kts",
        },
    },

    lua_ls = {
        cmd = { mason_bin("lua-language-server") },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".lua-version", "stylua.toml", ".git" },
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim", "Snacks" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
                hint = { enable = true },
            },
        },
    },

    marksman = {
        cmd = { mason_bin("marksman"), "server" },
        filetypes = { "markdown" },
        root_markers = { ".git" },
    },

    cmake = {
        cmd = { mason_bin("cmake-language-server") },
        filetypes = { "cmake" },
        root_markers = { "CMakeLists.txt", ".git" },
    },

    vimls = {
        cmd = { mason_bin("vim-language-server"), "--stdio" },
        filetypes = { "vim" },
        root_markers = { ".git" },
    },

    sqls = {
        cmd = { mason_bin("sqls") },
        filetypes = { "sql", "mysql", "plsql" },
        root_markers = { ".git" },
    },

    rust_analyzer = {
        cmd = { mason_bin("rust-analyzer") },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", ".git" },
    },

    csharp_ls = {
        cmd = { mason_bin("csharp-ls") },
        filetypes = { "cs" },
        root_markers = { ".git", "global.json", "Directory.Build.props", "Directory.Build.targets", "NuGet.config" },
        handlers = (function()
            local ok, ext = pcall(require, "csharpls_extended")
            if not ok then return nil end
            return {
                ["textDocument/definition"] = ext.handler,
                ["textDocument/typeDefinition"] = ext.handler,
            }
        end)(),
    },

    bicep = {
        cmd = { mason_bin("bicep-lsp") },
        filetypes = { "bicep" },
        root_markers = { ".git" },
    },

    powershell_es = (function()
        local bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
        local start_script = bundle_path .. "/PowerShellEditorServices/Start-EditorServices.ps1"
        local pwsh = (vim.fn.executable("pwsh") == 1 and "pwsh") or "powershell"
        if vim.uv.fs_stat(start_script) == nil then return nil end
        return {
            cmd = {
                pwsh, "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass",
                "-File", start_script, "-Stdio",
            },
            filetypes = { "ps1", "psm1", "psd1" },
            root_markers = { ".git" },
        }
    end)(),
}

-- Make docker-compose files get the right filetype so the docker-compose LSP can attach.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "docker-compose*.yml", "docker-compose*.yaml", "compose*.yml", "compose*.yaml" },
    callback = function(args)
        if vim.bo[args.buf].filetype == "yaml" or vim.bo[args.buf].filetype == "" then
            vim.bo[args.buf].filetype = "yaml.docker-compose"
        end
    end,
})

vim.lsp.config("*", {
    capabilities = capabilities,
    on_attach = on_attach,
})

local enabled = {}
for name, cfg in pairs(servers) do
    if cfg then
        if cfg.root_dir == nil and cfg.root_markers ~= nil then
            cfg.root_dir = root_dir_fn(cfg.root_markers)
        end
        vim.lsp.config(name, cfg)
        table.insert(enabled, name)
    end
end
vim.lsp.enable(enabled)

-- Terraform autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.tf", "*.tfvars" },
    callback = function() pcall(vim.lsp.buf.format) end,
})
