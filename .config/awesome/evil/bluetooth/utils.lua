local awful = require("awful")

local functions = {}

functions.check_state = function(callback)
    awful.spawn.easy_async_with_shell(
        "rfkill list bluetooth",
        function(stdout)
            if stdout:match("Soft blocked: yes") then
                callback(false)
            else
                callback(true)
            end
        end
    )
end

functions.enable_bluetooth = function(callback)
    local cmd = [[
        rfkill unblock bluetooth
        sleep 1
        bluetoothctl power on
    ]]
    callback("enabling")
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        callback("done")
    end)
end

functions.disable_bluetooth = function(callback)
    local cmd = [[
        bluetoothctl power off
        rfkill block bluetooth
    ]]
    callback("disabling")
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        callback("done")
    end)
end

return functions