local awful = require("awful")
local config = require("config.config")

local commands = {}

commands.lock = function()
    awesome.emit_signal("module::lockscreen::show")
end

commands.poweroff = function()
    awful.spawn.with_shell("poweroff")
end

commands.restart = function()
    awful.spawn.with_shell("reboot")
end

commands.sleep = function()
    awesome.emit_signal("module::lockscreen::show")
    awful.spawn.with_shell("systemctl suspend")
end

commands.logout = function()
    awesome.quit()
end

return commands