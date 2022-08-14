local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Player = Class{
    __includes = Entity
}

function Player:init(x, y)
    self.img = love.graphics.newImage('assets/player_hrvoje.png')

    -- How fast player moves along the X axis. A constant for now.
    self.xMovSpeed = 100
    
    self.yCurrVelocity = 0
    self.isGrounded = false

    -- TODO(matija): we don't want to have hardcoded scale factor. Maybe not even
    -- a scale factor at all, I should edit the image itself?
    Entity.init(self, x, y, self.img:getWidth()*0.1, self.img:getHeight()*0.1)
    --Entity.init(self, x, y, 32, 32)

end

function Player:draw()
    love.graphics.setColor(1, 1, 1)

    -- TODO(matija): If I scale down img, I also need to scale down its width
    -- and height as I save it, otherwise collision engine doesn't work since it
    -- has wrong info.
    love.graphics.draw(self.img, self.x, self.y, 0.1, 0.1)

    --love.graphics.rectangle('line', self:getRect())
end

return Player
