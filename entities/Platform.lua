local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Platform = Class{
    __includes = Entity
}

function Platform:init(x, y, w, h)
  self.isPlatform = true
  Entity.init(self, x, y, w, h)
end

function Platform:draw()
    love.graphics.setColor(1, 0.78, 0.15)
    love.graphics.rectangle('fill', self:getRect())
end

return Platform
