return {
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      -- the keys below are the only mappings; the plugin's own defaults
      -- override them and add global terminal maps that type into the shell
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Vai a sinistra" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Vai giù" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Vai su" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Vai a destra" },
    },
  },
}
