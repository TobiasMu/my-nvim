local path = vim.fn.getcwd()

---@diagnostic disable-next-line: redefined-local
local test = function(path)
  local h = vim.uv.fs_scandir(path)

  a = vim.uv.fs_scandir_next(h)
  while a ~= nil do
   print(a)
    a = vim.uv.fs_scandir_next(h)
  end
vim.uv.fs_mkdir(path.."/test2", 511)
vim.uv.fs_rmdir(path.."/test")


end
test(path)
