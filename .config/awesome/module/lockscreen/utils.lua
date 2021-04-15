local awful = require("awful")
local gears = require('gears')
local naughty = require("naughty")
local filesystem = gears.filesystem
local config_dir = filesystem.get_configuration_dir()
package.cpath = package.cpath .. ';' .. config_dir .. '/library/?.so;' .. '/usr/lib/lua-pam/?.so;'

local functions = {}

functions.check_module = function(module)
    if package.loaded[module] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(module)
            if type(loader) == "function" then
                package.preload[module] = loader
                return true
            end
        end
        return false
    end
end

functions.check_password = function(password)
    local auth_result = false
    if password ~= nil then
        if functions.check_module('liblua_pam') then
            -- Return true for now
            local pam = require('liblua_pam')
            auth_result = pam:auth_current_user(password)
            return {
                authenticated = auth_result
            }
        else
            -- PAM integration not found, install liblua_pam!
            naughty.notification({
                app_name = "System",
                title = "WARNING",
                message = "You don't have PAM properly configured, no password required!",
                urgency = "critical"
            })

            return {
                authenticated = true
            }
        end
    end
    return {
        authenticated = false
    }
end

return functions