local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("asciidoc", {
  s("include", fmt("include::{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("include", fmt("include:{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("image", fmt("image::{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("image", fmt("image:{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("video", fmt("video::{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("video", fmt("video:{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("link", fmt("link::{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),
  s("link", fmt("link:{}[{}]{}", { i(1, "path"), i(2, "alt"), i(0) })),

  s(
    "heading",
    fmt("{} {}\n{}", { c(2, { t("="), t("=="), t("==="), t("===="), t("====="), t("======") }), i(1, "heading"), i(0) })
  ),

  s("sidebar", fmt("[sidebar]\n{}", { i(0) })),
  s("caution", fmt("[CAUTION]\n====\n{}\n====\n{}", { i(1), i(0) })),
  s("imp", fmt("[IMPORTANT]\n====\n{}\n====\n{}", { i(1), i(0) })),
  s("note", fmt("[NOTE]\n====\n{}\n====\n{}", { i(1), i(0) })),
  s("tip", fmt("[TIP]\n====\n{}\n====\n{}", { i(1), i(0) })),
  s("warn", fmt("[WARNING]\n====\n{}\n====\n{}", { i(1), i(0) })),
})

-- https://github.com/asciidoctor/asciidoctor-vscode/blob/master/snippets/snippets.json
-- https://github.com/jhradilek/vim-snippets/blob/master/UltiSnips/asciidoc.snippets
-- https://github.com/abhatt-rh/asciidoc_vscode_snippets/blob/main/snippets/asciidoc-vscode.code-snippets
