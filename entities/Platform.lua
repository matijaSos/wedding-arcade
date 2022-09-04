local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Platform = Class{
    __includes = Entity
}

function Platform:init(x, y, w, h)
  self.isPlatform = true
  self.decorations = generateDecorations(w)
  Entity.init(self, x, y, w, h)
end

function Platform:draw()
    -- Draw table
    love.graphics.setColor(0.95, 0.95, 0.95)
    love.graphics.rectangle('fill', self:getRect())
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self:getRect())
    -- Draw legs
    love.graphics.setColor(love.math.colorFromBytes(164, 116, 73))
    local legWidth = 20
    local legHeight = 40
    local distFromLegToTableEnd = 20
    love.graphics.rectangle(
      'fill',
      self.x + distFromLegToTableEnd,
      self.y + self.h,
      legWidth,
      legHeight
    )
    love.graphics.rectangle(
      'fill',
      self.x + self.w - legWidth - distFromLegToTableEnd,
      self.y + self.h,
      legWidth,
      legHeight
    )
    -- Draw decorations
    love.graphics.setColor(1, 1, 1)
    for k, d in ipairs(self.decorations) do
      dImgInfo = getDecorationImgInfo(d.type)
      love.graphics.draw(dImgInfo.img, self.x + d.x, self.y - dImgInfo.h, 0, dImgInfo.scale, scale)
    end
end

function generateDecorations(tableWidth)
  numDecorations = math.random(0, 3)
  decorations = {}
  for i=1,numDecorations do
    decoration = { type='wine-glass', x=math.random(1, tableWidth - 10) }
    table.insert(decorations, decoration)
  end
  return decorations
end

local wineGlassImg = love.graphics.newImage('assets/wine-glass.png')
function getDecorationImgInfo(decorationType)
  if decorationType == 'wine-glass' then
    return {
      img=wineGlassImg,
      scale=0.05,
      h=50
    }
  end
  error "no such decoration type"
end

return Platform
