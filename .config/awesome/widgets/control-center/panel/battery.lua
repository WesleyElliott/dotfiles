local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local battery_percent = wibox.widget {
    text = "35%",
    font = beautiful.fontfamily["normal"] .. " 12",
    forced_width = dpi(45),
    widget = wibox.widget.textbox
}

local widget_icon = wibox.widget {
    id = "icon",
    resize = true,
    forced_height = dpi(34),
    forced_width = dpi(34),
    widget = wibox.widget.imagebox,
}

local battery_state = wibox.widget {
    text = "Discharging",
    font = beautiful.fontfamily["normal"] .. " 12",
    valign = "left",
    forced_width = dpi(200),
    forced_height = dpi(20),
    widget = wibox.widget.textbox,
}

local battery_widget = wibox.widget {
    {
        {
            widget_icon,
            battery_state,
            battery_percent,
            spacing = dpi(25),
            fill_space = false,
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place
    },
    margins = beautiful.widget_margin or dpi(25),
    widget = wibox.container.margin
}

awesome.connect_signal("evil::battery", function(battery)
    battery_percent.text = battery.value .. "%"
    widget_icon.image = battery.image
    local state = "Discharging"
    if battery.status == "charging" then
        state = "Charging"
    end
    battery_state.text = state
end)

return battery_widget