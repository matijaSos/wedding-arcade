local Gamestate = require 'libs.hump.gamestate'
local Text = require 'libs.sysl-text.example.library.slog-text'

local drawBg = require 'drawMenuBackground'

local game = require 'gamestates.game'
local menuSelectPlayer = require 'gamestates.menuSelectPlayer'

local menu = {}

function menu:enter()
    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 160)
    subtitleFont = love.graphics.newFont(pixelFontPath, 70)

    bgAssets = drawBg.loadMenuBgAssets()

    -- Dancing subtitle text
    subtitleTextbox = Text.new('left',
    {
        font = subtitleFont
    })
    subtitleTextbox:send('[bounce=10]Press space to start[/bounce]', nil, true)
end

function menu:update(dt)
    subtitleTextbox:update(dt)
end

function menu:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    drawBg.drawMenuBackground(bgAssets)

    -- Title
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(titleFont)
    -- TODO(matija): came up with the y-axis number emprically, not sure how to do
    -- it properly.
    love.graphics.printf('Koom Escape', 0, h/2 - 80, w, 'center')

    -- Subtitle
    subtitleTextbox:draw(w/2 - subtitleTextbox.get.width / 2, h/2 + 80)
end

function menu:keypressed(key)
    if key == 'space' then
        return Gamestate.switch(menuSelectPlayer)
    end
end


return menu
