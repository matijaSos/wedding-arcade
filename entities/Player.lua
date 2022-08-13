local Class = require "libs.hump.class"
local Entity = require "entities.Entity"

local Player = Class{
    __includes = Entity
}

function Player:init(x, y)
    Entity.init(self, x, y, 0, 0)
end

function Player:draw()
    love.graphics.circle("line", self.x, self.y, 25)
end

return Player
