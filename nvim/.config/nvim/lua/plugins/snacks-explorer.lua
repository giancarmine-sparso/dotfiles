return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
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
            return
          end

          local file = vim.api.nvim_buf_get_name(0)
          if file ~= "" then
            local Actions = require("snacks.explorer.actions")
            local Tree = require("snacks.explorer.tree")
            local svim = require("snacks.compat")

            file = svim.fs.normalize(file)
            local cwd = explorer:cwd()
            if not Tree:in_cwd(cwd, file) then
              for parent in vim.fs.parents(file) do
                if Tree:in_cwd(parent, cwd) then
                  explorer:set_cwd(parent)
                  break
                end
              end
            end

            Tree:open(file)
            Actions.update(explorer, { target = file, refresh = true })
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
