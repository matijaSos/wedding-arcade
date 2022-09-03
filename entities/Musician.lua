local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Musician = Class{
    __includes = Entity
}

function Musician:init(scanline, y, initialDirectionY, moveSpeedY)
    self.isMusician = true
    self.img = love.graphics.newImage('assets/player_hrvoje.png')
    self.scanline = scanline
    self.centerY = y
    self.maxDistYFromCenter = 300
    self.directionY = initialDirectionY
    self.moveSpeedY = moveSpeedY

    -- TODO(matija): we don't want to have hardcoded scale factor. Maybe not even
    -- a scale factor at all, I should edit the image itself?
    Entity.init(self, scanline.x, y, self.img:getWidth()*0.1, self.img:getHeight()*0.1)
end

function Musician:draw()
    love.graphics.setColor(1, 1, 1)

    -- TODO(matija): If I scale down img, I also need to scale down its width
    -- and height as I save it, otherwise collision engine doesn't work since it
    -- has wrong info.
    love.graphics.draw(self.img, self.x, self.y, 0, 0.1, 0.1)
end

function Musician:update(dt, world, gravity)
    local dy = self.directionY * self.moveSpeedY * dt

    local goalX = self.scanline.x
    local goalY = self.y + dy

    local colFilter = function (item, other)
      return 'cross'
    end
    self.x, self.y, collisions, collLen = world:move(self, goalX, goalY, colFilter)

    if self.y > self.centerY + self.maxDistYFromCenter then
      self.directionY = -1
    end
    if self.y < self.centerY - self.maxDistYFromCenter then
      self.directionY = 1
    end
end

return Musician
