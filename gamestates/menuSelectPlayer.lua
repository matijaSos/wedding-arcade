Gamestate = require 'libs.hump.gamestate'

local game = require 'gamestates.game'

local menuSelectPlayer = {}

function menuSelectPlayer:enter()
    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 110)
    playerNameFont = love.graphics.newFont(pixelFontPath, 80)

    bgAssets = drawBg.loadMenuBgAssets()

    hrvojeImg = love.graphics.newImage('assets/player_hrvoje.png')
    ninaImg = love.graphics.newImage('assets/player_hrvoje.png')
    ziziImg = love.graphics.newImage('assets/player_hrvoje.png')
end

function menuSelectPlayer:update(dt)
end

function menuSelectPlayer:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    drawBg.drawMenuBackground(bgAssets)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(titleFont)
    love.graphics.printf('Choose your koom:', 0, h/4, w, 'center')

    -- Draw 3 choices - Hrvoje, Zizi, Nina
    local playerScaleFactor = 0.4
    -- TODO(matija): have a smarter way of determining this value?
    local playerNameY = h/2 + 150
    local spaceBetween = (w - 3 * hrvojeImg:getWidth() * playerScaleFactor) / 4

    -- Draw Hrvoje
    local hrvojeX = spaceBetween
    local hrvojeY = h/2 - hrvojeImg:getHeight() * playerScaleFactor / 2 
    drawPlayerAndName(hrvojeImg, playerScaleFactor, hrvojeX, hrvojeY, "Hrvoje", playerNameY)

    -- Draw Nina
    local ninaX = spaceBetween * 2 + hrvojeImg:getWidth() * playerScaleFactor 
    local ninaY = h/2 - ninaImg:getHeight() * playerScaleFactor / 2
    drawPlayerAndName(ninaImg, playerScaleFactor, ninaX, ninaY, "Nina", playerNameY)

    -- Draw Zizi
    local ziziX = spaceBetween * 3 + hrvojeImg:getWidth() * playerScaleFactor + ninaImg:getWidth() * playerScaleFactor
    local ziziY = h/2 - ziziImg:getHeight() * playerScaleFactor / 2
    drawPlayerAndName(ziziImg, playerScaleFactor, ziziX, ziziY, "Zizi", playerNameY)
end

function drawPlayerAndName (img, scaleFactor, imgX, imgY, name, nameY)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(img,
        imgX, imgY, 
        0, 
        scaleFactor, scaleFactor
    )

    love.graphics.setColor(0, 0, 0)
    local nameText = love.graphics.newText(playerNameFont, name)
    love.graphics.draw(nameText,
        imgX + img:getWidth() * scaleFactor / 2 - nameText:getWidth() / 2,
        nameY
    )

end

function menuSelectPlayer:keypressed(key)
    if key == 'space' then
        return Gamestate.switch(game)
    end
end

return menuSelectPlayer
