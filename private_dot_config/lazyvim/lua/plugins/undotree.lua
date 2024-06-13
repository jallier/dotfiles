return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = { -- load the plugin only when using it's keybinding:
    { "<leader>t", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo Tree" },
  },
}
