local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local horizontal_separator = wibox.widget {
	thikness = dpi(2),
	color = beautiful.bg_button,
	forced_width = dpi(200),
	forced_height  = dpi(1),
	widget = wibox.widget.separator
}

local rounded_buttons = wibox.widget {
    require("widgets.control-center.buttons.bluetooth-button"),
    require("widgets.control-center.buttons.network-button"),
    spacing = beautiful.widget_margin or dpi(25),
    layout = wibox.layout.fixed.horizontal,
}

local volume_slider = wibox.widget {
	require("widgets.control-center.panel.volume-slider")(),
	margins = beautiful.widget_margin or dpi(15),
	widget = wibox.container.margin
}

local brightness_slider = wibox.widget {
	require("widgets.control-center.panel.brightness-slider")(),
	margins = beautiful.widget_margin or dpi(15),
	widget = wibox.container.margin
}

local control_buttons = wibox.widget {
    {
        {
            {
                rounded_buttons,
                widget = wibox.container.place
            },
            spacing = beautiful.widget_margin or dpi(25),
            layout = wibox.layout.fixed.vertical,
        },
        top = dpi(15),
        bottom = dpi(15),
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    shape = function(cr, height, width)
        gears.shape.rounded_rect(cr, height, width, 8)
    end,
    widget = wibox.container.background
}

local control_popup = awful.popup {
    widget = {
        control_buttons,
        volume_slider,
        brightness_slider,
        horizontal_separator,
        require("widgets.control-center.panel.battery"),
        horizontal_separator,
        require("widgets.control-center.panel.session"),
        layout = wibox.layout.fixed.vertical,
    },
    ontop = true,
    offset = {
        x = dpi(50),
        y = dpi(5),
    },
    shape = function(cr, height, width)
        gears.shape.rounded_rect(cr, height, width, 8)
    end,
    visible = false
}

return control_popup