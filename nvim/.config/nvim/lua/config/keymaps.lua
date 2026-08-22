-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- LateX keymaps
vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>", { desc = "LaTeX compile" })
vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "LaTeX view PDF" })
vim.keymap.set("n", "<leader>ls", "<cmd>VimtexStop<CR>", { desc = "LaTeX stop compiler" })
vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<CR>", { desc = "LaTeX errors" })
vim.keymap.set("n", "<leader>lk", "<cmd>VimtexClean<CR>", { desc = "LaTeX clean" })
vim.keymap.set("n", "<leader>li", "<cmd>VimtexInfo<CR>", { desc = "LaTeX info" })
