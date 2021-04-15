local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

local apply_borders = require("lib.borders")

local default_icon = "\u{f05a}"

local urgency_colors = {
    ["low"] = beautiful.fg_normal,
    ["normal"] = beautiful.fg_normal,
    ["critical"] = beautiful.red,
}

-- Template
naughty.connect_signal("request::display", function(n)
    local custom_noficiation_icon = wibox.widget {
        font = beautiful.notification_font or "Fira Mono 28",
        align = "right",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local notification_icon_widget = function(args, color, fallback)
        if args.icon then
            return wibox.widget {
                wibox.widget {
                    notification = args,
                    resize_strategy = "center",
                    widget = naughty.widget.icon,
                },
                margins = 16,
                widget = wibox.container.margin
            }
        else
            return wibox.widget {
                markup = "<span foreground='"..color.."'>"..fallback.."</span>",
                align = "center",
                valign = "center",
                widget = custom_noficiation_icon
            }
        end
    end

    local color = urgency_colors[n.urgency]
    local icon, title_visible

    icon = n.app_name ~= '' and n.app_name:sub(1,1):upper() or default_icon
    title_visible = true

    local action_widget = {
        {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                font = beautiful.font .. " 10",
                widget = wibox.widget.textbox,
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin,
        },
        forced_height = dpi(25),
        forced_width = dpi(20),
        shape = function(cr, width, height)
            geats.shape.rounded_rect(cr, width, height, dpi(4))
        end,
        widget = wibox.container.background
    }

    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            space = dpi(8),
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = action_widget,
        style = {
            underline_normal = false,
            underline_selected = true
        },
        widget = naughty.list.actions
    }

    naughty.layout.box {
        notification = n,
        type = "notification",
        position = beautiful.notification_position,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 12)
        end,
        widget_template = {
            {
                {
                    notification_icon_widget(n, color, icon),
                    forced_width = dpi(64),
                    widget = wibox.container.background
                },
                {
                    {
                        nil,
                        {
                            {
                                text = n.title,
                                font = beautiful.fontfamily["bold"] .. " 11",
                                align = "left",
                                visible = title_visible,
                                widget = wibox.widget.textbox,
                            },
                            {
                                text = n.message,
                                align = "left",
                                font = beautiful.fontfamily["medium"] .. " 10",
                                widget = wibox.widget.textbox,
                            },
                            {
                                actions,
                                visible = n.actions and #n.actions > 0,
                                layout = wibox.layout.fixed.vertical,
                                forced_width = dpi(220)
                            },
                            spacing = dpi(4),
                            layout = wibox.layout.fixed.vertical
                        },
                        nil,
                        expand = "none",
                        layout = wibox.layout.align.vertical,
                    },
                    margins = dpi(8),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            forced_height = dpi(80),
            widget = wibox.layout.fixed.horizontal,
        }
    }
end)

local notifications = {}


naughty.config.defaults['border_width'] = 0
naughty.config.defaults['margin'] = 10

-- Timeouts
naughty.config.defaults.timeout = 5 -- Seconds
naughty.config.presets.low.timeout = 2 -- Seconds
naughty.config.presets.critical.timeout = 12 -- Seconds

function notifications.notify_custom(args, notif)
    local n = notif
    if n and not n._private.is_destroyed and not n.is_expired then
        notif.title = args.title or n.title
        notif.message = args.message or notif.message
        notif.icon = args.icon or notif.icon
        notif.timeout = args.timeout or notif.timeout
    else
        n = naughty.notification(args)
    end

    return n
end

-- Custom notifications here:

return notifications