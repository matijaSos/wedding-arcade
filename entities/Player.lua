local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local inputs = require 'input'
local inputR, inputL = inputs.right, inputs.left

local Player = Class {
  __includes = Entity
}

local PLAYER_X_MOV_SPEED_DEFAULT = 600

function Player:init(x, y, playerConfig)
  self.isPlayer = true
  self.img = love.graphics.newImage(playerConfig.imgPath)
  self.flippedImg = love.graphics.newImage(playerConfig.flippedImgPath)
  self.imgScale = playerConfig.scaleFactorInGame
  self.currentImg = self.img

  -- How fast player moves along the X axis. A constant for now.
  self.xMovSpeed = PLAYER_X_MOV_SPEED_DEFAULT
  self.secondsLeftTillXMovSpeedRecovery = 0

  -- When player jumps, the initial speed he has.
  self.jumpingSpeed = 1100

  self.yCurrVelocity = 0
  self.isGrounded = false

  -- Used for low jump.
  self.isJumpDurationTracked = false
  self.jumpDuration = 0

  -- Used for double jump.
  self.doubleJumpAvailable = false

  -- TODO(matija): we don't want to have hardcoded scale factor. Maybe not even
  -- a scale factor at all, I should edit the image itself?
  Entity.init(self, x, y, self.img:getWidth() * self.imgScale, self.img:getHeight() * self.imgScale)
end

function Player:draw()
  love.graphics.setColor(1, 1, 1)

  -- TODO(matija): If I scale down img, I also need to scale down its width
  -- and height as I save it, otherwise collision engine doesn't work since it
  -- has wrong info.
  if self.xDirection == 1 then
    self.currentImg = self.img
  end
  if self.xDirection == -1 then
    self.currentImg = self.flippedImg
  end

  love.graphics.draw(self.currentImg, self.x, self.y, 0, self.imgScale, self.imgScale)

  --love.graphics.rectangle('line', self:getRect())
end

local wasJumpButtonDown = false

function Player:update(dt, world, gravity)
  inputR:update()
  inputL:update()

  self.secondsLeftTillXMovSpeedRecovery = math.max(
    self.secondsLeftTillXMovSpeedRecovery - dt, 0
  )
  if not (self.secondsLeftTillXMovSpeedRecovery > 0) then
    self.xMovSpeed = PLAYER_X_MOV_SPEED_DEFAULT
    GameEffect = nil
  end

  local jumpToPeakTime = self.jumpingSpeed / gravity

  local dx = 0
  local dy = 0

  self.xDirection = 0
  if inputL:down("right") then
    self.xDirection = 1
  end
  if inputL:down("left") then
    self.xDirection = -1
  end
  dx = self.xDirection * self.xMovSpeed * gameSpeedFactor * dt

  -- Apply gravity
  self.yCurrVelocity = self.yCurrVelocity + gravity * dt

  if inputL:down('action') or inputR:down 'action' then
    if wasJumpButtonDown == false then
      if self.isGrounded then
        -- Jump!
        self.yCurrVelocity = -self.jumpingSpeed

        self.isJumpDurationTracked = true
        self.jumpDuration = 0
      elseif self.doubleJumpAvailable == true then
        -- Double jump (second half of it)!
        self.yCurrVelocity = -self.jumpingSpeed
        self.doubleJumpAvailable = false
      end
    end
    wasJumpButtonDown = true
  else
    wasJumpButtonDown = false
  end

  if self.isJumpDurationTracked then
    self.jumpDuration = self.jumpDuration + dt
  end

  -- We catch the moment during jump when jump button is released.
  if self.isJumpDurationTracked and not
      (inputL:down('action') or inputR:down('action')) then
    if self.yCurrVelocity < 0 -- If still going up
        -- NOTE(matija): if jump button was held for a very short time,
        -- we wait until it reaches
        -- certain threshold - this way we avoid jaggedness when jumping.
        and self.jumpDuration > jumpToPeakTime * 0.33 then
      self.yCurrVelocity = self.yCurrVelocity * 0.5
      self.isJumpDurationTracked = false
    end

    if self.yCurrVelocity >= 0 then self.isJumpDurationTracked = false end
  end


  dy = self.yCurrVelocity * dt

  local goalX = self.x + dx
  local goalY = self.y + dy

  local colFilter = function(item, other)
    if other.isScanline then return 'cross' end
    if other.isMonster then return 'cross' end
    if other.isCollectable then
      if other.isSlowdown then
        self.xMovSpeed = PLAYER_X_MOV_SPEED_DEFAULT * 0.66
        self.secondsLeftTillXMovSpeedRecovery = 2
        GameEffect = Slowdown
      end
      if other.isSpeedup then
        self.xMovSpeed = PLAYER_X_MOV_SPEED_DEFAULT * 1.33
        self.secondsLeftTillXMovSpeedRecovery = 2
        GameEffect = Speedup
      end
      other:collect()
      return 'cross'
    end
    if other.isPlatform then
      if dy < 0 then return 'cross' else return 'slide' end
    end
    return 'slide'
  end

  self.x, self.y, collisions, collLen = world:move(self, goalX, goalY, colFilter)

  -- If e.g. player walks or jumps off the platform, we want
  -- him to start falling.
  self.isGrounded = false
  for i, coll in ipairs(collisions) do
    -- If blocked from below (e.g. fell on the ground).
    -- NOTE(matija): Checking normal is important because we want player to keep
    -- falling if there was a side collision (e.g. against a wall). Normal
    -- will be -1 in case of the floor collision.
    if coll.normal.y < 0 then
      self.isGrounded = true
      self.yCurrVelocity = 0
    end
  end

  if self.isGrounded then
    self.doubleJumpAvailable = true
  end
end

return Player
