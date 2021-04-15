local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/network/"
local icon = icon_path .. "wifi.svg"

local widget_icon = wibox.widget {
    id = "icon",
    image = icon,
    forced_width = dpi(38),
    forced_height = dpi(38),
    widget = wibox.widget.imagebox,
}

local status_text = wibox.widget {
    text = "Off",
    font = beautiful.fontfamily["normal"] .. " 12",
    widget = wibox.widget.textbox
}

local widget_name = wibox.widget {
    text = "Wifi",
    font = beautiful.fontfamily["bold"] .. " 12",
    widget = wibox.widget.textbox
}

local text = wibox.widget {
    widget_name,
    status_text,
    layout = wibox.layout.fixed.vertical
}

local network_button = wibox.widget {
    {
        {
            widget_icon,
            text,
            spacing = dpi(8),
            layout = wibox.layout.fixed.horizontal,
        },
        top = dpi(12),
        bottom = dpi(12),
        left = dpi(8),
        right = dpi(8),
        widget = wibox.container.margin
    },
    forced_width = dpi(200),
    shape = gears.shape.rounded_rect,
    bg = beautiful.bg_button,
    shape_border_color = beautiful.border_button,
    shape_border_width = dpi(1),
    widget = wibox.container.background
}

local update_button = function(network_mode, network_name, icon, message)
    widget_icon.image = icon
    widget_name.text = network_mode
    status_text.text = network_name
    if message then
        status_text.text = message
    end
    if network_name ~= "No connection" then
        network_button.bg = "#608b4e"
    else
        network_button.bg = beautiful.bg_button
    end
end

awesome.connect_signal("evil::network", function(network)
    update_button(
        network.network_mode, 
        network.network_name, 
        network.image,
        network.message
    )
end)

local old_cursor, old_wibox
network_button:connect_signal("mouse::enter", function(c)
    local wb = mouse.current_wibox
	old_cursor, old_wibox = wb.cursor, wb
	wb.cursor = "hand1"
end)

network_button:connect_signal("mouse::leave", function(c)
    if old_wibox then
    	old_wibox.cursor = old_cursor
    	old_wibox = nil
	end
end)

network_button:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            awesome.emit_signal("evil::network::toggle")
        end)
    )
)

return network_button