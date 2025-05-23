--
-- Provides:
-- bling::tag_preview::update   -- first line is the signal
--      t   (tag)               -- indented lines are function parameters
-- bling::tag_preview::visibility
--      s   (screen)
--      v   (boolean)
--
local awful = require("awful")
local wibox = require("wibox")
local helpers = require(tostring(...):match(".*bling") .. ".helpers")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local cairo = require("lgi").cairo

local function draw_widget(
  tag_preview_box,
  t,
  tag_preview_image,
  scale,
  screen_radius,
  client_radius,
  client_opacity,
  client_bg,
  client_border_color,
  client_border_width,
  widget_bg,
  widget_border_color,
  widget_border_width,
  geo,
  margin
)
  local client_list = wibox.layout.manual()
  client_list.forced_height = geo.height
  client_list.forced_width = geo.width
  local tag_screen = t.screen
  for i, c in ipairs(t:clients()) do
    if not c.hidden and not c.minimized then
      local img_box = wibox.widget({
        image = gears.surface.load(c.icon),
        resize = true,
        forced_height = 100 * scale,
        forced_width = 100 * scale,
        widget = wibox.widget.imagebox,
      })

      if tag_preview_image then
        if c.prev_content or t.selected then
          local content
          if t.selected then
            content = gears.surface(c.content)
          else
            content = gears.surface(c.prev_content)
          end
          local cr = cairo.Context(content)
          local x, y, w, h = cr:clip_extents()
          local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w - x, h - y)
          cr = cairo.Context(img)
          cr:set_source_surface(content, 0, 0)
          cr.operator = cairo.Operator.SOURCE
          cr:paint()

          img_box = wibox.widget({
            image = gears.surface.load(img),
            resize = true,
            opacity = client_opacity,
            forced_height = math.floor(c.height * scale),
            forced_width = math.floor(c.width * scale),
            widget = wibox.widget.imagebox,
          })
        end
      end

      local client_box = wibox.widget({
        {
          nil,
          {
            nil,
            img_box,
            nil,
            expand = "outside",
            layout = wibox.layout.align.horizontal,
          },
          nil,
          expand = "outside",
          widget = wibox.layout.align.vertical,
        },
        forced_height = math.floor(c.height * scale),
        forced_width = math.floor(c.width * scale),
        bg = client_bg,
        shape_border_color = client_border_color,
        shape_border_width = client_border_width,
        shape = helpers.shape.rrect(client_radius),
        widget = wibox.container.background,
      })

      client_box.point = {
        x = math.floor((c.x - geo.x) * scale),
        y = math.floor((c.y - geo.y) * scale),
      }

      client_list:add(client_box)
    end
  end

  tag_preview_box:setup({
    {
      {
        {
          {
            client_list,
            forced_height = geo.height,
            forced_width = geo.width,
            bg = widget_bg,
            widget = wibox.container.background,
          },
          layout = wibox.layout.align.horizontal,
        },
        layout = wibox.layout.align.vertical,
      },
      margins = margin,
      widget = wibox.container.margin,
    },
    bg = widget_bg,
    border_width = widget_border_width,
    border_color = widget_border_color,
    shape = helpers.shape.rrect(screen_radius),
    widget = wibox.container.background,
  })
end

local enable = function(opts)
  local opts = opts or {}

  local tag_preview_image = opts.show_client_content or false
  local widget_x = opts.x or dpi(20)
  local widget_y = opts.y or dpi(20)
  local scale = opts.scale or 0.2
  local work_area = opts.honor_workarea or false
  local padding = opts.honor_padding or false
  local placement_fn = opts.placement_fn or nil

  local margin = beautiful.tag_preview_widget_margin or dpi(0)
  local screen_radius = beautiful.tag_preview_widget_border_radius or dpi(0)
  local client_radius = beautiful.tag_preview_client_border_radius or dpi(0)
  local client_opacity = beautiful.tag_preview_client_opacity or 0.5
  local client_bg = beautiful.tag_preview_client_bg or "#000000"
  local client_border_color = beautiful.tag_preview_client_border_color or "#ffffff"
  local client_border_width = beautiful.tag_preview_client_border_width or dpi(3)
  local widget_bg = beautiful.tag_preview_widget_bg or "#000000"
  local widget_border_color = beautiful.tag_preview_widget_border_color or "#ffffff"
  local widget_border_width = beautiful.tag_preview_widget_border_width or dpi(3)

  local tag_preview_box = wibox({
    type = "dropdown_menu",
    visible = false,
    ontop = true,
    input_passthrough = true,
    bg = "#00000000",
  })

  tag.connect_signal("property::selected", function(t)
    for _, c in ipairs(t:clients()) do
      c.prev_content = gears.surface.duplicate_surface(c.content)
    end
  end)

  awesome.connect_signal("bling::tag_preview::update", function(t)
    local geo = t.screen:get_bounding_geometry({
      honor_padding = padding,
      honor_workarea = work_area,
    })

    tag_preview_box.width = scale * geo.width + margin * 2
    tag_preview_box.height = scale * geo.height + margin * 2

    draw_widget(
      tag_preview_box,
      t,
      tag_preview_image,
      scale,
      screen_radius,
      client_radius,
      client_opacity,
      client_bg,
      client_border_color,
      client_border_width,
      widget_bg,
      widget_border_color,
      widget_border_width,
      geo,
      margin
    )
  end)

  awesome.connect_signal("bling::tag_preview::visibility", function(s, v)
    if placement_fn then
      placement_fn(tag_preview_box)
    else
      tag_preview_box.x = s.geometry.x + widget_x
      tag_preview_box.y = s.geometry.y + widget_y
    end

    tag_preview_box.visible = v
  end)
end

return { enable = enable }
