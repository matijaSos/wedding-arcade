local Gamestate = require 'libs.hump.gamestate'
local lume = require 'libs.lume.lume'
local highscore = require 'libs.sick'
local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left

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

    self.place = highscore.checkPlace(scoreAchieved)

    -- TODO(matija): extract this path somewhere, I keep duplicating it.
    local pixelFontPath = 'assets/computer_pixel-7.ttf'
    titleFont = love.graphics.newFont(pixelFontPath, 120)
    subtitleFont = love.graphics.newFont(pixelFontPath, 80)

    --highscore.add('matija', score)
end

function gameOver:update()
    inputR:update()
    inputL:update()

    if inputR:pressed 'action' or inputL:pressed 'action' then
        if buttons[selectedButtonIdx] == RESTART then
            local menu = require 'gamestates.menu'
            -- TODO(matija): is it ok to do switch here, given this gamestate
            -- came here via push()? Are we continuously building a stack of
            -- gamestates, with each new game?
            Gamestate.switch(menu)
        elseif buttons[selectedButtonIdx] == SAVE then
            Gamestate.switch(saveScore, scoreAchieved, self.place)
        end
    end
    if inputL:pressed 'right' then
        selectedButtonIdx = selectedButtonIdx + 1
        if selectedButtonIdx > #buttons then selectedButtonIdx = 1 end
    end
    if inputL:pressed 'left' then
        selectedButtonIdx = selectedButtonIdx - 1
        if selectedButtonIdx < 1 then selectedButtonIdx = #buttons end
    end

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
        'Your Score: ' .. lume.round(scoreAchieved) .. 'm' ..
        ' . . . #' .. self.place,
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
end

function getButtonText (text, isSelected)
    if isSelected then
        return '> ' .. text .. ' <'
    else
        return text
    end
end

return gameOver
