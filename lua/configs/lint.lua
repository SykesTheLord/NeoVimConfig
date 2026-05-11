local lint = require("lint")

lint.linters_by_ft = {
    markdown   = { "vale" },
    cs         = { "trivy" },
    terraform  = { "tfsec", "trivy" },
    c          = { "trivy" },
    cpp        = { "trivy", "cpplint" },
    cmake      = { "cmakelint" },
    html       = { "htmlhint" },
    java       = { "checkstyle", "trivy" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    json       = { "jsonlint" },
    python     = { "pylint" },
    sh         = { "shellcheck" },
    bash       = { "shellcheck" },
    sql        = { "sqlfluff" },
    dockerfile = { "trivy" },
    lua        = { "luacheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function() pcall(lint.try_lint) end,
})
