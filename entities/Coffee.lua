local Class = require 'libs.hump.class'
local Collectable = require 'entities.Collectable'

local Coffee = Class{
  __includes = Collectable
}

function Coffee:init(x, y)
  self.isCoffee = true

  Collectable.init(
    self,
    x, y,
    love.graphics.newImage('assets/coffee.png'),
    0.07
  )
end

return Coffee
