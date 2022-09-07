local Text = require 'libs.sysl-text.example.library.slog-text'
local lume = require 'libs.lume.lume'
local hs = require 'libs.sick'
local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left
local drawBg = require 'drawMenuBackground'

local highscore = {}

function highscore:enter(from, place)
    -- TODO(matija): extract this path somewhere, I keep duplicating it.
    local pixelFontPath = 'assets/computer_pixel-7.ttf'
    self.scoreFont = love.graphics.newFont(pixelFontPath, 60)

    self.place = place

    bgAssets = drawBg.loadMenuBgAssets()

    -- Title.
    titleFont = love.graphics.newFont(pixelFontPath, 160)
    self.titleTextbox = Text.new('left',
    {
        color = {1,1,1,1},
        shadow_color = {0.5,0.5,1,0.4},
        font = titleFont
    })
    self.titleTextbox:send('[bounce=10]Hall of Fame[/bounce]', nil, true)
end

function highscore:update(dt)
    self.titleTextbox:update(dt)

    inputR:update()
    inputL:update()
    if inputL:pressed 'action' or inputR:pressed 'action' then
        local menu = require 'gamestates.menu'
        Gamestate.switch(menu)
    end
end

function highscore:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    drawBg.drawMenuBackground(bgAssets)

    love.graphics.setColor(0,0,0, 0.7)
    love.graphics.rectangle('fill', 0,0, w, h)
    love.graphics.setColor(1, 1, 1)

    local charW = self.scoreFont:getWidth('A')
    -- NOTE(matija): actual char height seems to be half of what getHeight()
    -- returns
    local charH = self.scoreFont:getHeight() / 2
    local spacingX = 2 * charW
    local spacingY = charH

    local startY = h/4

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

    -- Draw title
    self.titleTextbox:draw(
        w/2 - self.titleTextbox.get.width / 2,
        startY / 2 - self.titleTextbox.get.height / 2
    )
end

return highscore
