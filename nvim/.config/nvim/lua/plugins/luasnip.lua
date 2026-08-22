return {
  {
    "L3MON4D3/LuaSnip",

    opts = {
      enable_autosnippets = true,
    },

    config = function(_, opts)
      local ls = require("luasnip")

      ls.setup(opts)

      require("luasnip.loaders.from_vscode").load({
        paths = {
          vim.fn.stdpath("config") .. "/snippets",
        },
      })

      require("luasnip.loaders.from_lua").load({
        paths = {
          vim.fn.stdpath("config") .. "/snippets",
        },
      })
    end,
  },
}
