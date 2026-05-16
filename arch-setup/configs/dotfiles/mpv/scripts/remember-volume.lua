local mp = require 'mp'
local utils = require 'mp.utils'

local volume_file = os.getenv("HOME") .. "/.config/mpv/last_volume"

-- Load saved volume
local f = io.open(volume_file, "r")
if f then
    local vol = tonumber(f:read("*all"))
    if vol then
        mp.set_property("volume", vol)
    end
    f:close()
end

-- Save volume on change
mp.observe_property("volume", "number", function(name, value)
    if value then
        local f = io.open(volume_file, "w")
        if f then
            f:write(tostring(value))
            f:close()
        end
    end
end)
