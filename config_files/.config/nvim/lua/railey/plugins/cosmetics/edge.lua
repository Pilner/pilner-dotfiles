return {
  "sainnhe/edge",
  priority = 1000,
  lazy = false,
  config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/vim")
    vim.cmd([[colorscheme edge]])
  end,
}
