local awful = require("awful")
local watch = require("awful.widget.watch")
local gears = require("gears")
local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/volume/"

local icon = icon_path .. "volume-up.svg"

local check_volume = function(stdout, show_popup)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))

    if mute == "off" then
        icon = icon_path .. "volume-off.svg"
    elseif volume > 50 then
        icon = icon_path .. "volume-up.svg"
    elseif volume >= 5 then
        icon = icon_path ..  "volume-down.svg"
    else
        icon = icon_path .. "volume-off.svg"
    end

    awesome.emit_signal("evil::volume", {
        value = volume,
        image = icon,
        show_popup = show_popup,
        muted = mute == "off"
    })
end

watch("amixer -D pulse sget Master", 1, function(_, stdout, _, _, _)
    check_volume(stdout)
end, nil)

-- Default to normal volume icon
awesome.emit_signal("evil::volume", {
    value = 0,
    image = icon
})

awesome.connect_signal("evil::volume::update", function(update)
    if update.type == "specific" then
        awful.spawn.with_shell('amixer -D pulse sset Master ' .. update.value .. "% on > /dev/null")

        if update.value == 0 then
            awful.spawn.with_shell("amixer -D pulse sset Master off > /dev/null")
        end
    elseif update.type == "delta" then
        local direction = "+"
        if update.value < 0 then
            direction = "-"
        end
        local delta = math.abs(update.value)
        awful.spawn.with_shell('amixer -D pulse sset Master ' .. delta .. "%" .. direction .. " on > /dev/null")
        awesome.emit_signal("evil::volume::set")
    end

end)

awesome.connect_signal("evil::volume::set", function(volume)
    awful.spawn.easy_async_with_shell("amixer -D pulse sget Master", function(stdout)
        check_volume(stdout, volume.show_popup)
    end)
end)