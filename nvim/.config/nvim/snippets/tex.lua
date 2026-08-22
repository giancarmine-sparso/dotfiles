local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  -- \( ... \)
  s(
    {
      trig = [[\(]],
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Inline math",
    },
    fmta([[\(<>\)<>]], {
      i(1),
      i(0),
    })
  ),

  -- \[ ... \]
  s(
    {
      trig = [[\[]],
      wordTrig = false,
      snippetType = "autosnippet",
      dscr = "Display math",
    },
    fmta(
      [[
\[
  <>
\]
<>
]],
      {
        i(1),
        i(0),
      }
    )
  ),
}
