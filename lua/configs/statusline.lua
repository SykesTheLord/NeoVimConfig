require("lualine").setup({
    options = {
        theme = "nord",
        icons_enabled = true,
        globalstatus = true,
        section_separators = "",
        component_separators = "│",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
            function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = {}
                for _, c in ipairs(clients) do table.insert(names, c.name) end
                return " " .. table.concat(names, ",")
            end,
            "encoding", "fileformat", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
