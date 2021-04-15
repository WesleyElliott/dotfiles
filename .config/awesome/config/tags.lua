local awful = require("awful")

-- Setup tags for each screen
awful.screen.connect_for_each_screen(function(screen)
    -- Set home tag to always be floating
    awful.tag.add("\u{f015}", {
        screen = screen, 
        layout = awful.layout.suit.float
    })

    awful.tag({"\u{f268}", "\u{f120}"}, screen, awful.layout.suit.tile)

    awful.tag.add("\u{f121}", {
        screen = screen,
        layout = awful.layout.suit.float,
        gal_single_client = false,
        gap = 0
    })
end)
