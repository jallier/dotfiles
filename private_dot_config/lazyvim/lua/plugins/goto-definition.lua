return {
  "rmagatti/goto-preview",
  event = "BufEnter",
  config = function()
    require("goto-preview").setup()
    vim.keymap.set("n", "<leader>pd", require("goto-preview").goto_preview_definition, {})
  end,
}
