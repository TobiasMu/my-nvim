local M = {}
local H = {}

H.config = {
  searchkey = nil,
  forwardkey = "f",
  backwardkey = "F",
  cur_pos = {}
}

M.move = function(config, direction) ---@diagnostic disable-line
  local map = vim.keymap.set

  if config.searchkey == nil then
    local next_key = string.char(vim.fn.getchar()) ---@diagnostic disable-line 
    config.searchkey = next_key
    -- print("you pressed" .. " "..next_key)
    vim.api.nvim_feedkeys( direction .. next_key, "n", true)
    -- vim.uv.sleep(1000)
    vim.schedule(function()
      config.cur_pos = vim.api.nvim_win_get_cursor(0)end )
    -- config.cur_pos = vim.api.nvim_win_get_cursor(0)
    map("n", "f", function() M.move(config, "f") end)
    map("n", "F", function() M.move(config, "F") end)

    return
    end

  local csr = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
-- vim.api.nvim_buf_get_lines()

vim.print(csr , config.cur_pos)

  if config.searchkey ~=nil and vim.deep_equal(csr,config.cur_pos) then
    vim.api.nvim_feedkeys("f" .. config.searchkey, "n", false) 
    vim.schedule(function()
      csr = vim.api.nvim_win_get_cursor(0)
    end)
    config.cur_pos = csr
    map("n", "f", function() M.move(config, "f") end)
    return
  end

  end




M.move(H.config, "f")
-- local function listen_for_next_keypress()
--   -- The vim.fn.getchar() function waits for a keypress and returns its value.
--   local key = vim.fn.getchar()
--
--   -- You can now check what key was pressed. The value returned by getchar()
--   -- can be a number (ASCII/character code) or a string for special keys.
--   -- For single characters, like "a", the value is its ASCII code (97).
--   if key == string.byte("a") then
--     print("You pressed 'a'!")
--   elseif key == string.byte("b") then
--     print("You pressed 'b'!")
--   else
--     print("You pressed a different key.")
--   end
-- end

