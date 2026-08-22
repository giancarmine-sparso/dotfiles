-- ~/.config/nvim/lua/plugins/vimtex.lua

return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_compiler_method = "latexmk"

      -- LuaLaTeX come engine di default
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-lualatex",
      }

      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        continuous = 1,
        callback = 1,
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
  },
}
