require("gitsigns").setup({
    signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
    },
    current_line_blame = false,
    on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function bmap(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        bmap("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        bmap("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        bmap("n", "<leader>hp", gs.preview_hunk,            "Preview hunk")
        bmap("n", "<leader>hs", gs.stage_hunk,              "Stage hunk")
        bmap("n", "<leader>hr", gs.reset_hunk,              "Reset hunk")
        bmap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        bmap("n", "<leader>hd", gs.diffthis,                "Diff this")
        bmap("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
    end,
})
