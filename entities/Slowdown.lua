local Class = require 'libs.hump.class'
local Collectable = require 'entities.Collectable'

local Slowdown = Class {
  __includes = Collectable
}

Slowdown.effectName = 'slowdown'
Slowdown.overlay = love.graphics.newImage('assets/overlay/8.png')


function Slowdown:init(x, y)
  self.isSlowdown = true

  Collectable.init(
    self,
    x, y,
    love.graphics.newImage('assets/brandy.png'),
    0.4
  )
end

return Slowdown
