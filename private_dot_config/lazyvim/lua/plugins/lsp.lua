-- LSP keymaps
return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- disable a keymap
    keys[#keys + 1] = { "gr", false }
    -- change a keymap
    keys[#keys + 1] = { "gt", vim.lsp.buf.references, desc = "References", nowait = true }
    -- add a keymap
    -- keys[#keys + 1] = { "gt", "<cmd>echo 'hello'<cr>" }
  end,
}
