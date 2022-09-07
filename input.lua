local baton = require 'libs.baton.baton'

-- TODO(matija): extract control names in variables and return from this file
-- so I don't have to hardcode it across the game when checking whether
-- some control is pressed.
local input = baton.new {
    controls = {
        left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
        action = {'key:space', 'button:1'},
    },
    joystick = love.joystick.getJoysticks()[1]
}

return input
