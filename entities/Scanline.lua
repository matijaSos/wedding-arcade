local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Scanline = Class{
    __includes = Entity
}

function Scanline:init()
    self.isScanline = true

    self.xMovSpeed = 450

    Entity.init(self, -300, -1000, 1, 3000)
end

function Scanline:draw()
end

function Scanline:update(dt)
    local goalX = self.x + self.xMovSpeed * dt
    local colFilter = function (item, other)
        return 'cross'
    end
    self.x, self.y, collisions, collLen = world:move(
        self, goalX, self.y, colFilter
    )
end

return Scanline
