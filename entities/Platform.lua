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
    -- Draw table
    love.graphics.setColor(0.95, 0.95, 0.95)
    love.graphics.rectangle('fill', self:getRect())
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self:getRect())
    -- Draw legs
    love.graphics.setColor(love.math.colorFromBytes(164, 116, 73))
    local legWidth = 20
    local legHeight = 40
    local distFromLegToTableEnd = 20
    love.graphics.rectangle(
      'fill',
      self.x + distFromLegToTableEnd,
      self.y + self.h,
      legWidth,
      legHeight
    )
    love.graphics.rectangle(
      'fill',
      self.x + self.w - legWidth - distFromLegToTableEnd,
      self.y + self.h,
      legWidth,
      legHeight
    )
end

return Platform
