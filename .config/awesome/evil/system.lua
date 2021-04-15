local awful = require("awful")
local watch = require("awful.widget.watch")
local naughty = require("naughty")
local gears = require("gears")

awful.spawn.easy_async_with_shell("{ whoami ; hostname }", function(stdout)
    local t = {}
    for chunk in string.gmatch(stdout, "[^\n]+") do
        t[#t+1] = chunk
    end
    
    awesome.emit_signal("evil::system", {
        username = t[1]:gsub("^%l", string.upper),
        hostname = t[2]
    })
end)