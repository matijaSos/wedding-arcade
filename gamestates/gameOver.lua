Gamestate = require 'libs.hump.gamestate'

local gameOver = {}

function gameOver:enter(from)
    self.from = from -- record previous state
end

function gameOver:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()

    -- overlay with gameOver message
    love.graphics.setColor(0,0,0, 0.7)
    love.graphics.rectangle('fill', 0,0, w, h)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('GAME OVER', 0, h/2, w, 'center')
end

--[[
function gameOver:keypressed(key)
    if key == 'p' then
        return Gamestate.pop() -- return to previous state
    end
end
--]]

return gameOver
