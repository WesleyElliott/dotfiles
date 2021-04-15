local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local control_popup = require("widgets.control-center.panel")

local battery_widget = require("widgets.control-center.battery")
local network_widget = require("widgets.control-center.network")
local volume_widget = require("widgets.control-center.volume")

-- import battery, volume and network widgets

local control_center = wibox.widget {
    {
        {
            {
                {
                    -- volume,
                    network_widget,
                    battery_widget,
                    volume_widget,
                    spacing = dpi(4),
                    layout = wibox.layout.fixed.horizontal
                },
                widget = wibox.container.place
            },
            left = dpi(8),
            right = dpi(8),
            top = dpi(2),
            bottom = dpi(2),
            widget = wibox.container.margin,
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

-- Hook up control center click here
-- This will toggle the actual control center popup
control_center:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            if control_popup.visible then
                control_popup.visible = not control_popup.visible
            else
                control_popup.visible = true
                control_popup:move_next_to(mouse.current_widget_geometry)
            end
        end)
    )
)

awesome.connect_signal("evil::dismiss-popups", function() 
    if control_popup.visible then
        control_popup.visible = false
    end
end)

return control_center