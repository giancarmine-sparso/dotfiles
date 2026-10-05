-- LuaSnip is managed by the `coding.luasnip` extra (friendly-snippets,
-- vscode snippets in ./snippets, blink integration). Here we only add
-- autosnippets and the Lua snippets in ./snippets.
return {
  {
    "L3MON4D3/LuaSnip",
    -- load before the first keystroke, so autosnippets work on the first insert
    event = "InsertEnter",
    opts = {
      enable_autosnippets = true,
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  },
}
