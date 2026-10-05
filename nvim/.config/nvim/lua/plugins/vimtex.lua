-- ~/.config/nvim/lua/plugins/vimtex.lua

return {
  {
    "lervag/vimtex",
    init = function()
      -- LuaLaTeX come engine di default
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-lualatex",
      }

      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
    keys = {
      { "<leader>lc", "<cmd>VimtexCompile<CR>", desc = "LaTeX compile", ft = "tex" },
      { "<leader>lv", "<cmd>VimtexView<CR>", desc = "LaTeX view PDF", ft = "tex" },
      { "<leader>ls", "<cmd>VimtexStop<CR>", desc = "LaTeX stop compiler", ft = "tex" },
      { "<leader>le", "<cmd>VimtexErrors<CR>", desc = "LaTeX errors", ft = "tex" },
      { "<leader>lk", "<cmd>VimtexClean<CR>", desc = "LaTeX clean", ft = "tex" },
      { "<leader>li", "<cmd>VimtexInfo<CR>", desc = "LaTeX info", ft = "tex" },
    },
  },
}
