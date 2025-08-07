local H = {}

H.jump_config = {
  searchkey = nil,
  forwardkey = "f",
  backwardkey = "F",
  last_pos = {}
}

H.move = function(config) ---@diagnostic disable-line
  if config == nil then config = H.jump_config end
  local csr = vim.api.nvim_win_get_cursor(0)


  if config.searchkey == nil then
    local key = string.char(vim.fn.getchar()) ---@diagnostic disable-line 
    vim.api.nvim_feedkeys('/'..key .. '\r', "n", true)
    config.searchkey = key
    vim.schedule(function()
    config.last_pos = vim.api.nvim_win_get_cursor(0)end)
    return
  end
  if config.searchkey ~= nil and vim.deep_equal(csr, config.last_pos) then
    vim.api.nvim_feedkeys('n', "n", true)
    vim.schedule(function()
    config.last_pos = vim.api.nvim_win_get_cursor(0)end)
  end

  if config.searchkey ~= nil and not vim.deep_equal(csr, config.last_pos) then
    config.searchkey = nil
    H.move(config)
  end
  end
vim.keymap.set("n","f",function()H.move()end)

