local wt = require("wezterm")

return {
  colors = {
    background = "#192330",
    foreground = "#afc0d5",

    cursor_bg = "#7f8c98",
    cursor_fg = "#afc0d5",

    ansi = { "#393b44", "#c94f6d", "#81b29a", "#dbc074", "#719cd6", "#9d79d6", "#63cdcf", "#dfdfe0" },
    brights = { "#7f8c98", "#d6616b", "#58cd8b", "#ffe37e", "#84cee4", "#b8a1e3", "#59f0ff", "#f2f2f2" },
  },

  font = wt.font_with_fallback({
    "Hack Nerd Font Mono",
    "UbuntuMono NF",
    "JetBrains Mono",
  }),

  hide_tab_bar_if_only_one_tab = true,

  window_padding = {
    left = 5,
    right = 5,
    bottom = 5,
  },
}
