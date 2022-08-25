local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Scanline = Class{
    __includes = Entity
}

function Scanline:init()
    self.isScanline = true

    self.xMovSpeed = 250

    Entity.init(self, -300, -100, 1, 2000)
end

function Scanline:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self:getRect())
end

function Scanline:update(dt)
    local goalX = self.x + self.xMovSpeed * dt
    local colFilter = function (item, other)
        return 'cross'
    end

    self.x, self.y, collisions, collLen = world:move(
        self, goalX, self.y, colFilter
    )

    for i, coll in ipairs(collisions) do
        if coll.other.isPlayer then
            print('collided with player!')
            coll.other.isCaught = true
        end
    end
end

return Scanline
