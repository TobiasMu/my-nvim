
local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

  local  opts = {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

-- Create a buffer
local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }
require("m.basic")
  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)
--
vim.print(vim.uv.fs_readdir(ufs))
vim.print(vim.fn.getcurpos())

