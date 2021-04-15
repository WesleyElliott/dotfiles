local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local battery_widget = {}

local icon_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true,
    forced_height = 20,
}

local level_widget = wibox.widget {
    markup = "0%",
    font = beautiful.fontfamily["medium"] .. " 12",
    widget = wibox.widget.textbox,
}

battery_widget = wibox.widget {
    icon_widget,
    top = dpi(6),
    bottom = dpi(6),
    layout = wibox.container.margin,
}

awesome.connect_signal("evil::battery", function(battery)
    --icon_widget.markup = "<span foreground='" .. beautiful.fg_dark .."'>" .. battery.image .. "</span>"
    --level_widget.markup = "<span foreground='" .. beautiful.fg_dark .."'>" .. battery.value .. "%</span>"
    icon_widget.image = battery.image
end)

return battery_widget