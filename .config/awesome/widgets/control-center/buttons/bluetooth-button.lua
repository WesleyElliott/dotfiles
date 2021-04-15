local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/bluetooth/"
local icon = icon_path .. "bluetooth.svg"

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
    text = "Bluetooth",
    font = beautiful.fontfamily["bold"] .. " 12",
    widget = wibox.widget.textbox
}

local text = wibox.widget {
    widget_name,
    status_text,
    layout = wibox.layout.fixed.vertical
}

local bluetooth_button = wibox.widget {
    {
        {
            widget_icon,
            text,
            spacing = dpi(4),
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

local update_button = function(active, icon)
    widget_icon.image = icon
    if active then
        status_text.text = "On"
        bluetooth_button.bg = "#0A7ACA"
    else
        status_text.text = "Off"
        bluetooth_button.bg = beautiful.bg_button
    end
end

awesome.connect_signal("evil::bluetooth", function(bluetooth)
    update_button(bluetooth.active, bluetooth.image)
end)

local old_cursor, old_wibox
bluetooth_button:connect_signal("mouse::enter", function(c)
    local wb = mouse.current_wibox
	old_cursor, old_wibox = wb.cursor, wb
	wb.cursor = "hand1"
end)

bluetooth_button:connect_signal("mouse::leave", function(c)
    if old_wibox then
    	old_wibox.cursor = old_cursor
    	old_wibox = nil
	end
end)

bluetooth_button:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            awesome.emit_signal("evil::bluetooth::toggle")
        end)
    )
)

update_button(true, icon)

return bluetooth_button