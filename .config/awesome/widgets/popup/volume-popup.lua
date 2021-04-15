local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require('beautiful').xresources.apply_dpi

local widget_icon = wibox.widget {
    forced_height = dpi(128),
    forced_width = dpi(128),
    resize = true,
    widget = wibox.widget.imagebox
}

local widget_title = wibox.widget {
    text = "Volume",
    font = beautiful.fontfamily["bold"] .. " 14",
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

local widget_value = wibox.widget {
    text = "0%",
    font = beautiful.fontfamily["bold"] .. " 14",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local widget_progress = wibox.widget {
    value = 0,
    color = "#ffffff20",
    background_color = "#2f3240",
    max_value = 100,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    forced_height = dpi(15),
    widget = wibox.widget.progressbar
}

screen.connect_signal("request::desktop_decoration", function(screen)
    local screen = screen or {}
    screen.volume_popup = awful.popup {
        widget = {},
        ontop = true,
        visible = false,
        type = "notification",
        screen = screen,
        height = dpi(250),
        width = dpi(250),
        maximum_height = dpi(250),
        maximum_width = dpi(250),
        offset = dpi(5),
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 8)
        end,
        bg = beautiful.bg_normal,
        placement = awful.placement.centered,
        preferred_anchors = "middle",
        preferred_positions = { "left", "right", "top", "bottom" }
    }

    screen.volume_popup : setup {
        {
            {
                {
                    {
                        nil,
                        widget_icon,
                        nil,
                        expand = "none",
                        layout = wibox.layout.align.horizontal
                    },
                    {
                        {
                            widget_title,
                            nil,
                            widget_value,
                            expand = "none",
                            layout = wibox.layout.align.horizontal
                        },
                        widget_progress,
                        spacing = dpi(10),
                        layout = wibox.layout.fixed.vertical
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical
                },
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(24),
            widget = wibox.container.margin
        },
        forced_width = dpi(250),
        bg = beautiful.background,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 8)
        end,
        widget = wibox.container.background
    }
end)

local hide_popup = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        local focused = awful.screen.focused()
        focused.volume_popup.visible = false
    end
}

local popup_placer = function()
    local focused = awful.screen.focused()
    local popup = focused.volume_popup
    awful.placement.next_to(
        popup,
        {
            preferred_positions = "top",
            preferred_anchors = "middle",
            geometry = screen,
            offset = {
                x = 0,
                y = dpi(-20)
            }
        }
    )
end

awesome.connect_signal("evil::volume", function(volume)
    if volume.show_popup then
        awful.screen.focused().volume_popup.visible = true
        widget_value.text = volume.value .. "%"
        if volume.muted then
            widget_progress.value = 0
        else
            widget_progress.value = volume.value
        end
        widget_icon.image = volume.image
        hide_popup:again()
    end
end)