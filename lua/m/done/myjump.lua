local H = {}

H.jump_config = {
  searchkey = nil,
  forwardkey = "f",
  backwardkey = "F",
  cur_pos = {}
}

H.move = function(config, direction) ---@diagnostic disable-line
  if vim.deep_equal({},config) then config = H.jump_config end
  local map = vim.keymap.set

  if config.searchkey == nil then
    local next_key = string.char(vim.fn.getchar()) ---@diagnostic disable-line 
    config.searchkey = next_key
    -- vim.api.nvim_feedkeys( direction .. next_key, "n", true)
    vim.cmd('/'..next_key)
    vim.schedule(function()
      config.cur_pos = vim.api.nvim_win_get_cursor(0)end )
    -- config.cur_pos = vim.api.nvim_win_get_cursor(0)
    map("n", "f", function() H.move(config, "f") end)
    map("n", "F", function() H.move(config, "F") end)

    return
    end

  local csr = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  if config.searchkey ~=nil and vim.deep_equal(csr,config.cur_pos) then
    vim.api.nvim_feedkeys(direction .. config.searchkey, "n", false)
    vim.schedule(function()
      config.cur_pos = vim.api.nvim_win_get_cursor(0)
    end)
    map("n", "f", function() H.move(config, "f") end)
    map("n", "F", function() H.move(config, "F") end)
    return
  end
  if config.searchkey ~=nil and not vim.deep_equal(csr,config.cur_pos) then

    local next_key = string.char(vim.fn.getchar()) ---@diagnostic disable-line 
    config.searchkey = next_key
    vim.api.nvim_feedkeys( direction .. next_key, "n", true)
    vim.schedule(function()
      config.cur_pos = vim.api.nvim_win_get_cursor(0)end )
    map("n", "f", function() H.move(config, "f") end)
    map("n", "F", function() H.move(config, "F") end)


  end

  end
local map = vim.keymap.set
    map("n", "f", function() H.move({}, "f") end)
    map("n", "F", function() H.move({}, "F") end)

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

