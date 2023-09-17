local math = require 'math'
local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Monster = Class {
  __includes = Entity
}

function Monster:init(scanline, scanlineDx, x, y, maxDistYFromCenter, moveSpeedY, img, imgScale)
  self.isMonster = true
  self.img = img
  self.imgScale = imgScale
  self.scanline = scanline
  self.scanlineDx = scanlineDx
  self.centerCameraRelY = y
  self.cameraRelY = y
  self.maxDistYFromCenter = maxDistYFromCenter
  self.moveSpeedY = moveSpeedY
  self.monsterWidth = self.img:getWidth() * self.imgScale
  self.headOffsetX = 513 * self.imgScale + 256 / 2 * self.imgScale
  self.headOffsetY = 276 * self.imgScale + 88 / 2 * self.imgScale

  -- TODO(matija): we don't want to have hardcoded scale factor. Maybe not even
  -- a scale factor at all, I should edit the image itself?
  Entity.init(
    self,
    scanline.x - self.headOffsetX,
    cameraRelYToWorldY(self.cameraRelY),
    self.img:getWidth() * self.imgScale,
    self.img:getHeight() * self.imgScale
  )
  -- print("Start", self.x)
  -- print(self.scanline.x)
end

local function rectStartToHeadCenter(self)
  local headCenterX = self.x + self.headOffsetX
  local headCenterY = self.y + self.headOffsetY
  return headCenterX, headCenterY
end

function Monster:draw()
  love.graphics.setColor(1, 1, 1)

  -- TODO(matija): If I scale down img, I also need to scale down its width
  -- and height as I save it, otherwise collision engine doesn't work since it
  -- has wrong info.
  love.graphics.draw(self.img, self.x, self.y, 0, self.imgScale, self.imgScale)
end

function Monster:update(dt, world, playerX, playerY)
  local speed = 300
  local headX, headY = rectStartToHeadCenter(self)
  local y, x = playerY - headY, playerX - headX

  local monsterAttackAngle = math.atan(y / x)

  local dy = math.sin(monsterAttackAngle) * (dt * self.moveSpeedY)

  local goalY = self.y + dy
  local goalX = self.scanline.x - self.headOffsetX

  local colFilter = function(item, other)
    return 'cross'
  end
  self.x, self.y, collisions, collLen = world:move(self, goalX, goalY, colFilter)
end

function cameraRelYToWorldY(cameraRelY)
  local x, y = camera:toWorldCoords(0, cameraRelY)
  return y
end

function cameraRelXToWorldX(cameraRelX)
  local x, y = camera:toWorldCoords(cameraRelX, 0)
  return x
end

function worldYToCameraRelY(worldY)
  local x, y = camera:toCameraCoords(0, worldY)
  return y
end

return Monster
