local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Platform = Class {
  __includes = Entity
}

local block_left = love.graphics.newImage('assets/industrial/tiles/IndustrialTile_04.png')
local block_middle = love.graphics.newImage('assets/industrial/tiles/IndustrialTile_05.png')
local block_right = love.graphics.newImage('assets/industrial/tiles/IndustrialTile_06.png')

function Platform:init(x, y, numberOfTiles, tileWidth, tileHeight)
  self.isPlatform = true
  self.numberOfTiles = numberOfTiles
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight

  local width = numberOfTiles * tileWidth
  self.decorations = generateDecorations(width)
  Entity.init(self, x, y, width, tileHeight)
end

function Platform:draw()
  -- Draw table
  -- love.graphics.draw(block, 100, 100)
  -- scale image block to tileWidth and tileHeight and draw it
  local width = self.tileWidth / block_middle:getWidth()
  local height = self.tileHeight / block_middle:getHeight()

  love.graphics.draw(block_left, self.x, self.y, 0, width, height)
  for i = 1, self.numberOfTiles - 1 do
    love.graphics.draw(block_middle, self.x + i * self.tileWidth, self.y, 0, width, height)
  end
  love.graphics.draw(block_right, self.x + (self.numberOfTiles - 1) * self.tileWidth, self.y, 0, width, height)
  -- ca
  -- love.graphics.setColor(0.95, 0.95, 0.95)
  -- love.graphics.rectangle('fill', self:getRect())
  -- love.graphics.setColor(0, 0, 0)
  -- love.graphics.rectangle('line', self:getRect())

  -- -- Draw legs
  -- love.graphics.setColor(love.math.colorFromBytes(164, 116, 73))
  -- local legWidth = 20
  -- local legHeight = 40
  -- local distFromLegToTableEnd = 20
  -- love.graphics.rectangle(
  --   'fill',
  --   self.x + distFromLegToTableEnd,
  --   self.y + self.h,
  --   legWidth,
  --   legHeight
  -- )
  -- love.graphics.rectangle(
  --   'fill',
  --   self.x + self.w - legWidth - distFromLegToTableEnd,
  --   self.y + self.h,
  --   legWidth,
  --   legHeight
  -- )
  -- Draw decorations
  local decorationsTransparency = 0.3
  love.graphics.setColor(1, 1, 1, decorationsTransparency)
  for k, d in ipairs(self.decorations) do
    love.graphics.draw(d.img, self.x + d.x, self.y - d.h, 0, d.scale, d.scale)
  end
  love.graphics.setColor(1, 1, 1, 1) -- To reset alpha/transparency to 1 (solid)!
end

function generateDecorations(tableWidth)
  local decorations = {}
  local nextDecorationX = 0
  while true do
    local decoration = getRandomDecoration()
    nextDecorationX = nextDecorationX + math.random(0, TILE_SIZE * 2)
    if nextDecorationX + decoration.w >= tableWidth then break end
    decoration.x = nextDecorationX
    table.insert(decorations, decoration)
    nextDecorationX = nextDecorationX + decoration.w
  end
  return decorations
end

function getRandomDecoration()
  local decorationType = nil
  local decorationTypeIdx = math.random(0, 7)
  if decorationTypeIdx >= 0 and decorationTypeIdx <= 3 then
    decorationType = 'wine-glass'
  elseif decorationTypeIdx == 4 then
    decorationType = 'food-bell'
  elseif decorationTypeIdx >= 5 and decorationTypeIdx <= 6 then
    decorationType = 'bread'
  elseif decorationTypeIdx == 7 then
    decorationType = 'rose-in-vase'
  end
  return getDecorationOfType(decorationType)
end

local wineGlassImg = love.graphics.newImage('assets/wine-glass.png')
local foodBellImg = love.graphics.newImage('assets/food-bell.png')
local breadImg = love.graphics.newImage('assets/bread.png')
local roseInVaseImg = love.graphics.newImage('assets/rose-in-vase.png')
function getDecorationOfType(decorationType)
  if decorationType == 'wine-glass' then return { img = wineGlassImg, scale = 0.04, h = 40, w = 25 } end
  if decorationType == 'food-bell' then return { img = foodBellImg, scale = 0.28, h = 50, w = 100 } end
  if decorationType == 'bread' then return { img = breadImg, scale = 0.3, h = 32, w = 70 } end
  if decorationType == 'rose-in-vase' then return { img = roseInVaseImg, scale = 1, h = 85, w = 30 } end
  error "no such decoration type"
end

return Platform
