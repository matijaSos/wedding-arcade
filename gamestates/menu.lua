local Gamestate = require 'libs.hump.gamestate'
local Text = require 'libs.sysl-text.example.library.slog-text'

local drawBg = require 'drawMenuBackground'
local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left

local menuSelectPlayer = require 'gamestates.menuSelectPlayer'
local highscore = require 'gamestates.highscore'

local NEW_GAME = 'Start new game'
local LEADERBOARD = 'Leaderboard'
local options = { NEW_GAME, LEADERBOARD }


local menu = {}

function menu:enter()
    local pixelFontPath = 'assets/computer_pixel-7.ttf'

    titleFont = love.graphics.newFont(pixelFontPath, 160)
    subtitleFont = love.graphics.newFont(pixelFontPath, 70)

    bgAssets = drawBg.loadMenuBgAssets()

    self.selectedOptionIdx = 1

    -- Dancing title text
    self.titleTextbox = Text.new('left',
    {
        font = titleFont
    })
    self.titleTextbox:send('[bounce=10]Wasp Escape[/bounce]', nil, true)

end

function menu:update(dt)
    self.titleTextbox:update(dt)

    inputR:update()
    inputL:update()

    if inputR:pressed 'action' or inputL:pressed 'action' then
        if options[self.selectedOptionIdx] == NEW_GAME then
            return Gamestate.switch(menuSelectPlayer)
        elseif options[self.selectedOptionIdx] == LEADERBOARD then
            return Gamestate.switch(highscore)
        end
    end
    if inputL:pressed 'up' then
        self.selectedOptionIdx = (self.selectedOptionIdx % 2) + 1
    end
    if inputL:pressed 'down' then
        self.selectedOptionIdx = ((self.selectedOptionIdx - 2) % 2) + 1
    end
end

function menu:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    drawBg.drawMenuBackground(bgAssets)

    -- Title
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(titleFont)
    -- TODO(matija): came up with the y-axis number emprically, not sure how to do
    -- it properly.
    self.titleTextbox:draw(w/2 - self.titleTextbox.get.width / 2, h/2 - 80)

    -- Draw vertical menu here: "start new game", "highscore"
    drawMenuOptions(subtitleFont, options[self.selectedOptionIdx])
end

function drawMenuOptions (font, selectedOption)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)

    love.graphics.printf(
        getOptionText('Start new game', selectedOption == NEW_GAME),
        0, h/2 + 80, w, 'center'
    )
    love.graphics.printf(
        getOptionText('Leaderboard', selectedOption == LEADERBOARD),
        0, h/2 + 80 + 80, w, 'center'
    )

end

function getOptionText (text, isSelected)
    if isSelected then return '> ' .. text .. ' <' end

    return text
end

function love.joystickpressed(joystick, button)
    print('pressed joystick button: ', button)
end

return menu
