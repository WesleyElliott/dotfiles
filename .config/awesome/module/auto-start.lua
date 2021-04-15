local awful = require("awful")
local naughty = require("naughty")
local config = require("config.config")
local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()

local run_once = function(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end

    awful.spawn.easy_async_with_shell(
        string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd),
        function(stdout, stderr)
            if not stderr or stderr == "" then
                return
            end
            naughty.notification({
                app_name = "Start-up Apps",
                title = "Oops! Error starting up some apps!",
                message = stderr:gsub("%\n", ""),
                timeout = 20
            })
        end
    )
end

for _, app in ipairs(config.auto_start) do
    run_once(app)
end

-- launch auto-lock
awful.spawn.easy_async_with_shell(
    string.format("pgrep -u $USER -x %s > /dev/null || (%s)", "xidlehook", config_dir .. 'utils/autolock.sh'),
    function(stdout, stderr)
        if not stderr or stderr == "" then
            return
        end
        naughty.notification({
            app_name = "Start-up Apps",
            title = "Oops! Unable to start auto-locker",
            message = stderr:gsub("%\n", ""),
            timeout = 20
        })
    end
)