local Class = require 'libs.hump.class'
local Collectable = require 'entities.Collectable'

local Speedup = Class {
  __includes = Collectable
}

Speedup.effectName = 'speedup'
-- Speedup.overlay = love.graphics.newImage('assets/overlay/25.png')
Speedup.overlay = love.graphics.newImage('assets/overlay/10.png')


function Speedup:init(x, y)
  self.isSpeedup = true

  Collectable.init(
    self,
    x, y,
    love.graphics.newImage('assets/honeypot.png'),
    0.2
  )
end

return Speedup
