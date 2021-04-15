local naughty = require("naughty")

-- Startup Error Handling
--
-- Check if Awesome encountered some errors on startup and fell
-- back to the default config.
if awesome.startup_errors then
    naughty.notification({
        preset = naughty.config.presets.critical,
        title = "Oops, there were problems during startup!",
        text = awesome.startup_errors
    })
end

-- Runtime Error Handling
-- 
-- Check for any errors during runtime and notify
do
    local handling = false
    awesome.connect_signal("debug::error", function (err)
        if (handling) then return end
        handling = true
        
        naughty.notification({
            preset = naughty.config.presets.critical,
            title = "Oops, an error occured!",
            text = tostring(err)
        })

        handling = false
    end)
end