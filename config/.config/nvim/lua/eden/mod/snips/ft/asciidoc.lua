local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("asciidoc", {
  s(
    "img",
    fmt("image{3}{1}[{2}]{4}", {
      i(1, "path"),
      i(2, "alt"),
      c(3, { t("::"), t(":") }),
      i(0),
    })
  ),
  s("t", fmt("* [{1}] {2}{3}", { c(2, { t(" "), t("x") }), i(1, "task"), i(0) })),
})
