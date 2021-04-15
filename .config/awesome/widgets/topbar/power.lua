local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/system/"

local widget_power = wibox.widget {
    {
        {
            {
                image = icon_path .. "power.svg",
                resize = true,
                forced_width = dpi(32),
                forced_height = dpi(32),
                widget = wibox.widget.imagebox
            },
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

widget_power:buttons(gears.table.join(
    awful.button({ }, 1, function () awesome.emit_signal("system::exit-screen::show") end)
))

return widget_power