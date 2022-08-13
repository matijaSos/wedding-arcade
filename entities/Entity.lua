local Class = require "libs.hump.class"

local Entity = Class{}

function Entity:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

return Entity
