
local saveScore = {}

function saveScore:enter(from, score)
    local pixelFontPath = 'assets/computer_pixel-7.ttf'
    self.kbFont = love.graphics.newFont(pixelFontPath, 80)
    self.titleFont = love.graphics.newFont(pixelFontPath, 100)

    self.score = 123
    self.positionAchieved = 3
    self.selectedChar = 'A'

    self.name = ''
end

function saveScore:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(0,0,0, 0.7)
    love.graphics.rectangle('fill', 0,0, w, h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.titleFont)
    love.graphics.printf(
        'Your Score: ' .. lume.round(self.score) ..
        ' . . . #' .. self.positionAchieved,
        0, h/6, w, 'center'
    )

    love.graphics.printf(self.name, 0, h/6 + 100, w, 'center')

    drawKeyboard(self.kbFont, self.selectedChar)
end

function drawKeyboard (font, selectedChar)
    love.graphics.setColor(1, 1, 1)

    local charsPerRow = 10
    local spaceBetweenColumns = 100
    local spaceBetweenRows = 100

    local charWidth = font:getWidth('A')
    local startX = (
        love.graphics.getWidth() -
        (charsPerRow - 1) * spaceBetweenColumns -
        charWidth
    ) / 2
    local startY = 400

    for i=0, 25 do
        local row = math.floor(i / charsPerRow)
        local column = i % charsPerRow

        local char = string.char(string.byte('A') + i)
        local charX = startX + column * spaceBetweenColumns
        local charY = startY + row * spaceBetweenRows

        if char == selectedChar then
            char = '>' .. char .. '<'
            charX = charX - font:getWidth('>')
        end

        love.graphics.print(char, font, charX, charY)
    end
end

function getNextChar (char, inc)
    local nextChar = string.char(
        string.byte('A') +
        (string.byte(char) - string.byte('A') + inc) % 26
    )

    return nextChar
end

function saveScore:keypressed(key)
    if key == 'space' then
        self.name = self.name .. self.selectedChar
    end

    if key == 'right' then
        self.selectedChar = getNextChar(self.selectedChar, 1)
    end
    if key == 'left' then
        self.selectedChar = getNextChar(self.selectedChar, -1)
    end
    if key == 'down' then
        self.selectedChar = getNextChar(self.selectedChar, 10)
    end
    if key == 'up' then
        self.selectedChar = getNextChar(self.selectedChar, -10)
    end
end

return saveScore
