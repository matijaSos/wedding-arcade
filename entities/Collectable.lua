local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Collectable = Class {
  __includes = Entity
}

function Collectable:init(x, y, img, imgScaling)
  self.isCollectable = true
  self.hasBeenCollected = false
  self.img = img
  self.imgScaling = imgScaling
  self.originalY = y

  Entity.init(
    self,
    x, y,
    self.img:getWidth() * self.imgScaling,
    self.img:getHeight() * self.imgScaling
  )
end

function Collectable:draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(
    self.img,
    self.x, self.y,
    0,
    self.imgScaling, self.imgScaling
  )
end

function Collectable:collect()
  self.hasBeenCollected = true
end

function Collectable:update(dt, world)
  height = self.img:getHeight() * self.imgScaling
  self.y = self.originalY + math.sin(love.timer.getTime() * 7) * 6
end

return Collectable
