local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local create_button = require("widgets.common.general-button")
local dpi = beautiful.xresources.apply_dpi

local power_icon = gears.filesystem.get_configuration_dir() .. "/icons/system/power.svg"

local widget_username = wibox.widget {
    text = "...",
    font = beautiful.fontfamily["bold"] .. " 12",
    widget = wibox.widget.textbox
}

local widget_hostname = wibox.widget {
    text = "@localhost",
    font = beautiful.fontfamily["normal"] .. " 10",
    widget = wibox.widget.textbox,
}

local power_button = create_button.small({
    icon = power_icon, 
    icon_size = dpi(34),
    button_size = dpi(44)
})
power_button:connect_signal("button::press", function (_, _, _, button)
	if button == 1 then 
		awesome.emit_signal("system::exit-screen::show")
	end
end)

local old_cursor, old_wibox
power_button:connect_signal("mouse::enter", function(c)
    local wb = mouse.current_wibox
	old_cursor, old_wibox = wb.cursor, wb
	wb.cursor = "hand1"
end)

power_button:connect_signal("mouse::leave", function(c)
    if old_wibox then
    	old_wibox.cursor = old_cursor
    	old_wibox = nil
	end
end)

local session_widget = wibox.widget {
    {
        {
            {
                image = "/home/wesley/.config/awesome/icons/logo_arch.svg",
                resize = true,
                forced_width = dpi(46),
                forced_height = dpi(46),
                widget = wibox.widget.imagebox
            },
            {
                {
                    widget_username,
                    widget_hostname,
                    forced_width = dpi(200),
                    layout = wibox.layout.fixed.vertical,
                },
                widget = wibox.container.place
            },
            power_button,
            spacing = dpi(25),
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place
    },
    margins = dpi(25),
    widget = wibox.container.margin
}

awesome.connect_signal("evil::system", function(system)
    widget_username.text = system.username
    widget_hostname.text = "@" .. system.hostname
end)

return session_widget