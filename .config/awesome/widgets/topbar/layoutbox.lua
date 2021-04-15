local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local create_layoutbox = function(screen)
    local widget_layoutbox = wibox.widget {
        {
            {
                awful.widget.layoutbox(screen),
                left = dpi(8),
                right = dpi(8),
                top = dpi(2),
                bottom = dpi(2),
                widget = wibox.container.margin
            },
            bg = beautiful.bg_button,
            shape = function(cr, height, width)
                gears.shape.rounded_rect(cr, height, width, 6)
            end,
            border_width = dpi(1),
            border_color = beautiful.border_button,
            widget = wibox.container.background
        },
        margins = dpi(6),
        widget = wibox.container.margin
    }

    widget_layoutbox:buttons(
        gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
          	awful.button({ }, 3, function () awful.layout.inc(-1) end)
        )
    )

    return widget_layoutbox
end

return create_layoutbox