local awful = require("awful")
local naughty = require("naughty")

local check_brightness = function(stdout, show_popup)
    local value = tonumber(string.match(string.match(stdout, "%d+%%"), "%d+"))

    awesome.emit_signal("evil::brightness", {
        value = value,
        show_popup = show_popup,
    })
end

awful.widget.watch("brightnessctl info", 1, function(_, stdout, _, _, _)
    check_brightness(stdout)
end)

awesome.connect_signal("evil::brightness::update", function(update)
    if update.type == "specific" then
        awful.spawn.with_shell('brightnessctl set ' .. update.value .. "% > /dev/null")
    elseif update.type == "delta" then
        local direction = "+"
        if update.value < 0 then
            direction = "-"
        end
        local delta = math.abs(update.value)
        awful.spawn.with_shell('brightnessctl set ' .. delta .. "%" .. direction .. " > /dev/null")
    end
    if update.emit then
        awful.spawn.easy_async_with_shell("brightnessctl info", function(stdout)
            check_brightness(stdout, update.show_popup)
        end)
    end
end)

awesome.emit_signal("evil::brightness", {
    value = 25
})