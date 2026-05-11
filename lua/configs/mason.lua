require("mason").setup({ ui = { border = "rounded" } })

require("mason-tool-installer").setup({
    ensure_installed = {
        "trivy",
        "csharpier",
        "netcoredbg",
        "black",
        "debugpy",
        "pylint",
        "eslint_d",
        "jsonlint",
        "beautysh",
        "shellcheck",
        "prettierd",
        "java-debug-adapter",
        "clang-format",
        "stylua",
        "luacheck",
        "cmakelang",
        "sqlfluff",
        "sql-formatter",
        "vale",
        "tfsec",
        "cpplint",
        "cmakelint",
        "htmlhint",
        "checkstyle",
        "cpptools",
        "google-java-format",
    },
    automatic_installation = true,
    auto_update = true,
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd", "eslint", "jedi_language_server", "jsonls", "yamlls",
        "terraformls", "dockerls", "bashls", "docker_compose_language_service",
        "jdtls", "lua_ls", "marksman", "powershell_es", "cmake", "vimls",
        "bicep", "sqls",
    },
    automatic_enable = false,
})

local registry = require("mason-registry")
local ok, pkg = pcall(registry.get_package, "csharp-language-server")
if ok and pkg and not pkg:is_installed() then
    pcall(function() pkg:install({ version = "0.16.0" }) end)
end
