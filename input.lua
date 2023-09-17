local baton = require 'libs.baton.baton'

Control = {
    left = "left",
    right = "right",
    up = "up",
    down = "down",
    action = "action",
}
for i = 1, 7 do
    Control['background' .. i] = 'background' .. i
end

-- do the same thing but while initializing the map
local rightControls = {
    [Control.right] = { 'axis:leftx+', 'button:dpright' },
    [Control.left] = { 'axis:leftx-', 'button:dpleft' },
    [Control.up] = { 'axis:lefty-', 'button:dpup' },
    [Control.down] = { 'axis:lefty+', 'button:dpdown' },
    [Control.action] = { 'button:1' }
}

local inputR = baton.new {
    controls = rightControls,
    -- Right joystick on the arcade.
    joystick = love.joystick.getJoysticks()[1]
}

local leftControls = {
    [Control.left] = { 'key:left', 'key:a', 'axis:leftx-', 'button:dpleft' },
    [Control.right] = { 'key:right', 'key:d', 'axis:leftx+', 'button:dpright' },
    [Control.up] = { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' },
    [Control.down] = { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' },
}
-- handle backgrounds with a for loop
for i = 1, 7 do
    leftControls[Control["background" .. i]] = { 'key:' .. i }
end

leftControls.background1 = { 'key:1' }
leftControls.background2 = { 'key:2' }
leftControls.background3 = { 'key:3' }
leftControls.background4 = { 'key:4' }
leftControls.background5 = { 'key:5' }
leftControls.background6 = { 'key:6' }
leftControls.background7 = { 'key:7' }
leftControls.action = { 'key:space', 'button:12' }

-- write the above thing nicer

local inputL = baton.new {
    controls = leftControls,
    -- Left joystick on the arcade.
    joystick = love.joystick.getJoysticks()[2]
}

return {
    Control = Control,
    right = inputR,
    left = inputL
}
