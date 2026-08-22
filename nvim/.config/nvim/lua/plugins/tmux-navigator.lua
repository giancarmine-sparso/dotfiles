return {
  {
    "christoomey/vim-tmux-navigator",
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
