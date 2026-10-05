return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      indent = { animate = { enabled = false } },
      picker = {
        sources = {
          explorer = {
            layout = { layout = { position = "right" } },
          },

          files = {
            layout = {
              preset = "vertical",
              preview = false,
            },
          },
        },
      },
    },

    keys = {
      {
        "<leader>o",
        function()
          local explorer = Snacks.picker.get({ source = "explorer" })[1]
          if not explorer then
            -- same as <leader>e; the explorer follows the current file
            return Snacks.explorer({ cwd = LazyVim.root() })
          end

          if vim.api.nvim_buf_get_name(0) ~= "" then
            Snacks.explorer.reveal()
          end
          explorer:focus("list", { show = true })
        end,
        desc = "Focus Explorer",
      },

      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
    },
  },
}
