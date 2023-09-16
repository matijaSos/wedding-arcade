local baton = require 'libs.baton.baton'

-- TODO(matija): extract control names in variables and return from this file
-- so I don't have to hardcode it across the game when checking whether
-- some control is pressed.
local inputR = baton.new {
    controls = {
        left = { 'axis:leftx-', 'button:dpleft' },
        right = { 'axis:leftx+', 'button:dpright' },
        up = { 'axis:lefty-', 'button:dpup' },
        down = { 'axis:lefty+', 'button:dpdown' },
        action = { 'button:1' },
    },
    -- Right joystick on the arcade.
    joystick = love.joystick.getJoysticks()[1]
}

local inputL = baton.new {
    controls = {
        left = { 'key:left', 'key:a', 'axis:leftx-', 'button:dpleft' },
        right = { 'key:right', 'key:d', 'axis:leftx+', 'button:dpright' },
        up = { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' },
        down = { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' },
        background1 = { 'key:1' },
        background2 = { 'key:2' },
        background3 = { 'key:3' },
        background4 = { 'key:4' },
        background5 = { 'key:5' },
        background6 = { 'key:6' },
        background7 = { 'key:7' },
        action = { 'key:space', 'button:12' },
    },
    -- Left joystick on the arcade.
    joystick = love.joystick.getJoysticks()[2]
}

return {
    right = inputR,
    left = inputL
}
