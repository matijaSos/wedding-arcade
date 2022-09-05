local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Musician = Class{
    __includes = Entity
}

function Musician:init(scanline, y, initialDirectionY, maxDistYFromCenter, moveSpeedY, img, imgScale)
    self.isMusician = true
    self.img = img
    self.imgScale = imgScale
    self.scanline = scanline
    self.centerCameraRelY = y
    self.cameraRelY = y
    self.maxDistYFromCenter = maxDistYFromCenter
    self.directionY = initialDirectionY
    self.moveSpeedY = moveSpeedY

    -- TODO(matija): we don't want to have hardcoded scale factor. Maybe not even
    -- a scale factor at all, I should edit the image itself?
    Entity.init(
      self,
      scanline.x,
      cameraRelYToWorldY(self.cameraRelY),
      self.img:getWidth() * self.imgScale,
      self.img:getHeight() * self.imgScale
    )
end

function Musician:draw()
    love.graphics.setColor(1, 1, 1)

    -- TODO(matija): If I scale down img, I also need to scale down its width
    -- and height as I save it, otherwise collision engine doesn't work since it
    -- has wrong info.
    love.graphics.draw(self.img, self.x, self.y, 0, self.imgScale, self.imgScale)
end

function Musician:update(dt, world, gravity)
    local dy = self.directionY * self.moveSpeedY * gameSpeedFactor * dt

    local goalX = self.scanline.x
    local goalY = cameraRelYToWorldY(self.cameraRelY + dy)

    local colFilter = function (item, other)
      return 'cross'
    end
    self.x, self.y, collisions, collLen = world:move(self, goalX, goalY, colFilter)

    self.cameraRelY = worldYToCameraRelY(self.y)
    if self.cameraRelY > self.centerCameraRelY + self.maxDistYFromCenter then
      self.directionY = -1
    end
    if self.cameraRelY < self.centerCameraRelY - self.maxDistYFromCenter then
      self.directionY = 1
    end
end

function cameraRelYToWorldY(cameraRelY)
  local x, y = camera:toWorldCoords(0, cameraRelY)
  return y
end

function worldYToCameraRelY(worldY)
  local x, y = camera:toCameraCoords(0, worldY)
  return y
end

return Musician
