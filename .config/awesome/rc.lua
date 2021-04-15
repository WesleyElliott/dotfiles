--[[
    Awesome WM Config
    Author: Wesley Elliott
    License: MIT
    Repo: https://github.com/WesleyElliott/dotfiles
]]

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

require("awful.autofocus")

-- Initialize error handling
require("config.error-handling")

-- Initialize theme
beautiful.init(awful.util.getdir("config") .. "theme.lua")

-- Modules
require("module.exit-screen")
require("module.lockscreen")

-- Initialize config
require("config.layout")
require("config.rules")
require("config.tags")
require("config.keys")

-- Initialize titlebar decorations
require("decorations")

-- Initialize topbar widgets
require("widgets.topbar")

require("widgets.popup")

-- Initialize daemons (evil)
require("evil")

-- Initialize notifications
require("widgets.notifications")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Start autorun apps
require("module.auto-start")