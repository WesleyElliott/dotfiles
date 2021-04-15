local beautiful = require("beautiful")
local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()

return {
    general = {
        modkey = "Mod4",
        altkey = "Mod1",
    },

    apps = {
       -- terminal = "gnome-terminal", --"hyper",
        terminal = "alacritty",
        browser = "chromium",
        launcher = "rofi -dpi" .. screen.primary.dpi .. " -show drun -theme " .. config_dir .. "config/rofi.rasi -icon-theme " .. beautiful.icon_theme,
        switcher = require("widgets.alt-tab"), 
    },
    auto_start = {
        'picom -b --experimental-backends --dbus --config ' .. config_dir .. '/config/picom.conf'
    }
}
