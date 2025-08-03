require("m.basic").setup()

vim.keymap.set("n", "ciq", [[f"vi"c]])
vim.keymap.set("n", "<leader>xx", ":so<cr>")
vim.keymap.set("n", "<leader>xl", ":.lua<cr>")

vim.keymap.set("n", "-", ":e .<cr>")



