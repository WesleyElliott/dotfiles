local wibox = require("wibox")
local beautiful = require("beautiful")

local create_click_events = function(widget)
    local container = wibox.widget {
        widget,
        widget = wibox.container.background
    }

    local old_cursor, old_wibox
    container:connect_signal("mouse::enter", function()
        container.bg = beautiful.groups_bg
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)

    container:connect_signal("mouse::leave", function()
        container.bg = beautiful.leave_event
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    return container
end

return create_click_events