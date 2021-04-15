local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local icon = gears.filesystem.get_configuration_dir() .. "/icons/brightness.svg"

local brightness_slider = function()

    local widget_icon = wibox.widget {
        id = "icon",
        image = icon,
        resize = true,
        forced_height = dpi(34),
        forced_width = dpi(34),
        widget = wibox.widget.imagebox,
    }

    local widget_slider = wibox.widget {
        bar_shape = gears.shape.rounded_rect,
        bar_height = dpi(5),
        bar_color = beautiful.fg_normal,
        bar_border_color = beautiful.border_button,
        bar_border_width = dpi(1),

        handle_shape = gears.shape.circle,
        handle_width = dpi(15),
        handle_color = beautiful.fg_normal,

        value = 50,
        minimum = 0,
        maximum = 100,
        forced_width = dpi(200),
        forced_height = dpi(20),
        widget = wibox.widget.slider
    }

    local widget_label = wibox.widget {
        text = widget_slider.value .. "%",
        font = beautiful.fontfamily["normal"] .. " 12",
        forced_width = dpi(45),
        widget = wibox.widget.textbox
    }

    local slider = wibox.widget {
        {
            widget_icon,
            widget_slider,
            widget_label,
            spacing = dpi(25),
            fill_space = false,
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place
    }

    local set_brightness = function(value, emit)
        awesome.emit_signal("evil::brightness::update", {
            value = value,
            type = "specific",
            emit = emit
        })
        widget_label.text = math.floor(value) .. "%"
    end

    awesome.connect_signal("evil::brightness", function(brightness)
        widget_slider.value = brightness.value
        widget_label.text = math.floor(brightness.value) .. "%"
    end)

    local old_cursor, old_wibox
    slider:connect_signal("mouse::enter", function(c)
		local wb = mouse.current_wibox
		old_cursor, old_wibox = wb.cursor, wb
		wb.cursor = "hand1"
	end)

	slider:connect_signal("mouse::leave", function(c)
    	if old_wibox then
            old_wibox.cursor = old_cursor
        	old_wibox = nil
    	end
	end)

    widget_slider:connect_signal("property::value", function(_, value)
        set_brightness(value, false)
    end)

    return slider
end

return brightness_slider