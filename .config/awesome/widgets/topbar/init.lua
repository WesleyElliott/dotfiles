local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local naughty = require("naughty")

local color = beautiful.bg_normal

local widget = function(inner_widget)
    return wibox.widget {
        widget = wibox.container.margin,
        top = dpi(beautiful.bar_item_padding + 2),
        bottom = dpi(beautiful.bar_item_padding + 2),
        left = dpi(6),
        right = dpi(6),
        {
            inner_widget,
            layout = wibox.layout.fixed.horizontal
        }
    }
end

-- Widget list
local launcher = require("widgets.topbar.launcher")
local taglist = require("widgets.topbar.taglist")
local create_layoutbox = require("widgets.topbar.layoutbox")
local create_tasklist = require("widgets.topbar.tasklist")
local systray = wibox.widget.systray()
local clock = wibox.widget.textclock()
clock.font = beautiful.fontfamily["normal"] .. " 12"

local widget_clock = wibox.widget {
    {
        {
            clock,
            left = dpi(8),
            right = dpi(8),
            top = dpi(2),
            bottom = dpi(2),
            widget = wibox.container.margin
        },
        bg = beautiful.bg_button,
        shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, height, width, 6)
        end,
        border_width = dpi(1),
        border_color = beautiful.border_button,
        widget = wibox.container.background
    },
    margins = dpi(6),
    widget = wibox.container.margin
}

local control_center = require("widgets.control-center")

awful.screen.connect_for_each_screen(function(screen)

    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end

    screen.topbar = awful.wibar({
        screen = screen,
        position = beautiful.bar_position,
        height = beautiful.bar_height,
        type = "dock",
        bg = color
    })

    local bar_taglist = taglist.init(screen)

    screen.topbar : setup {
        layout = wibox.layout.align.horizontal,
        spacing = dpi(10),
        expand = "none",
        {
            -- Left
            bar_taglist,
            wibox.widget {
                create_tasklist(screen),
                left = 50,
                widget = wibox.container.margin
            },
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal,
        },
        nil,    -- Middle TODO
        {
            -- Right
            create_layoutbox(screen),
            control_center,
            widget_clock,
            require("widgets.topbar.power"),
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal,
        }
    }
 end)
