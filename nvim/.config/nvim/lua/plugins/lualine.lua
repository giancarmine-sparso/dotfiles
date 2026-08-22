return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}

    table.insert(opts.sections.lualine_x, 1, {
      function()
        if vim.bo.filetype ~= "tex" then
          return ""
        end

        local ok, status = pcall(vim.fn["vimtex#compiler#status"])
        if not ok or status == "" then
          return ""
        end

        return "TeX " .. status
      end,
      cond = function()
        return vim.bo.filetype == "tex"
      end,
    })

    local group = vim.api.nvim_create_augroup("vimtex_lualine_refresh", {
      clear = true,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = {
        "VimtexEventCompileStarted",
        "VimtexEventCompileSuccess",
        "VimtexEventCompileFailed",
        "VimtexEventCompileStopped",
      },
      callback = function()
        pcall(function()
          require("lualine").refresh()
        end)
      end,
    })

    return opts
  end,
}
