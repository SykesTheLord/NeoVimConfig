require("corn").setup({
    border_style = "rounded",
    truncate_message = true,
    on_toggle = function(is_hidden) return not is_hidden end,
    icons = { error = "", warn = "", info = "", hint = "󰌵" },
    item_preprocess_func = function(item) return item end,
})
