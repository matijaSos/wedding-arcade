local Class = require 'libs.hump.class'
local Collectable = require 'entities.Collectable'

local Brandy = Class{
  __includes = Collectable
}

function Brandy:init(x, y)
  self.isBrandy = true

  Collectable.init(
    self,
    x, y,
    love.graphics.newImage('assets/brandy.png'),
    0.4
  )
end

return Brandy
