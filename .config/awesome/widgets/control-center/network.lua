local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local network_widget = {}

local icon_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true,
}

local level_widget = wibox.widget {
    markup = "0%",
    font = beautiful.fontfamily["medium"] .. " 12",
    widget = wibox.widget.textbox,
}

network_widget = wibox.widget {
    icon_widget,
    top = dpi(6),
    bottom = dpi(6),
    layout = wibox.container.margin,
}

awesome.connect_signal("evil::network", function(network)
    icon_widget.image = network.image
end)

return network_widget