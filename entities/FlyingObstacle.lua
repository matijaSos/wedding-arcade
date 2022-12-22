local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local FlyingObstacle = Class{
  __includes = Entity
}

function FlyingObstacle:init(x, y)
  self.isFlyingObstacle = true
  self.img = love.graphics.newImage('assets/fly-swatter.png')
  self.imgScaling = 0.4
  self.xMovSpeed = 500
  self.directionDeg = 0

  Entity.init(
    self,
    x, y,
    self.img:getWidth() * self.imgScaling,
    self.img:getHeight() * self.imgScaling
  )
end

function FlyingObstacle:draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(
    self.img,
    self.x, self.y,
    math.rad(self.directionDeg),
    self.imgScaling, self.imgScaling,
    -- By defining offset to be image center we get the image to rotate around its center.
    self.img:getWidth() / 2, self.img:getHeight() / 2
  )
end

function FlyingObstacle:update(dt, world)
    local goalX = self.x - self.xMovSpeed * gameSpeedFactor * dt
    local goalY = self.y
    local newDirectionDeg = (self.directionDeg - 360 * dt) % 360

    local colFilter = function (item, other)
      if other.isPlayer then
        camera:shake(8, 1, 60)
      end
      return 'cross'
    end

    self.x, self.y = world:move(self, goalX, goalY, colFilter)
    self.directionDeg = newDirectionDeg
end

return FlyingObstacle
