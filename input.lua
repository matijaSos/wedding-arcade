local baton = require 'libs.baton.baton'

Control = {
    left = "left",
    right = "right",
    up = "up",
    down = "down",
    action = "action",
}
for i = 1, 8 do
    Control['background' .. i] = 'background' .. i
end

-- do the same thing but while initializing the map
local rightControls = {
    [Control.right] = { 'axis:0+', 'button:dpright' },
    [Control.left] = { 'axis:0-', 'button:dpleft' },
    -- [Control.up] = { 'axis:1y-', 'button:dpup' },
    -- [Control.down] = { 'axis:y+', 'button:dpdown' },
    [Control.action] = { 'button:1' }
}

local inputR = baton.new {
    controls = rightControls,
    -- Right joystick on the arcade.
    joystick = love.joystick.getJoysticks()[1]
}

local leftControls = {
    [Control.left] = { 'key:left', 'key:a', 'axis:1-', 'button:dpleft' },
    [Control.right] = { 'key:right', 'key:d', 'axis:1+', 'button:dpright' },
    [Control.up] = { 'key:up', 'key:w', 'axis:2-', 'button:dpup' },
    [Control.down] = { 'key:down', 'key:s', 'axis:2+', 'button:dpdown' },
    [Control.action] = { 'key:space', 'button:12' }
}
-- handle backgrounds with a for loop
for i = 1, 8 do
    leftControls[Control["background" .. i]] = { 'key:' .. i }
end


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
