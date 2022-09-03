local Gamestate = require 'libs.hump.gamestate'
local lume = require 'libs.lume.lume'
local highscore = require 'libs.sick'

local saveScore = require 'gamestates.saveScore'

local gameOver = {}

-- TODO(matija): put this into self.score?
local scoreAchieved

local SAVE = 'Save'
local RESTART = 'Restart'

local buttons = { SAVE, RESTART }
local selectedButtonIdx

function gameOver:enter(from, score)
    self.from = from -- record previous state
    scoreAchieved = score

    selectedButtonIdx = 1

    -- TODO(matija): implement functionality which performs this check.
    positionAchieved = 5

    -- TODO(matija): extract this path somewhere, I keep duplicating it.
    local pixelFontPath = 'assets/computer_pixel-7.ttf'
    titleFont = love.graphics.newFont(pixelFontPath, 120)
    subtitleFont = love.graphics.newFont(pixelFontPath, 80)

    --highscore.add('matija', score)
end

function gameOver:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()

    -- overlay with gameOver message
    love.graphics.setColor(0,0,0, 0.7)
    love.graphics.rectangle('fill', 0,0, w, h)
    love.graphics.setColor(255,255,255)

    love.graphics.setFont(titleFont)
    love.graphics.printf('GAME OVER', 0, h/4, w, 'center')

    love.graphics.setFont(subtitleFont)
    love.graphics.printf(
        'Your Score: ' .. lume.round(scoreAchieved) ..
        ' . . . #' .. positionAchieved,
        0, h/4 + 150, w, 'center'
    )

    -- TODO(matija): extract and clean this up
    -- Draw "save" and "reset" buttons
    local buttonHalfDist = 150
    local buttonY = h/4 + 150 + 100

    local saveButtonX = w/2 -
        love.graphics.newText(subtitleFont, SAVE):getWidth() -
        buttonHalfDist
    if buttons[selectedButtonIdx] == SAVE then
        saveButtonX = saveButtonX -
            love.graphics.newText(subtitleFont, '> '):getWidth()
    end

    local resetButtonX = w/2 + buttonHalfDist
    if buttons[selectedButtonIdx] == RESTART then
        resetButtonX = resetButtonX -
            love.graphics.newText(subtitleFont, '> '):getWidth()
    end

    local saveButtonText = love.graphics.newText(
        subtitleFont,
        getButtonText(SAVE, buttons[selectedButtonIdx] == SAVE)
    )
    local resetButtonText = love.graphics.newText(
        subtitleFont,
        getButtonText(RESTART, buttons[selectedButtonIdx] == RESTART)
    )

    love.graphics.draw(saveButtonText, saveButtonX, buttonY)
    love.graphics.draw(resetButtonText, resetButtonX, buttonY)


    --[[
    love.graphics.printf(
        'Score: ' .. tostring(lume.round(scoreAchieved)),
        0, h/2 + 40, w, 'center'
    )

    -- Draw highscore table.
    for i, score, name in highscore() do
        love.graphics.print(name, 400, h/2 + 40 + i * 40)
        love.graphics.print(score, 500, h/2 + 40 + i * 40)
    end
    ]]--
end

function getButtonText (text, isSelected)
    if isSelected then
        return '> ' .. text .. ' <'
    else
        return text
    end
end

function gameOver:keypressed(key)
    if key == 'space' then
        if buttons[selectedButtonIdx] == RESTART then
            local menu = require 'gamestates.menu'
            -- TODO(matija): is it ok to do switch here, given this gamestate
            -- came here via push()? Are we continuously building a stack of
            -- gamestates, with each new game?
            Gamestate.switch(menu)
        elseif buttons[selectedButtonIdx] == SAVE then
            Gamestate.switch(saveScore, scoreAchieved)
        end
    end
    if key == 'right' then
        selectedButtonIdx = selectedButtonIdx + 1
        if selectedButtonIdx > #buttons then selectedButtonIdx = 1 end
    end
    if key == 'left' then
        selectedButtonIdx = selectedButtonIdx - 1
        if selectedButtonIdx < 1 then selectedButtonIdx = #buttons end
    end
end

return gameOver
