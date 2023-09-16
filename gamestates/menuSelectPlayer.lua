local Gamestate = require 'libs.hump.gamestate'

local drawBg = require 'drawMenuBackground'
local game = require 'gamestates.game'
local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left

local menuSelectPlayer = {}

-- TODO(matija): extract players info in a separate file.
local ALPHA_WASP = 'Alpha Wasp'
local MINECRAFT_WASP = 'Minecraft Wasp'
local BETA_WASP = 'Beta Wasp'
-- TODO(matija): derive this list from the table below, via lume.keys()
local availablePlayersList = { ALPHA_WASP, MINECRAFT_WASP, BETA_WASP }

local availablePlayers = {}
availablePlayers[ALPHA_WASP] = {
    name = ALPHA_WASP,
    scaleFactorInMenu = 0.4,
    scaleFactorInGame = 0.25,
    imgPath = 'assets/wasp_1.png'
}
availablePlayers[MINECRAFT_WASP] = {
    name = MINECRAFT_WASP,
    scaleFactorInMenu = 0.4,
    scaleFactorInGame = 0.25,
    imgPath = 'assets/minecraft-wasp.png'
}
availablePlayers[BETA_WASP] = {
    name = BETA_WASP,
    scaleFactorInMenu = 0.25,
    scaleFactorInGame = 0.15,
    imgPath = 'assets/wasp-beta.png'
}

local selectedPlayerIdx

function menuSelectPlayer:enter()
    selectedPlayerIdx = 1

    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 110)
    playerNameFont = love.graphics.newFont(pixelFontPath, 80)

    bgAssets = drawBg.loadMenuBgAssets()

    hrvojeImg = love.graphics.newImage(availablePlayers[ALPHA_WASP].imgPath)
    ninaImg = love.graphics.newImage(availablePlayers[MINECRAFT_WASP].imgPath)
    ziziImg = love.graphics.newImage(availablePlayers[BETA_WASP].imgPath)

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
    love.graphics.printf('Choose your wasp:', 0, h / 4, w, 'center')

    -- Draw 3 choices - Hrvoje, Zizi, Nina
    local hrvojeScaleFactor = availablePlayers[ALPHA_WASP].scaleFactorInMenu
    -- TODO(matija): have a smarter way of determining this value?
    local playerNameY = h / 2 + 150
    local spaceBetween = (w - 3 * hrvojeImg:getWidth() * hrvojeScaleFactor) / 4

    -- Draw Hrvoje
    local hrvojeX = spaceBetween
    local hrvojeY = h / 2 - hrvojeImg:getHeight() * hrvojeScaleFactor / 2
    drawPlayerAndName(hrvojeImg, hrvojeScaleFactor, hrvojeX, hrvojeY,
        ALPHA_WASP, playerNameY,
        availablePlayersList[selectedPlayerIdx] == ALPHA_WASP
    )

    -- Draw Nina
    local ninaScaleFactor = availablePlayers[MINECRAFT_WASP].scaleFactorInMenu
    local ninaX = spaceBetween * 2 + hrvojeImg:getWidth() * hrvojeScaleFactor
    local ninaY = h / 2 - ninaImg:getHeight() * ninaScaleFactor / 2
    drawPlayerAndName(ninaImg, ninaScaleFactor, ninaX, ninaY,
        MINECRAFT_WASP, playerNameY,
        availablePlayersList[selectedPlayerIdx] == MINECRAFT_WASP
    )

    -- Draw Zizi
    local ziziScaleFactor = availablePlayers[BETA_WASP].scaleFactorInMenu
    local ziziX = spaceBetween * 3 + hrvojeImg:getWidth() * hrvojeScaleFactor + ninaImg:getWidth() * ninaScaleFactor
    local ziziY = h / 2 - ziziImg:getHeight() * ziziScaleFactor / 2
    drawPlayerAndName(ziziImg, ziziScaleFactor, ziziX, ziziY,
        BETA_WASP, playerNameY,
        availablePlayersList[selectedPlayerIdx] == BETA_WASP
    )
end

function drawPlayerAndName(img, scaleFactor, imgX, imgY, name, nameY, isSelected)
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
