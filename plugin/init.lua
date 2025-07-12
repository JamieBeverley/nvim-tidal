local plugin_name = "nvim-tidal"
vim.api.nvim_create_user_command("TidalStart", function()
    require(plugin_name).start()
end, {})

vim.api.nvim_create_user_command("TidalSend", function(opts)
    require(plugin_name).send_to_tidal(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("TidalStop", function()
    require(plugin_name).stop()
end, {})
