local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local volume_widget = {}

local icon_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true,
}

volume_widget = wibox.widget {
    icon_widget,
    top = dpi(6),
    bottom = dpi(6),
    layout = wibox.container.margin,
}

awesome.connect_signal("evil::volume", function(volume)
    icon_widget.image = volume.image
end)

return volume_widget