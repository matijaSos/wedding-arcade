local lume = require 'libs.lume.lume'
local hs = require 'libs.sick'

local highscore = {}

function highscore:enter(from, place)
    -- TODO(matija): extract this path somewhere, I keep duplicating it.
    local pixelFontPath = 'assets/computer_pixel-7.ttf'
    self.scoreFont = love.graphics.newFont(pixelFontPath, 60)

    self.place = place
end

function highscore:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(0,0,0, 0.7)
    love.graphics.rectangle('fill', 0,0, w, h)

    love.graphics.setColor(1, 1, 1)

    local charW = self.scoreFont:getWidth('A')
    -- NOTE(matija): actual char height seems to be half of what getHeight()
    -- returns
    local charH = self.scoreFont:getHeight() / 2
    local spacingX = 2 * charW
    local spacingY = charH

    local startY = 0

    local placeW = 4 * charW
    local nameW = 7 * charW
    local scoreW = 6 * charW

    local placeX = (w - (placeW + nameW + scoreW + 2 * spacingX)) / 2
    local nameX = placeX + placeW + spacingX
    local scoreX = nameX + nameW + spacingX

    for i, score, name in hs() do
        local y = startY + (i - 1) * (charH + spacingY)

        love.graphics.setColor(1, 1, 1)
        if self.place and i == self.place then
            love.graphics.setColor(1, 1, 0) -- Yellow
        end

        love.graphics.print('#' .. i, self.scoreFont, placeX, y)
        love.graphics.print(name, self.scoreFont, nameX, y)
        love.graphics.print(lume.round(score) .. 'm', self.scoreFont, scoreX, y)
    end
end

function highscore:keypressed(key)
    if key == 'space' then
        local menu = require 'gamestates.menu'
        Gamestate.switch(menu)
    end
end

return highscore
