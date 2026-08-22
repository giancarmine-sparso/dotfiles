local default_colorscheme = "kanagawa-dragon"
local colorscheme_state = vim.fn.stdpath("state") .. "/colorscheme"

local function read_colorscheme()
  if vim.fn.filereadable(colorscheme_state) == 0 then
    return default_colorscheme
  end

  local lines = vim.fn.readfile(colorscheme_state)
  local colorscheme = vim.trim(lines[1] or "")

  if colorscheme == "" then
    return default_colorscheme
  end

  return colorscheme
end

local function write_colorscheme(colorscheme)
  if not colorscheme or colorscheme == "" then
    return
  end

  pcall(function()
    vim.fn.mkdir(vim.fn.fnamemodify(colorscheme_state, ":h"), "p")
    vim.fn.writefile({ colorscheme }, colorscheme_state)
  end)
end

local selected_colorscheme = read_colorscheme()

return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("PersistColorscheme", { clear = true }),
        callback = function(event)
          write_colorscheme(event.match)
        end,
      })
    end,
    opts = {
      colorscheme = selected_colorscheme,
    },
  },
}
