return {
  "romus204/tree-sitter-manager.nvim",
  dependencies = {},
  config = function()
    require("tree-sitter-manager").setup({
      auto_install = true,
      highlight = true,
      ensure_installed = {
        "c",
        "go",
        "tsx",
        "json",
        "javascript",
        "typescript",
        "python",
        "lua",
        "vim",
        "bash",
        "markdown",
      },
      noauto_install = {
        "gitcommit"
      }
    })
  end,
}
