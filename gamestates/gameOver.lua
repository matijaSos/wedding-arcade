Gamestate = require 'libs.hump.gamestate'
lume = require 'libs.lume.lume'
highscore = require 'libs.sick'

local gameOver = {}
local scoreAchieved

function gameOver:enter(from, score)
    self.from = from -- record previous state
    scoreAchieved = score

    highscore.add('matija', score)
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
    love.graphics.printf(
        'Score: ' .. tostring(lume.round(scoreAchieved)),
        0, h/2 + 40, w, 'center'
    )

    for i, score, name in highscore() do
        love.graphics.print(name, 400, h/2 + 40 + i * 40)
        love.graphics.print(score, 500, h/2 + 40 + i * 40)
    end
end

--[[
function gameOver:keypressed(key)
    if key == 'p' then
        return Gamestate.pop() -- return to previous state
    end
end
--]]

return gameOver
