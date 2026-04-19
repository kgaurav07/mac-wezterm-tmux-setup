vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = true
    -- Toggle wrap with <leader>mw when needed for long prose
    vim.keymap.set("n", "<leader>mw", function()
      vim.opt_local.wrap = not vim.opt_local.wrap:get()
    end, { buffer = true, desc = "Toggle wrap (markdown)" })
  end,
})
