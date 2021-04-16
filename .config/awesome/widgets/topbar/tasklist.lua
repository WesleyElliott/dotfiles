local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local dpi = beautiful.xresources.apply_dpi

local create_tasklist = function(screen)

    local tasklist = awful.widget.tasklist {
        screen = screen,
        filter   = awful.widget.tasklist.filter.currenttags,
        layout   = {
            spacing = 5,
            spacing_widget = {
                {
                    forced_width = 5,
                    widget       = wibox.container.background
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
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
    }

    return tasklist
end

return create_tasklist