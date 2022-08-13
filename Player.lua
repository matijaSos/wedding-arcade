
Player = Object:extend()

function Player:new(x, y)
    self.x = x
    self.y = y
end

function Player:draw()
    love.graphics.circle("line", self.x, self.y, 25)
end
