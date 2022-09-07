local lume = require 'libs.lume.lume'
local misc = require 'misc'
local highscore = require 'libs.sick'
local highscoreGamestate = require 'gamestates.highscore'
local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left
local drawBg = require 'drawMenuBackground'

local saveScore = {}

local DEL, END = 'DEL', 'END'

local kb = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'W', 'X', 'Y', 'Z', '-', '.', '!', DEL, END
}

function saveScore:enter(from, score, place)
    local pixelFontPath = 'assets/computer_pixel-7.ttf'
    self.kbFont = love.graphics.newFont(pixelFontPath, 80)
    self.titleFont = love.graphics.newFont(pixelFontPath, 100)

    self.score = score
    self.place = place
    self.selectedChar = 'A'

    self.name = ''

    self.mostRecentNames = highscore.getMostRecentNames(3)

    self.kb = lume.clone(kb)
    for _, n in ipairs(self.mostRecentNames) do
        table.insert(self.kb, n)
    end

    bgAssets = drawBg.loadMenuBgAssets()
end

function saveScore:update()
    inputR:update()
    inputL:update()

    if inputL:pressed 'action' or inputR:pressed 'action' then
        if self.selectedChar == DEL then
            self.name = self.name:sub(1, #self.name - 1)
        elseif self.selectedChar == END then
            if #self.name > 0 then
                highscore.add(self.name, self.score)
                highscore.save()

                Gamestate.switch(highscoreGamestate, self.place)
            end
        else
            self.name = self.name .. self.selectedChar
        end
    end

    if inputL:pressed 'right' then
        self.selectedChar = getNextChar(self.kb, self.selectedChar, 1)
    end
    if inputL:pressed 'left' then
        self.selectedChar = getNextChar(self.kb, self.selectedChar, -1)
    end
    if inputL:pressed 'down' then
        self.selectedChar = getNextChar(self.kb, self.selectedChar, 10)
    end
    if inputL:pressed 'up' then
        self.selectedChar = getNextChar(self.kb, self.selectedChar, -10)
    end
end

function saveScore:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    drawBg.drawMenuBackground(bgAssets)

    love.graphics.setColor(0,0,0, 0.7)
    love.graphics.rectangle('fill', 0,0, w, h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.titleFont)
    love.graphics.printf(
        'Your Score: ' .. lume.round(self.score) ..
        ' . . . #' .. self.place,
        0, h/6, w, 'center'
    )

    love.graphics.printf(self.name, 0, h/6 + 100, w, 'center')

    drawKeyboard(self.kb, self.kbFont, self.selectedChar)
end

function drawKeyboard (kb, font, selectedChar)
    love.graphics.setColor(1, 1, 1)

    local charsPerRow = 10
    local spaceBetweenCharsX = 50
    local spaceBetweenRows = 50

    local charWidth = font:getWidth('A')
    local startX = (
        love.graphics.getWidth() -
        charsPerRow * charWidth -
        (charsPerRow - 1) * spaceBetweenCharsX
    ) / 2
    local startY = 400

    local prevCharEndX
    for i, char in ipairs(kb) do
        love.graphics.setColor(1, 1, 1)
        if char == END then
            love.graphics.setColor(0, 1, 0)
        end

        local row = math.floor((i - 1) / charsPerRow)
        local column =  (i - 1) % charsPerRow

        charX = startX
        if column > 0 then
            charX = prevCharEndX + spaceBetweenCharsX
        end
        local charY = startY + row * (font:getHeight() + spaceBetweenRows)

        local charToPrint = char
        local charToPrintX = charX
        if char == selectedChar then
            charToPrint = '>' .. char .. '<'
            charToPrintX = charToPrintX - font:getWidth('>')
        end

        love.graphics.print(charToPrint, font, charToPrintX, charY)

        prevCharEndX = charX + font:getWidth(char)
    end

end

function getNextChar (kb, char, inc)
    local idx = misc.tablefind(kb, char)
    local newIdx = math.min((idx - 1) + inc, #kb - 1) % #kb + 1

    return kb[newIdx]
end

return saveScore
