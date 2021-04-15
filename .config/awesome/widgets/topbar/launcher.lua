local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local launcher = wibox.widget {
    widget = wibox.container.margin,
    top = 6,
    bottom = 6,
    left = 6,
    right = 6,
    {
        awful.widget.launcher({
            image = beautiful.awesome_icon, menu = nil, spacing = 20
        }),
        layout = wibox.layout.fixed.horizontal
    }
}

return launcher