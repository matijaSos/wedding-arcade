Gamestate = require 'libs.hump.gamestate'

local game = require 'gamestates.game'

local menuSelectPlayer = {}

local HRVOJE = 'hrvoje'
local NINA = 'nina'
local ZIZI = 'zizi'
local availablePlayers = { HRVOJE, NINA, ZIZI }

selectedPlayerIdx = 1

function menuSelectPlayer:enter()
    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 110)
    playerNameFont = love.graphics.newFont(pixelFontPath, 80)

    bgAssets = drawBg.loadMenuBgAssets()

    hrvojeImg = love.graphics.newImage('assets/player_hrvoje.png')
    ninaImg = love.graphics.newImage('assets/player_nina.png')
    ziziImg = love.graphics.newImage('assets/player_zizi.png')

    selectionPointer = love.graphics.newImage('assets/red_arrow.png')
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
    local hrvojeScaleFactor = 0.4
    -- TODO(matija): have a smarter way of determining this value?
    local playerNameY = h/2 + 150
    local spaceBetween = (w - 3 * hrvojeImg:getWidth() * hrvojeScaleFactor) / 4

    -- Draw Hrvoje
    local hrvojeX = spaceBetween
    local hrvojeY = h/2 - hrvojeImg:getHeight() * hrvojeScaleFactor / 2 
    drawPlayerAndName(hrvojeImg, hrvojeScaleFactor, hrvojeX, hrvojeY, "Hrvoje", playerNameY, availablePlayers[selectedPlayerIdx] == HRVOJE)

    -- Draw Nina
    local ninaScaleFactor = 0.4
    local ninaX = spaceBetween * 2 + hrvojeImg:getWidth() * hrvojeScaleFactor 
    local ninaY = h/2 - ninaImg:getHeight() * ninaScaleFactor / 2
    drawPlayerAndName(ninaImg, ninaScaleFactor, ninaX, ninaY, "Nina", playerNameY, availablePlayers[selectedPlayerIdx] == NINA)

    -- Draw Zizi
    local ziziScaleFactor = 0.35
    local ziziX = spaceBetween * 3 + hrvojeImg:getWidth() * hrvojeScaleFactor + ninaImg:getWidth() * ninaScaleFactor
    local ziziY = h/2 - ziziImg:getHeight() * ziziScaleFactor / 2
    drawPlayerAndName(ziziImg, ziziScaleFactor, ziziX, ziziY, "Zizi", playerNameY, availablePlayers[selectedPlayerIdx] == ZIZI)
end

function drawPlayerAndName (img, scaleFactor, imgX, imgY, name, nameY, isSelected)
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

    if isSelected then
        love.graphics.setColor(1, 1, 1)
        local pointerScaleFactor = 0.15
        love.graphics.draw(selectionPointer,
            imgX + img:getWidth() * scaleFactor / 2 - selectionPointer:getWidth() * pointerScaleFactor / 2,
            imgY - selectionPointer:getHeight() * pointerScaleFactor - 20,
            0, pointerScaleFactor, pointerScaleFactor
        )
    end
end

function menuSelectPlayer:keypressed(key)
    if key == 'space' then
        return Gamestate.switch(game)
    end
    if key == 'right' then
        selectedPlayerIdx = selectedPlayerIdx + 1
        if selectedPlayerIdx > 3 then selectedPlayerIdx = 1 end
    end
    if key == 'left' then
        selectedPlayerIdx = selectedPlayerIdx - 1
        if selectedPlayerIdx < 1 then selectedPlayerIdx = 3 end
    end
end

return menuSelectPlayer
