return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "yioneko/nvim-yati",
  },
  build = ":TSUpdate",
  branch = "master",
  event = { "BufReadPre", "BufNewFile" }, -- Load treesitter early for other plugins
  main = "nvim-treesitter.configs", -- Tells lazy.nvim exactly which module to require
  opts = {
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
    highlight = {
      enable = true,
    },
    indent = {
      enable = false,
    },
    yati = {
      enable = true,
    },
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      -- vim.uv is the modern replacement for vim.loop
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },
}
