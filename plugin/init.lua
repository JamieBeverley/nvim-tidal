local plugin_name = "nvim-tidal"
vim.api.nvim_create_user_command("TidalStart", function()
    require(plugin_name)._start_ghci()
end, {})

vim.api.nvim_create_user_command("TidalSend", function(opts)
    require(plugin_name)._send_to_ghci(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("TidalStop", function()
    require(plugin_name)._end_ghci()
end, {})
