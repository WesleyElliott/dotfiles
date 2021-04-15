local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local get_titlebar = function(client)
    local buttons = gears.table.join(
        awful.button({}, 1, function() 
            client.focus = client
            awful.mouse.client.move(client)
            client:raise()
        end),
        awful.button({}, 3, function() 
            client.focus = client
            client:raise()
            awful.mouse.client.resize(client)
        end)
    )

    local left = {
        {
            awful.titlebar.widget.closebutton(client),
            awful.titlebar.widget.minimizebutton(client),
            awful.titlebar.widget.maximizedbutton(client),
            layout = wibox.layout.fixed.horizontal,
        },
        top = dpi(2),
        bottom = dpi(2),
        right = dpi(4),
        widget = wibox.container.margin
    }

    local middle = {
        {
            align = "center",
            font = beautiful.font,
            widget = awful.titlebar.widget.titlewidget(client),
        },
        buttons = buttons,
        layout = wibox.layout.flex.horizontal,
    }

    local right = {
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal,
    }

    local titlebar = {
        {
            left,
            middle,
            right,
            layout = wibox.layout.align.horizontal,
        },
        widget = wibox.container.background,
    }

    return titlebar
end

return get_titlebar