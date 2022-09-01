local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Player = Class{
    __includes = Entity
}

local PLAYER_X_MOV_SPEED_DEFAULT = 300

function Player:init(x, y, playerConfig)
    self.isPlayer = true
    self.img = love.graphics.newImage(playerConfig.imgPath)

    self.isCaught = false

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
    Entity.init(self, x, y, self.img:getWidth()*0.1, self.img:getHeight()*0.1)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)

    -- TODO(matija): If I scale down img, I also need to scale down its width
    -- and height as I save it, otherwise collision engine doesn't work since it
    -- has wrong info.
    love.graphics.draw(self.img, self.x, self.y, 0, 0.1, 0.1)

    --love.graphics.rectangle('line', self:getRect())
end

local wasJumpButtonDown = false

function Player:update(dt, world, gravity)
    self.secondsLeftTillXMovSpeedRecovery = math.max(self.secondsLeftTillXMovSpeedRecovery - dt, 0)
    if not (self.secondsLeftTillXMovSpeedRecovery > 0) then
      self.xMovSpeed = PLAYER_X_MOV_SPEED_DEFAULT
    end

    local jumpToPeakTime = self.jumpingSpeed / gravity

    local dx = 0
    local dy = 0

    if love.keyboard.isDown("right") then
        dx = self.xMovSpeed * dt
    end
    if love.keyboard.isDown("left") then
        dx = -self.xMovSpeed * dt
    end

    -- Apply gravity
    self.yCurrVelocity = self.yCurrVelocity + gravity * dt

    if love.keyboard.isDown('space') then
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
    if self.isJumpDurationTracked and not love.keyboard.isDown('space') then
        if self.yCurrVelocity < 0 -- If still going up
           -- NOTE(matija): if jump button was held for a very short time, we wait until it reaches
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

    local colFilter = function (item, other)
        if other.isScanline then return 'cross' end
        if other.isCollectable then
          if other.isBrandy then
            self.xMovSpeed = 150
            self.secondsLeftTillXMovSpeedRecovery = 3
          end
          -- TODO: destroy the collectible/brandy!
          return 'cross'
        end
        return 'slide'
    end

    self.x, self.y, collisions, collLen = world:move(self, goalX, goalY, colFilter)

    -- If e.g. player walks or jumps off the platform, we want
    -- him to start falling.
    -- TODO(matija): what about collectables, if they are in the air and player
    -- collects them? This won't work then.
    self.isGrounded = false
    for i, coll in ipairs(collisions) do
        -- If blocked from above (e.g. bumped head on smth when jumped).
        if coll.touch.y > goalY then
          self.yCurrVelocity = 0

        -- If blocked from below (e.g. fell on the ground).
        -- NOTE(matija): Checking normal is important because we want player to keep
        -- falling if there was a side collision (e.g. against a wall). Normal
        -- will be -1 in case of the floor collision.
        elseif coll.normal.y < 0 then
          self.isGrounded = true
          self.yCurrVelocity = 0
        end
    end

    if self.isGrounded then
      self.doubleJumpAvailable = true
    end

end

return Player
