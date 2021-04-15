local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local create_button = {}

-- Create a small circle button
-- @param icon the icon to show
function create_button.small(args)
    local button_image = wibox.widget {
        id = "icon",
        image = args.icon,
        resize = true,
        forced_width = args.icon_size or dpi(22),
        forced_height = args.icon_size or dpi(22),
        widget = wibox.widget.imagebox
    }

    local button = wibox.widget {
        {
            button_image,
            valign = "center",
            halign = "center",
            widget = wibox.container.place
        },
        bg = beautiful.bg_button,
        forced_width = args.button_size or dpi(36),
        forced_height = args.button_size or dpi(36),
        shape = gears.shape.circle,
        shape_border_color = beautiful.border_button,
        shape_border_width = dpi(1),
        widget = wibox.container.background
    }

    local old_cursor, old_wibox
    button:connect_signal("mouse::enter", function(c)
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.current = "hand1"
    end)

    button:connect_signal("mouse::leave", function(c)
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    return button

end

-- Create a big circle button
-- @param icon the icon to show
-- @param on_create the action that happens when this widget is created
-- @param on_click the action that happens when the widget is clicked
function create_button.big(icon, on_create, on_click)
    local button_image = wibox.widget {
        id = "icon",
        image = icon,
        forced_width = dpi(26),
        forced_height = dpi(26),
        widget = wibox.widget.imagebox
    }

    local button = wibox.widget {
        {
            button_image,
            margins = dpi(11),
            widget = wibox.container.margin
        },
        bg = beautiful.bg_button,
        shape = gears.shape.circle,
        shape_border_color = beautiful.border_button,
        shape_border_width = dpi(1),
        widget = wibox.container.background
    }

    local old_cursor, old_wibox
    button:connect_signal("mouse::enter", function(c)
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.current = "hand1"
    end)

    button:connect_signal("mouse::leave", function(c)
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    button:buttons(
        gears.table.join(button:buttons(), awful.button({}, 1, nil, function() 
            if on_click then
                on_click()
                if on_create then
                    on_create(button)
                end
            end
        end))
    )

    if on_create then
        on_create(button)
    end

    return button
end

return create_button