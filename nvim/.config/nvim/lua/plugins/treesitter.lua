-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      opts.ensure_installed = vim.tbl_filter(function(lang)
        return lang ~= "latex"
      end, opts.ensure_installed)

      opts.auto_install = false

      opts.highlight = opts.highlight or {}
      opts.highlight.disable = opts.highlight.disable or {}

      table.insert(opts.highlight.disable, "latex")
    end,
  },
}
