
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local utils = require("evil.network.utils")
local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/network/"

-- State
local network_mode = "wifi"
local reconnecting = false
local active = false

-- Emit
local emit_network = function(network_mode, network_name, icon, message)
    awesome.emit_signal("evil::network", {
        network_mode = network_mode,
        network_name = network_name,
        image = icon,
        message = message
    })
end

-- Disconnected:
-- Notify the connection was lost, based off network_mode: wireless or wired
local handle_disconnected = function()
    active = false
    if network_mode == "wifi" then
        if not reconnecting then
            local icon =  icon_path .. "wifi-strength-off.svg"
            reconnecting = true
            naughty.notification({
                title = "Connection Disconnected",
                message = "Wi-Fi network has been disconnected",
                icon = icon
            })

            emit_network("None", "No connection", icon)
        end
    elseif network_mode == "wired" then
        if not reconnecting then
            reconnecting = true
            naughty.notification({
                title = "Connection Disconnected",
                message = "Ethernet network has been disconnected"
            })
        end
    end
end

-- Wired
-- Notify wired connection up
-- Check internet health with ping
-- Emit connection status

-- Wireless
-- Notify wireless connection up
-- Query wifi strength
-- Emit connection status
local check_wireless = function(name)
    utils.check_internet(function(healthy)
        if healthy then
            if reconnecting then
                reconnecting = false
                naughty.notification({
                    title = "Wi-Fi connected",
                    message = "Wi-Fi network has been connected",
                    icon = icon_path .. "wifi-strength-4.svg"
                })
            end
            utils.get_wifi_strength(function(strength)
                local strength_rounded = math.floor(strength / 25 * 0.5)
                emit_network("Wifi", name or "None", icon_path .. "wifi-strength-" .. strength_rounded .. ".svg")
            end)
        else
            emit_network("Wifi", "No connection", icon_path .. "wifi-strength-alert.svg")
        end
    end)
end

-- Check network mode: disconnected, wired, wireless
local check_network_mode = function()
    utils.get_network_info(function(mode, status)
        if mode == nil then
            -- No internet, show disconnected
            handle_disconnected()
        else
            active = true
            network_mode = mode
            if mode == "wifi" then
                check_wireless(status)
            end
        end
    end)
end

-- Timer to update network
gears.timer {
    timeout = 5, -- 5 seconds
    autostart = true,
    call_now = true,
    callback = function()
        check_network_mode()
    end
}

-- Default to loading
emit_network("Wifi", "", icon_path .. "wifi-strength-4.svg")

awesome.connect_signal("evil::network::toggle", function()
    if active then
        naughty.notification({
            title = "Networking",
            message = "Disabling networking...",
            icon = icon_path .. "wifi-strength-off.svg"
        })
        utils.disable_networking(function(result)
            if result == "done" then
            end
        end)
    else
        emit_network(
            "Wifi", 
            "No connection", 
            icon_path .. "wifi-strength-alert.svg",
            "Connecting..."
        )
        naughty.notification({
            title = "Networking",
            message = "Enabling networking...",
            icon = icon_path .. "wifi-strength-4.svg"
        })
        utils.enable_networking(function(result)
            if result == "done" then
            end
        end)
    end
end)