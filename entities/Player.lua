local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Player = Class{
    __includes = Entity
}

function Player:init(x, y)
    Entity.init(self, x, y, 0, 0)

    self.img = love.graphics.newImage('assets/player_hrvoje.png')
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y, 0.1, 0.1)
end

return Player
