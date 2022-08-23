Gamestate = require 'libs.hump.gamestate'
local game = require 'gamestates.game'

local menu = {}

function menu:enter()
    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 160)
    subtitleFont = love.graphics.newFont(pixelFontPath, 70)

    backgroundImg = love.graphics.newImage('assets/pixel_art_city.png')
    fillerBgImg = love.graphics.newImage('assets/sidewalk_and_sky.png')
end

function menu:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setBackgroundColor(1,1,1)

    -- Background image
    love.graphics.setColor(1, 1, 1)
    -- Central img
    local sideSpaceWidth = (w - backgroundImg:getWidth()) / 2 
    love.graphics.draw(
        backgroundImg, 
        sideSpaceWidth,
        h - backgroundImg:getHeight()
    )
    -- Filling the sides, left and right simultaneously.
    for i = 0, sideSpaceWidth / fillerBgImg:getWidth() do
        local yPos = h - fillerBgImg:getHeight()
        local xPosLeft = sideSpaceWidth - (i + 1) * fillerBgImg:getWidth()
        love.graphics.draw(fillerBgImg, xPosLeft, yPos)
        
        local xPosRight = (w - sideSpaceWidth) + i * fillerBgImg:getWidth()
        love.graphics.draw(fillerBgImg, xPosRight, yPos)
    end

    -- Title
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(titleFont)
    -- TODO(matija): came up with the y-axis number emprically, not sure how to do
    -- it properly.
    love.graphics.printf('Koom Escape', 0, h/2 - 80, w, 'center')

    -- Subtitle
    love.graphics.setFont(subtitleFont)
    love.graphics.printf('Press Space to play', 0, h/2 + 80, w, 'center')
end

function menu:keypressed(key)
    if key == 'space' then
        return Gamestate.switch(game)
    end
end


return menu
