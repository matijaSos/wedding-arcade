local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Player = Class{
    __includes = Entity
}

function Player:init(x, y)
    self.img = love.graphics.newImage('assets/player_hrvoje.png')

    --Entity.init(self, x, y, self.img:getWidth(), self.img:getHeight())
    Entity.init(self, x, y, 32, 32)

end

function Player:draw()
    love.graphics.setColor(0, 0, 0)

    -- TODO(matija): If I scale down img, I also need to scale down its width
    -- and height as I save it, otherwise collision engine doesn't work since it
    -- has wrong info.
    --love.graphics.draw(self.img, self.x, self.y, 0.1, 0.1)

    love.graphics.rectangle('line', self:getRect())
end

return Player
