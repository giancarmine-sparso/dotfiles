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
  },
}
