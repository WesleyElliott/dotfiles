local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local icon_path = gears.filesystem.get_configuration_dir() .. "/icons/battery/"

local upower_battery_cmd = "upower -i $(upower -e | grep BAT)"

local notification

local last_battery_check = 0 -- os.time() - 5000
local warning_displayed = false

local icon = icon_path .. "battery.svg"

local update_battery = function(status)
    awful.spawn.easy_async_with_shell(upower_battery_cmd .. " | grep percentage | awk '{print $2}' | tr -d '\n%'", function(stdout)
        local battery_percentage = tonumber(stdout)

        local icon_state = icon_path .. "battery-discharging-"
        if status == "charging" then
            icon_state = icon_path .. "battery-charging-"
        end

        -- Check if discharging, charging, fully-charged
        if status == "fully-charged" then
            icon = icon_path .. "battery-fully-charged.svg"
        elseif battery_percentage >= 0 and battery_percentage < 15 and not status == "carging" then
            -- Critical levels
            icon = icon_path .. "battery-alert.svg"
            -- Only notify if we haven't done so in the last 5 minutes
            if os.difftime(os.time(), last_battery_check) > 300 or not warning_displayed or battery_percentage < 3 then
                last_battery_check = os.time()
                warning_displayed = true

                require("naughty").notification({
                    app_name = "battery",
                    icon = icon_path .. "battery-alert-red.svg",
                    title = "Battery may run out soon!",
                    message = battery_percentage.."% remaining",
                    urgency = "critical"
                })
            end
        elseif battery_percentage < 20 then
            icon = icon_state .. "20.svg"
        elseif battery_percentage < 30 then
            icon = icon_state .. "30.svg"
        elseif battery_percentage < 40 then
            icon = icon_state .. "40.svg"
        elseif battery_percentage < 50 then
            icon = icon_state .. "50.svg"
        elseif battery_percentage < 60 then
            icon = icon_state .. "60.svg"
        elseif battery_percentage < 70 then
            icon = icon_state .. "70.svg"
        elseif battery_percentage < 80 then
            icon = icon_state .. "80.svg"
        elseif battery_percentage < 90 then
            icon = icon_state .. "90.svg"
        elseif battery_percentage < 100 then
            icon = icon_state .. "100.svg"
        else
            icon = icon_path .. "battery.svg"
        end

        awesome.emit_signal("evil::battery", {
            value = battery_percentage,
            image = icon,
            status = status
        })
    end)
end

watch([[
    sh -c "
    upower -i $(upower -e | grep BAT) | grep state | awk '{print $2}' | tr -d '\n'
    "
]], 10, function(widget, stdout)
    local status = stdout:gsub("%\n", "")

    update_battery(status)
end)

-- Default to normal battery icon
awesome.emit_signal("evil::battery", {
    value = 0,
    image = icon,
    status = "discharging"
})
