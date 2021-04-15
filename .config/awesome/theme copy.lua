
---------------------------
-- custom awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local themes_path = "~/.config/awesome/" 
local gears = require("gears")

local icon_path = "~/.config/awesome/icons/"

local theme = {}

theme.font          = "Roboto Medium 14"
theme.titlefont          = "Roboto Bold 9"
theme.fontname          = "Roboto Medium 9"

theme.fontfamily = {
    ["normal"] = "Jetbrains Mono",
    ["medium"] = "Jetbrains Mono Medium",
    ["bold"] = "Jetbrains Mono Bold",
}


theme.bg_normal     = "#1C1E26"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.bg_normal
theme.bg_minimize   = "#aaaaaa"--theme.bg_normal
theme.bg_systray    = theme.bg_normal
theme.bg_light      = "#232530"
theme.bg_very_light = "#2E303E"
theme.bg_dark       = "#1A1C23" 

theme.fg_normal     = "#dddddd"
theme.fg_dark       = "#cccccc"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.highlight = "#F43E5C"
theme.highlight_alt = "#B877DB"

theme.misc1 = "#6C6F93"
theme.misc2 = "#2f3240"
theme.transparent = "'#282A3600"

-- terminal colors
theme.blue = "#26BBD9"
theme.blue_light = "#3FC6DE"
theme.cyan = "#59E3E3"
theme.cyan_light = "#6BE6E6"
theme.green = "#29D398"
theme.green_light = "#3FDAA4"
theme.purple = "#EE64AE"
theme.purple_light = "#F075B7"
theme.red = "#E95678"
theme.red_light = "#EC6A88"
theme.yellow = "#FAB795"
theme.yellow_light = "#FBC3A7"


theme.useless_gap   = dpi(8)
theme.border_width  = dpi(0)
theme.border_normal = theme.bg_very_light
theme.border_focus  = theme.bg_very_light
theme.border_marked = theme.bg_very_light
theme.rounded_corners = true
theme.border_radius = dpi(6) -- set roundness of corners

-- title bar - regular
theme.titlebar_close_button_normal = icon_path .. "titlebar/close/close_1.png"
theme.titlebar_close_button_focus = icon_path .. "titlebar/close/close_2.png"
theme.titlebar_maximized_button_normal_inactive = icon_path.."titlebar/maximize/maximize_1.png"
theme.titlebar_maximized_button_focus_inactive  = icon_path.."titlebar/maximize/maximize_2.png"
theme.titlebar_maximized_button_normal_active = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_active  = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_minimize_button_normal = icon_path.."titlebar/minimize/minimize_1.png"
theme.titlebar_minimize_button_focus  = icon_path.."titlebar/minimize/minimize_2.png"

-- title bar - hover
theme.titlebar_close_button_normal_hover = icon_path .. "titlebar/close/close_3.png"
theme.titlebar_close_button_focus_hover = icon_path .. "titlebar/close/close_3.png"
theme.titlebar_maximized_button_normal_inactive_hover = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_inactive_hover  = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_normal_active_hover = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_active_hover  = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_minimize_button_normal_hover = icon_path.."titlebar/minimize/minimize_3.png"
theme.titlebar_minimize_button_focus_hover  = icon_path.."titlebar/minimize/minimize_3.png"

-- bar config
theme.bar_position = "top"
theme.bar_height = dpi(38)
theme.bar_item_radius = dpi(10)
theme.bar_item_padding = dpi(3)

theme.titlebar_height = dpi(28)

theme.bg_button = "#ffffff11"
theme.border_button = "#ffffff22"

return theme