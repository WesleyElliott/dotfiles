local awful = require("awful")
local beautiful = require("beautiful")

local keys = require("config.keys")

rules = {
    -- All clients
    { 
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_color,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- Floating clients
    {
        rule_any = {
            instance = {},
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "feh",
            },
            name = {
                "Event Tester", -- xev
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up"
            }
        },
        properties = {
            floating = true
        }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { 
            type = { "normal", "dialog "}
        },
        properties = {
            titlebars_enabled = true
        }
    },

    -- Jetbrains
    {
        rule = {
            class = "jetbrains-.*",
            instance = "sun-awt-X11-XwindowPeer",
            name = "win.*"
        },
        properties = {
            floating = true,
            focus = true,
            focusable = false,
            ontop = true,
            placement = awful.placement.restore,
            buttons = {},
            titlebars_enabled = false
        },
    },
    {
        rule = {
            class = "jetbrains-.*",
            name = "win.*"
        },
        properties = {
            floating = true,
            titlebars_enabled = false
        },
    },

    -- Spotify
    {
        rule = {
            class = "Spotify"
        },
        properties = {
            maximized = true
        }
    }
}

awful.rules.rules = rules