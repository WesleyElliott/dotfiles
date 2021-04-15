local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local config = require("config.config")
local modkey = config.general.modkey

local taglist = {}
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(tag) tag:view_only() end),
    awful.button({ modkey }, 1, function(tag)
        if client.focus then
            client.focus:move_to_tag(tag)
        end
    end),

    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(tag)
        if client.focus then
            client.focus:toggle_tag(tag)
        end
    end),

    awful.button({ }, 7, function(tag) awful.tag.viewnext(tag.screen) end),
    awful.button({ }, 6, function(tag) awful.tag.viewprev(tag.screen) end)
)

local markup = function(tag) return "<span foreground='#aaaaaa'>  "..tag.name.."  </span>" end
local markup_hover = function(tag) return "<span foreground='#ffffff'>  "..tag.name.."  </span>" end

local update_tag = function(item, tag, index, _)
    local selected_indicator = item:get_children_by_id("selected_indicator")[1]
    local textbox = item:get_children_by_id("text_tag")[1]
    local textbg = item:get_children_by_id("text_bg")[1]

    local has_clients = #tag:clients() > 0

    if has_clients then
        selected_indicator.visible = true
    else
        selected_indicator.visible = false
    end

    if tag.selected then
        textbg.bg = beautiful.border_button
        textbox.markup = markup_hover(tag)
    else
        textbg.bg = beautiful.transparent
        textbox.markup = markup(tag)
    end
end

taglist.init = function(screen)
    local taglist = awful.widget.taglist {
        screen = screen,
        buttons = taglist_buttons,
        filter = awful.widget.taglist.filter.all,
        widget_template = {
            {
                nil,
                {
                    {
                        {
                            font = "FontAwesome 14",
                            id = "text_tag",
                            widget = wibox.widget.textbox
                        },
                        id = "text_bg",
                        shape = function(cr, width, height)
                            gears.shape.rounded_rect(cr, width, height, dpi(5))
                        end,
                        widget = wibox.container.background
                    },
                    widget = wibox.container.margin,
                    top = 4,
                    left = 4,
                    right = 4,
                },
                {
                    {
                        {
                            id = "selected_indicator",
                            bg = beautiful.red,
                            widget = wibox.container.background
                        },
                        forced_height = 2,
                        widget = wibox.container.background,
                    },
                    left = 10,
                    right = 10,
                    top = 4,
                    layout = wibox.container.margin,
                },
                layout = wibox.layout.align.vertical
            },
            top = 2,
            bottom = 2,
            widget = wibox.container.margin,
            create_callback = function(item, tag, index, _)
               update_tag(item, tag, index) 
            end,
            update_callback = update_tag
        }
    }

    local container = wibox.widget {
        taglist,
        spacing = 6,
        layout = wibox.layout.fixed.horizontal,
    }

    return container
end

return taglist