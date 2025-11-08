return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- Ensure termguicolors is set for proper colors (optional in LazyVim as it's often set globally)
    vim.opt.termguicolors = true

    -- Setup bufferline with default options
    local bufferline = require('bufferline')
    bufferline.setup {
      options = {
        diagnostics = "coc",
        diagnostics_update_in_insert = true,
        diagnostics_update_on_event = true, -- use nvim's diagnostic handler
        indicator = {
          style = 'underline',
        },
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          }
        },
        show_duplicate_prefix = true,
      }
    }



    -- Set 'th' to jump to the previous buffer
    vim.keymap.set("n", "th", "<CMD>BufferLineCyclePrev<CR>", { desc = "BufferLine: Previous Buffer" })

    -- Set 'tl' to jump to the next buffer
    vim.keymap.set("n", "tl", "<CMD>BufferLineCycleNext<CR>", { desc = "BufferLine: Next Buffer" })
  end
}

