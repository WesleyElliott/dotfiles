local awful = require("awful")

local functions = {}

--
-- Queryies the current active network interface, supporting only wifi or ethernet interfaces.
-- If there is no active interface, false is returned
-- Requires nmcli
--
functions.get_network_interface = function(callback)
    awful.spawn.easy_async_with_shell("nmcli device status | grep -E '(wifi|ethernet)' | grep '[^dis]connected' | awk '{print $1}'", function(stdout)
        if stdout == nil or stdout == "" then
            callback(false)
        else
            callback(stdout:gsub("\n", ""))
        end
    end)
end

--
-- Queries the current network mode (wifi, ethernet, disconnected)
-- Returns the mode (wifi, ethernet or nil) and the name of the network or "Disconnected"
-- Requires nmcli
--
functions.get_network_info = function(callback)
    awful.spawn.easy_async_with_shell("nmcli device status | grep -E '(wifi|ethernet)' | grep '[^dis]connected' | awk '{print $1,$2,$4}'", function(stdout)
        if (stdout == nil or stdout == "") then
            callback(nil, "Disconnected")
        else
            local interface, mode, name
            local words = {}
            for word in stdout:gsub("\n", ""):gmatch("[%w|-]+") do table.insert(words, word) end
            interface = words[1]
            mode = words[2]
            name = words[3]

            if mode == "wifi" then
                callback(mode, name)
            else
                callback(mode, "Ethernet")
            end
        end
    end)
end

--
-- Get wifi strength
--
functions.get_wifi_strength = function(callback)
    awful.spawn.easy_async_with_shell("awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless", function(stdout)
        local wifi_strength = tonumber(stdout)
        callback(wifi_strength)
    end)
end

--
-- Check the health of the internet connection
-- Returns true if all is good, false otherwise
--
functions.check_internet = function(callback)
    awful.spawn.easy_async_with_shell("ping -q -w2 -c2 1.1.1.1 | grep '100% packet loss'", function(stdout, _, _, exitcode)
        if exitcode == 1 then
            callback(true)
        else
            callback(false)
        end
    end)
end

--
-- Enable networking
--
functions.enable_networking = function(callback)
    local cmd = [[
        nmcli networking on
    ]]
    callback("enabling")
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        callback("done")
    end)
end

--
-- Disable networking
--
functions.disable_networking = function(callback)
    local cmd = [[
        nmcli networking off
    ]]
    callback("disabling")
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        callback("done")
    end)
end

return functions