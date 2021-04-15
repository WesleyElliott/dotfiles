
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local utils = require("evil.bluetooth.utils")
local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/bluetooth/"

-- State
local show_notification = false
local active = false

-- Emit
local emit_bluetooth = function(active, icon)
    awesome.emit_signal("evil::bluetooth", {
        active = active,
        image = icon
    })
end

local check_bluetooth = function()
    utils.check_state(function(state)
        active = state
        local message = "Bluetooth disabled"
        local icon = icon_path .. "bluetooth-off.svg"
        if active then
            message = "Bluetooth enabled"
            icon = icon_path .. "bluetooth.svg"
        end

        if show_notification then
            naughty.notification({
                title = "Bluetooth",
                message = message,
                icon = icon
            })
            show_notification = false
        end

        emit_bluetooth(active, icon)
    end)
end

-- Timer to update bluetooth
gears.timer {
    timeout = 5, -- 5 seconds
    autostart = true,
    call_now = true,
    callback = function()
        check_bluetooth()
    end
}

-- Default to loading
emit_bluetooth(false, icon_path .. "bluetooth-off.svg")

awesome.connect_signal("evil::bluetooth::toggle", function()
    show_notification = true
    if active then
        naughty.notification({
            title = "Bluetooth",
            message = "Disabling bluetooth...",
            icon = icon_path .. "bluetooth-off.svg"
        })
        utils.disable_bluetooth(function(result)
            if result == "done" then
            end
        end)
    else
        naughty.notification({
            title = "Bluetooth",
            message = "Enabling bluetooth...",
            icon = icon_path .. "bluetooth.svg"
        })
        utils.enable_bluetooth(function(result)
            if result == "done" then
            end
        end)
    end
end)