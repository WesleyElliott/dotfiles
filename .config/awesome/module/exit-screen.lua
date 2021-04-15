local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local commands = require("utils.commands")
local clickable_container = require('widgets.common.clickable-container')
local dpi = beautiful.xresources.apply_dpi

local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/system/"

local widget_username = wibox.widget {
    text = "...",
    font = beautiful.fontfamily["bold"] .. " 28",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local widget_profile_image = wibox.widget {
    image = "/home/wesley/.config/awesome/icons/logo_arch.svg",
    resize = true,
    forced_height = dpi(100),
    widget = wibox.widget.imagebox
}

local build_option_button = function(text, icon, callback)
    local button_label = wibox.widget {
        text = text,
        font = beautiful.fontfamily["normal"] .. " 12",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local button = wibox.widget {
        {
            {
                {
                    {
                        image = icon,
                        widget = wibox.widget.imagebox
                    },
                    margins = dpi(8),
                    widget = wibox.container.margin
                },
                bg = beautiful.bg_button,
                widget = wibox.container.background
            },
            shape = gears.shape.circle,
            forced_width = dpi(64),
            forced_height = dpi(64),
            widget = clickable_container
        },
        left = dpi(24),
        right = dpi(24),
        widget = wibox.container.margin
    }

    local item = wibox.widget {
        button,
        button_label,
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical
    }

    item:connect_signal("button::release", function()
        callback()
    end)

    return item
end

local command_wrapper = function(command)
    return function()
        awesome.emit_signal("system::exit-screen::hide")
        command()
    end
end


local poweroff = build_option_button("Shutdown", icon_path .. "power.svg", command_wrapper(commands.poweroff))
local restart = build_option_button("Restart", icon_path .. "restart.svg", command_wrapper(commands.restart))
local sleep = build_option_button("Sleep", icon_path .. "sleep.svg", command_wrapper(commands.sleep))
local logout = build_option_button("Logout", icon_path .. "logout.svg", command_wrapper(commands.logout))
local lock = build_option_button("Lock", icon_path .. "lock.svg", command_wrapper(commands.lock))

local create_exit_screen = function(screen)
    screen.exit_screen = wibox {
        widget = {},
        type = "splash",
        visible = false,
        ontop = true,
        bg = "#1e1e1eAA",
        fg = "#ffffff",
        height = screen.geometry.height,
        width = screen.geometry.width,
        maximum_height = screen.geometry.height,
        maximum_width = screen.geometry.width,
        minimum_height = screen.geometry.height,
        minimum_width = screen.geometry.width,
        placement = awful.placement.center,
        x = screen.geometry.x,
        y = screen.geometry.y
    }

    screen.exit_screen : setup {
        nil,
        {
            {
                nil,
                {
                    {
                        widget_profile_image,
                        widget = wibox.container.place
                    },
                    widget_username,
                    spacing = dpi(5),
                    layout = wibox.layout.fixed.vertical
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            {
                nil,
                {
                    {
                        {
                            poweroff,
                            restart,
                            sleep,
                            logout,
                            lock,
                            layout = wibox.layout.fixed.horizontal
                        },
                        spacing = dpi(30),
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = dpi(30),
                    widget = wibox.container.margin
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.layout.align.vertical
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.vertical,
    }
end

screen.connect_signal("request::desktop_decoration", function(screen)
    create_exit_screen(screen)
end)

screen.connect_signal("removed", function(screen)
    create_exit_screen(screen)
end)

local exit_screen_grabber = awful.keygrabber {
    autostart = false,
    stop_event = "release",
    keypressed_callback = function(self, mod, key, command)
        if key == "s" then
            -- Suspend
            command_wrapper(commands.sleep)()
        elseif key == "e" then
            -- Logout
            command_wrapper(commands.logout)()
        elseif key == "l" then
            -- Lock
            command_wrapper(commands.lock)()
        elseif key == "p" then
            -- Shutdown
            command_wrapper(commands.poweroff)()
        elseif key == "r" then
            -- Reboot
            command_wrapper(commands.restart)()
        elseif key == "Escape" or key == "q" or key == "x" then
            awesome.emit_signal("system::exit-screen::hide")
        end
    end
}

awesome.connect_signal("system::exit-screen::show", function()
    for s in screen do
        s.exit_screen.visible = false
    end

    awful.screen.focused().exit_screen.visible = true
    exit_screen_grabber:start()
end)

awesome.connect_signal("system::exit-screen::hide", function()
    exit_screen_grabber:stop()
    for s in screen do
        s.exit_screen.visible = false
    end
end)

awesome.connect_signal("evil::system", function(system)
    widget_username.text = system.username
end)