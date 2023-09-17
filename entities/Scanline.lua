local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Scanline = Class {
    __includes = Entity
}

function Scanline:init()
    self.isScanline = true

    self.xMovSpeed = 400

    Entity.init(self, -800, -1000, 1, 3000)
end

function Scanline:draw()
end

function Scanline:update(dt)
    -- TODO: This adjustedXMovSpeed is heavily hardcoded to work for the current
    -- speeds of scanline, player, and how gameSpeedFactor behaves, so if any of those change,
    -- this should also be updated, or ideally made less hardcoded.
    -- The point of adjustment here is to make scanline relatively faster compared to player
    -- as game progresses.
    local adjustedXMovSpeed = self.xMovSpeed + math.min(1, (math.max(0, gameSpeedFactor - 1) / 2)) * 150

    local goalX = self.x + adjustedXMovSpeed * gameSpeedFactor * dt
    local colFilter = function(item, other)
        return 'cross'
    end
    self.x, self.y, collisions, collLen = world:move(
        self, goalX, self.y, colFilter
    )
end

return Scanline
