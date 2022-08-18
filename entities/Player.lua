local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Player = Class{
    __includes = Entity
}

function Player:init(x, y)
    self.img = love.graphics.newImage('assets/player_hrvoje.png')

    -- How fast player moves along the X axis. A constant for now.
    self.xMovSpeed = 200
    
    self.yCurrVelocity = 0
    self.isGrounded = false

    -- TODO(matija): we don't want to have hardcoded scale factor. Maybe not even
    -- a scale factor at all, I should edit the image itself?
    Entity.init(self, x, y, self.img:getWidth()*0.1, self.img:getHeight()*0.1)
    --Entity.init(self, x, y, 32, 32)

end

function Player:draw()
    love.graphics.setColor(1, 1, 1)

    -- TODO(matija): If I scale down img, I also need to scale down its width
    -- and height as I save it, otherwise collision engine doesn't work since it
    -- has wrong info.
    love.graphics.draw(self.img, self.x, self.y, 0.1, 0.1)

    --love.graphics.rectangle('line', self:getRect())
end

function Player:update(dt, world, gravity)
    local dx = 0
    local dy = 0

    if love.keyboard.isDown("right") then
        dx = self.xMovSpeed * dt
    end
    if love.keyboard.isDown("left") then
        dx = -self.xMovSpeed * dt
    end
    
    -- Apply gravity
    if not self.isGrounded then
        self.yCurrVelocity = self.yCurrVelocity + gravity * dt
    end

    if love.keyboard.isDown('up') and self.isGrounded then
        self.yCurrVelocity = -900
        --self.isGrounded = false
    end

    dy = self.yCurrVelocity * dt

    local goalX = self.x + dx
    local goalY = self.y + dy

    self.x, self.y, collisions, collLen = world:move(self, goalX, goalY)

    -- If e.g. player walks or jumps off the platform, we want
    -- him to start falling.
    if collLen == 0 then
        self.isGrounded = false
    end

    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then
            -- Couldn't go as high as wanted - blocked from above
            -- (e.g. when jumping, bumped head in the platform above).
            self.yCurrVelocity = 0

        -- NOTE(matija): Checking normal is important because want player to keep
        -- falling if there was a side collision (e.g. against a wall). Normal
        -- will be -1 in case of the floor collision.
        elseif coll.normal.y < 0 then
            -- Couldn't go as low as wanted - blocked from below (e.g. fell on the
            -- ground).
            self.isGrounded = true
            self.yCurrVelocity = 0
        end
    end

end

return Player
