-- return {
--   "glacambre/firenvim",
--   build = ":call firenvim#install(0)",
-- }

return {
  "glacambre/firenvim",
  cond = not not vim.g.started_by_firenvim,
  build = function()
    require("lazy").load({ plugins = "firenvim", wait = true })
    vim.fn["firenvim#install"](0)
  end,

  -- configure FireNvim here:
  config = function()
    vim.g.firenvim_config = {
      -- config values, like in my case:
      localSettings = {
        [".*"] = {
          takeover = "never",
        },
      },
    }
  end,
}
