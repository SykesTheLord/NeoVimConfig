local conform = require("conform")

conform.setup({
    log_level = vim.log.levels.WARN,
    notify_on_error = true,

    formatters_by_ft = {
        lua = { "stylua" },

        cs = { "csharpier" },

        c = { "clang-format" },
        cpp = { "clang-format" },
        java = { "google-java-format" },

        cmake = { "cmake_format" },

        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },

        sh = { "beautysh" },
        zsh = { "beautysh" },
        bash = { "beautysh" },

        sql = { "sql_formatter" },

        python = { "black" },
    },

    formatters = {
        beautysh = {
            stdin = false,
            args = function(_, ctx)
                local shiftwidth = vim.bo[ctx.buf].shiftwidth
                local expandtab = vim.bo[ctx.buf].expandtab
                if not expandtab then shiftwidth = 0 end
                return { "-i", tostring(shiftwidth), "$FILENAME" }
            end,
        },
    },

    format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
    },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_user_command("Format", function()
    conform.format({ lsp_format = "fallback" })
end, {})

vim.api.nvim_create_user_command("FormatWrite", function()
    conform.format({ lsp_format = "fallback" })
    vim.cmd("write")
end, {})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    conform.format({ lsp_format = "fallback" })
end, { desc = "Format buffer/selection" })
