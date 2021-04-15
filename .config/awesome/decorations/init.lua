--[[
    
Copyright (c) 2020 mut-ex <https://github.com/mut-ex>

The following code is a derivative work of the code from the awesome-wm-nice project 
(https://github.com/mut-ex/awesome-wm-nice/), which is licensed MIT. This code therefore 
is also licensed under the terms of the MIT License

]]--

local beautiful = require("beautiful")
local get_colors = require("lib.border_colors")

local add_decorations = function(client)
    local client_color = beautiful.bg_normal or "#000000"
    local args = get_colors(client_color)

    if client.class == "firefox" or client.class == "Spotify" then
        require("decorations.top-alt")(client, args)
    else
        require("decorations.top")(client, args)
    end
    
    require("decorations.left")(client, args)
    require("decorations.right")(client, args)
    require("decorations.bottom")(client, args)

    -- Clean up
    collectgarbage("collect")
end

client.connect_signal("request::titlebars", function(client)
    add_decorations(client)
end)