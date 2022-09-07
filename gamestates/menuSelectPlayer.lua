local Gamestate = require 'libs.hump.gamestate'

local drawBg = require 'drawMenuBackground'
local game = require 'gamestates.game'
local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left

local menuSelectPlayer = {}

-- TODO(matija): extract players info in a separate file.
local HRVOJE = 'Hrvoje'
local NINA = 'Nina'
local ZIZI = 'Zizi'
-- TODO(matija): derive this list from the table below, via lume.keys()
local availablePlayersList = { HRVOJE, NINA, ZIZI }

local availablePlayers = {}
availablePlayers[HRVOJE] = {
    name = HRVOJE,
    scaleFactorInMenu = 0.4,
    imgPath = 'assets/player_hrvoje.png'
}
availablePlayers[NINA] = {
    name = NINA, 
    scaleFactorInMenu = 0.4,
    imgPath = 'assets/player_nina.png'
}
availablePlayers[ZIZI] = {
    name = ZIZI,
    scaleFactorInMenu = 0.35,
    imgPath = 'assets/player_zizi.png'
}

local selectedPlayerIdx

function menuSelectPlayer:enter()
    selectedPlayerIdx = 1

    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 110)
    playerNameFont = love.graphics.newFont(pixelFontPath, 80)

    bgAssets = drawBg.loadMenuBgAssets()

    hrvojeImg = love.graphics.newImage(availablePlayers[HRVOJE].imgPath)
    ninaImg = love.graphics.newImage(availablePlayers[NINA].imgPath)
    ziziImg = love.graphics.newImage(availablePlayers[ZIZI].imgPath)

    selectionPointer = love.graphics.newImage('assets/red_arrow.png')
end

function menuSelectPlayer:update(dt)
    inputR:update()
    inputL:update()

    if inputL:pressed 'action' or inputR:pressed 'action' then
        return Gamestate.switch(
            game, availablePlayers[availablePlayersList[selectedPlayerIdx]]
        )
    end
    if inputL:pressed 'right' then
        selectedPlayerIdx = selectedPlayerIdx + 1
        if selectedPlayerIdx > 3 then selectedPlayerIdx = 1 end
    end
    if inputL:pressed 'left' then
        selectedPlayerIdx = selectedPlayerIdx - 1
        if selectedPlayerIdx < 1 then selectedPlayerIdx = 3 end
    end

end

function menuSelectPlayer:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    drawBg.drawMenuBackground(bgAssets)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(titleFont)
    love.graphics.printf('Choose your koom:', 0, h/4, w, 'center')

     -- Draw 3 choices - Hrvoje, Zizi, Nina
    local hrvojeScaleFactor = availablePlayers[HRVOJE].scaleFactorInMenu
    -- TODO(matija): have a smarter way of determining this value?
    local playerNameY = h/2 + 150
    local spaceBetween = (w - 3 * hrvojeImg:getWidth() * hrvojeScaleFactor) / 4

    -- Draw Hrvoje
    local hrvojeX = spaceBetween
    local hrvojeY = h/2 - hrvojeImg:getHeight() * hrvojeScaleFactor / 2 
    drawPlayerAndName(hrvojeImg, hrvojeScaleFactor, hrvojeX, hrvojeY,
        HRVOJE, playerNameY,
        availablePlayersList[selectedPlayerIdx] == HRVOJE
    )

    -- Draw Nina
    local ninaScaleFactor = availablePlayers[NINA].scaleFactorInMenu
    local ninaX = spaceBetween * 2 + hrvojeImg:getWidth() * hrvojeScaleFactor 
    local ninaY = h/2 - ninaImg:getHeight() * ninaScaleFactor / 2
    drawPlayerAndName(ninaImg, ninaScaleFactor, ninaX, ninaY,
        NINA, playerNameY,
        availablePlayersList[selectedPlayerIdx] == NINA
    )

    -- Draw Zizi
    local ziziScaleFactor = availablePlayers[ZIZI].scaleFactorInMenu
    local ziziX = spaceBetween * 3 + hrvojeImg:getWidth() * hrvojeScaleFactor + ninaImg:getWidth() * ninaScaleFactor
    local ziziY = h/2 - ziziImg:getHeight() * ziziScaleFactor / 2
    drawPlayerAndName(ziziImg, ziziScaleFactor, ziziX, ziziY,
        ZIZI, playerNameY,
        availablePlayersList[selectedPlayerIdx] == ZIZI
    )
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

return menuSelectPlayer
