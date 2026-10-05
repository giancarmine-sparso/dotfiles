-- b:vimtex.compiler.status: 1 = running, 2 = success, 3 = failed
local tex_status = { [1] = "compiling", [2] = "ok", [3] = "failed" }

local function vimtex_status()
  return tex_status[vim.fn.eval("get(get(get(b:, 'vimtex', {}), 'compiler', {}), 'status', 0)")]
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 1, {
      function()
        return "TeX " .. vimtex_status()
      end,
      cond = function()
        return vim.bo.filetype == "tex" and vimtex_status() ~= nil
      end,
    })
  end,
}
