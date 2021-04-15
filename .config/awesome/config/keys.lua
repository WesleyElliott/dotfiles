local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local config = require("config.config")

local modkey = config.general.modkey
local altkey = config.general.altkey
local keys = {}

-- Not sure I want this yet?
keys.globalbuttons = gears.table.join(
    awful.button({ }, 1, function ()
        awesome.emit_signal("evil::dismiss-popups")
    end)
)

keys.globalkeys = gears.table.join(
    -- Awesome keys
    awful.key({ modkey }, "s", hotkeys_popup.show_help, {
        description = "Show help", group = "awesome"
    }),
    awful.key({ modkey, "Control" }, "r", awesome.restart, {
        description="Restart awesome", group="awesome"
    }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, {
        description="Quite awesome", group="awesome"
    }),

    awful.key({ modkey }, "l", function()
        -- awesome.emit_signal("module::lockscreen::show")
        awful.layout.inc(1)
    end, {
        description="Lock", group="system"
    }),

    -- Tag keys
    awful.key({ modkey }, "Left", awful.tag.viewprev, {
        description="View previous", group="tag"
    }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, {
        description="View next", group="tag"
    }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, {
        description="Go back", group="tag"
    }),
    
    -- Client focus
    -- TODO: Use app switcher from https://github.com/arndtphillip/dotfiles
    awful.key({ altkey }, "Tab",
      function ()
          config.apps.switcher.switch( 1, "Mod1", "Alt_L", "Shift", "Tab")
      end),
    
    awful.key({ altkey, "Shift" }, "Tab",
      function ()
          config.apps.switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
      end),

    -- Layout
    awful.key({ modkey, "Shift" }, "Left", function() awful.client.swap.byidx(-1) end, {
        description="Swap with previous client", group="client"
    }),
    awful.key({ modkey, "Shift" }, "Right", function() awful.client.swap.byidx(1) end, {
        description="Swap with next client", group="client"
    }),

    -- Apps
    awful.key({ modkey }, "Return", function() awful.util.spawn(config.apps.terminal) end, {
        description="Launch terminal", group="apps"
    }),
    awful.key({ altkey }, "space", function() awful.util.spawn(config.apps.launcher) end, {
        description="Launch app launcher", group="apps"
    }),

    -- TODO add function buttons for brightness, volume, media etc
    -- Media controls
    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn.easy_async_with_shell("amixer -D pulse sset Master 5%- 1+ on", function(stdout)
            awesome.emit_signal("evil::volume::set", {show_popup = true})
        end)
    end),
    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn.easy_async_with_shell("amixer -D pulse sset Master 5%+ 1+ on", function(stdout)
            awesome.emit_signal("evil::volume::set", {show_popup = true})
        end)
    end),
    awful.key({}, "XF86AudioMute", function ()
        awful.spawn.easy_async_with_shell("amixer -D pulse set Master 1+ toggle", function(stdout)
            awesome.emit_signal("evil::volume::set", {show_popup = true})
        end)
    end),

    awful.key({ modkey, altkey,           }, "Right",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, altkey,           }, "Left",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),

    -- Brightness
   awful.key({ }, "XF86MonBrightnessDown", function ()
        awesome.emit_signal("evil::brightness::update", {
            type = "delta",
            value = -10,
            show_popup = true,
            emit = true
        })
    end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awesome.emit_signal("evil::brightness::update", {
            type = "delta",
            value = 10,
            show_popup = true,
            emit = true
        })
    end)
)

-- Bind numbers to tags
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys, 
        -- View tag
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, {
            description="View tag #" .. i, group="tag"
        }),

        -- Move client to tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, {
            description="Move focused client to tag #" .. i, group="tag"
        })
    )
end

keys.clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(client)
        client.fullscreen = not client.fullscreen
        client:raise()
    end, {
        description="Toggle fullscreen", group="client"
    }),

    awful.key({ altkey }, "q", function(client) client:kill() end, {
        description="Close", group="client"
    })
)

keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awesome.emit_signal("evil::dismiss-popups")
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Setup global keys and buttons
root.keys(keys.globalkeys)
root.buttons(keys.globalbuttons)

return keys
