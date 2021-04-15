local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local commands = require("utils.commands")
local clickable_container = require('widgets.common.clickable-container')
local dpi = beautiful.xresources.apply_dpi

local utils = require("module.lockscreen.utils")

local locked_tag = nil
local input_password = nil

local clock_format = "<span font ='" .. beautiful.fontfamily["bold"] .. " 52'>%H:%M</span>"
local date_format = "<span font ='" .. beautiful.fontfamily["normal"] .. " 48'>%a %b %e</span>"
local clock_widget = wibox.widget.textclock(clock_format, 1)
local date_widget = wibox.widget.textclock(date_format, 1)

local widget_username = wibox.widget {
    text = "...",
    font = beautiful.fontfamily["bold"] .. " 28",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local widget_profile_image = wibox.widget {
    image = "/home/wesley/.config/awesome/icons/system/lock.svg",
    resize = true,
    forced_height = dpi(100),
    widget = wibox.widget.imagebox
}

local widget_incorrect_password = wibox.widget {
    nil,
    {
        {
            nil,
            {
                image = gears.color.recolor_image("/home/wesley/.config/awesome/icons/system/error.svg", beautiful.red),
                resize = true,
                forced_height = dpi(20),
                widget = wibox.widget.imagebox
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        {
            nil,
            {
                markup = "<span foreground='" .. beautiful.red .. "'>Incorrect Password!</span>",
                font = beautiful.fontfamily["normal"] .. " 16",
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.vertical
    },
    nil,
    expand = "none",
    opacity = 0,
    layout = wibox.layout.align.horizontal
}

local create_blank_lockscreen = function(screen)
    screen.lockscreen_extended = wibox {
        widget = {},
        visible = false,
        ontop = true,
        ontype = true,
        type = "splash",
        width = screen.geometry.width,
        height = screen.geometry.height,
        maximum_width = screen.geometry.width,
        maximum_height = screen.geometry.height,
        bg = "#1e1e1eAA",
        fg = "#ffffff",
    }
end

local create_lockscreen = function(screen)
    screen.lockscreen = wibox {
        widget = {},
        visible = false,
        ontop = true,
        type = "splash",
        width = screen.geometry.width,
        height = screen.geometry.height,
        maximum_width = screen.geometry.width,
        maximum_height = screen.geometry.height,
        bg = "#1e1e1eAA",
        fg = "#ffffff",
    }

    screen.lockscreen : setup {
        {
            {
                {
                    nil,
                    clock_widget,
                    nil,
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                {
                    nil,
                    date_widget,
                    nil,
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                spacing = dpi(5),
                layout = wibox.layout.fixed.vertical
            },  
            {
                nil,
                {
                    nil,
                    {
                        {
                            widget_profile_image,
                            widget = wibox.container.place
                        },
                        widget_username,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical
                    },
                    spacing = dpi(35),
                    layout = wibox.layout.fixed.vertical
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.vertical
            },
            widget_incorrect_password,
            layout = wibox.layout.align.vertical
        },
        top = dpi(100),
        bottom = dpi(100),
        widget = wibox.container.margin
    }
end

local auth_success = function()
    input_password = nil
    widget_incorrect_password.opacity = 0
    widget_incorrect_password:emit_signal('widget::redraw_needed')
    for s in screen do
        s.lockscreen.visible = false
    end

    if locked_tag then
        locked_tag.selected = true
        locked_tag = nil
    end
    local c = awful.client.restore()
    if c then
        c:emit_signal("request::activate")
        c:raise()
    end
    naughty.suspended = false
end

local lockscreen_grabber = awful.keygrabber {
    autostart = false,
    stop_event = "release",
    mask_event_callback = true,
    keybindings = {
        awful.key {
            modifiers = { "Mod1" },
            key = "x",
            on_press = function(self) 
                self:stop()
                auth_success()
            end
        }
    },
    keypressed_callback = function(self, mod, key, command)
        if key == "Escape" then
            input_password = nil
            return
        elseif key == "BackSpace" then
            if input_password ~= nil then
                input_password = input_password:sub(1, #input_password - 1)
            end
        end
        if #key == 1 then
            if input_password == nil then
                input_password = key
                return
            end
            widget_incorrect_password.opacity = 0
            widget_incorrect_password:emit_signal('widget::redraw_needed')
            input_password = input_password .. key
        end
    end,
    keyreleased_callback = function(self, mod, key, command)
        if key == "Return" then
            local result = utils.check_password(input_password)
            if result.authenticated then
                self:stop()
                auth_success()
            else
                input_password = nil
                widget_incorrect_password.opacity = 1
                widget_incorrect_password:emit_signal('widget::redraw_needed')
            end
        end
    end
}

local free_up_keygrab = function()
    -- Stop any other keygrabbers
    local instance = awful.keygrabber.current_instance
    if instance then
        instance:stop()
    end

    -- Unselect all tags and minimize focused client
    if client.focus then
        -- client.focus.minimized = true
    end
    for _, t in ipairs(mouse.screen.selected_tags) do
        locked_tag = t
        -- t.selected = false
    end
end

local check_lockscreen_visibility = function()
	focused = awful.screen.focused()
	if focused.lockscreen and focused.lockscreen.visible then
		return true
	end
	if focused.lockscreen_extended and focused.lockscreen_extended.visible then
		return true
	end
	return false
end

-- Check if the lockscreen is visible and prevent notifications from showing
-- naughty.connect_signal("request::display", function(_)
--     if check_lockscreen_visibility() then
--         naughty.destroy_all_notifications(nil, 1)
--     end
-- end)

awesome.connect_signal("module::lockscreen::show", function()
    naughty.suspended = true
    input_password = nil
    for s in screen do
        s.lockscreen.visible = false
    end

    free_up_keygrab()
    awful.screen.focused().lockscreen.visible = true
    lockscreen_grabber:start()
end)

screen.connect_signal("request::desktop_decoration", function(screen)
    if screen.index == 1 then
        create_lockscreen(screen)
    else
        create_blank_lockscreen(screen)
    end
end)

screen.connect_signal("removed", function(screen)
    if screen.index == 1 then
        create_lockscreen(screen)
    else
        create_blank_lockscreen(screen)
    end
end)

awesome.connect_signal("evil::system", function(system)
    widget_username.text = system.username
end)