local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Scanline = Class{
    __includes = Entity
}

function Scanline:init()
    self.xMovSpeed = 100

    Entity.init(self, -300, -100, 1, 2000)
end

function Scanline:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self:getRect())
end

function Scanline:update(dt)
    self.x = self.x + self.xMovSpeed * dt
end

return Scanline
