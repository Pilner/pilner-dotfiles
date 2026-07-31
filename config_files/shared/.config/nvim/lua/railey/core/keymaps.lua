vim.g.mapleader = " "

local keymap = vim.keymap

-- Remove space to move forward
keymap.set("n", "<Space>", "<NOP>", {noremap = true})

-- Regarding Tabs
keymap.set("n", "<leader>tn", ":tabnew<cr>")
-- keymap.set("n", "<leader>t<leader>", ":tabnext")
keymap.set("n", "<leader>tm", ":tabmove")
keymap.set("n", "<leader>tc", ":tabclose<cr>")
keymap.set("n", "<leader>to", ":tabonly<cr>")

-- Use CTRL+<hjkl> to switch between split windows
keymap.set("n", "<C-H>", "<C-W>h")
keymap.set("n", "<C-J>", "<C-W>j")
keymap.set("n", "<C-K>", "<C-W>k")
keymap.set("n", "<C-L>", "<C-W>l")
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- equal width
keymap.set("n", "<leader>sx", ":close<cr>") -- close current split windows

-- Move highlighted text up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy to system clipboard
keymap.set({"n", "v"}, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])
-- Paste from system clipboard
keymap.set({"n", "v"}, "<leader>p", [["+p]])
keymap.set("n", "<leader>P", [["+P]])

-- Use alt + hjkl to resize windows
keymap.set("n", "<M-h>", ":vertical resize -2<CR>", {})
keymap.set("n", "<M-l>", ":vertical resize +2<CR>", {})
keymap.set("n", "<M-j>", ":horizontal resize -2<CR>", {})
keymap.set("n", "<M-k>", ":horizontal resize +2<CR>", {})
keymap.set("n", "<leader>zz", ":w<cr>")

-- Move up and down in a "wrapped" line (single line)
keymap.set("n", "j", "gj", {noremap = true})
keymap.set("n", "k", "gk", {noremap = true})
keymap.set("n", "gj", "j", {noremap = true})
keymap.set("n", "gk", "k", {noremap = true})

-- Copy relative file path to neovim instance
keymap.set('n', '<leader>cr', ':let @+ =expand("%:.")<CR>')

-- Keymap to run native git blame for the current line in a floating notification or command line
vim.keymap.set('n', '<leader>gb', function()
  local file = vim.fn.expand('%')
  local line = vim.fn.line('.')
  
  if file ~= '' then
    -- 1. Execute git blame and capture the output
    local blame_cmd = string.format("git blame -w -L %d,+1 %s", line, vim.fn.shellescape(file))
    local blame_output = vim.fn.system(blame_cmd)
    
    -- 2. Extract the commit SHA 
    local commit_sha = string.match(blame_output, "^%^?(%w+)")
    
    -- 3. Ensure the line is committed (not a string of zeroes)
    if commit_sha and not string.match(commit_sha, "^0+$") then
      vim.notify("Searching for PR for commit " .. commit_sha .. "...", vim.log.levels.INFO)
      
      -- 4. Search GitHub for the PR associated with this commit
      -- We use `gh pr list --search <SHA>` to find the PR, and `--jq` to extract just the PR number
      local search_cmd = string.format("gh pr list --search %s --state all --json number --jq '.[0].number'", commit_sha)
      local pr_number = vim.fn.system(search_cmd):gsub("%s+", "") -- strip whitespace/newlines
      
      -- 5. Open the PR if a valid number is returned
      if pr_number ~= "" and pr_number ~= "null" then
        local view_cmd = string.format("gh pr view %s --web", pr_number)
        vim.fn.system(view_cmd)
        vim.notify("Opened PR #" .. pr_number .. " in browser.", vim.log.levels.INFO)
      else
        vim.notify("No pull request found for commit: " .. commit_sha, vim.log.levels.WARN)
      end
    else
      vim.notify("This line has uncommitted changes.", vim.log.levels.WARN)
    end
  end
end, { desc = 'Native Git Blame Line to PR' })
