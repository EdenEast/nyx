local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
  s("img", fmt("![{1}]({2})", { i(1, "path"), i(2, "alt") })),
  s("t", fmt("- [{1}] {2}", { c(2, { t(" "), t("x") }), i(1, "task") })),
})
