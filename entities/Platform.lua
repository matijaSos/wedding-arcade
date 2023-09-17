local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Platform = Class {
  __includes = Entity
}

local block_left = love.graphics.newImage('assets/industrial/tiles/IndustrialTile_04.png')
local block_middle = love.graphics.newImage('assets/industrial/tiles/IndustrialTile_05.png')
local block_right = love.graphics.newImage('assets/industrial/tiles/IndustrialTile_06.png')

local fence_left = love.graphics.newImage('assets/industrial/objects/Fence1.png')
local fence_middle = love.graphics.newImage('assets/industrial/objects/Fence2.png')
local fence_right = love.graphics.newImage('assets/industrial/objects/Fence3.png')

function Platform:init(x, y, numberOfTiles, tileWidth, tileHeight)
  self.isPlatform = true
  self.numberOfTiles = numberOfTiles
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight

  local width = numberOfTiles * tileWidth
  self.decorations = generateDecorations(width)
  Entity.init(self, x, y, width, tileHeight)
end

function Platform:drawFence()
  local width = self.tileWidth / fence_middle:getWidth()
  local height = self.tileHeight / fence_middle:getHeight()
  love.graphics.draw(fence_left, self.x + 10, self.y - self.tileHeight, 0, width, height)
  for i = 1, self.numberOfTiles - 2 do
    love.graphics.draw(fence_middle, self.x + 10 + i * self.tileWidth, self.y - self.tileHeight, 0, width, height)
  end
  love.graphics.draw(fence_right, self.x + 10 + (self.numberOfTiles - 1) * self.tileWidth, self.y - self.tileHeight, 0,
    width,
    height)
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

  -- Draw fence
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
  local decorationsTransparency = 0.8
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
    decorationType = 'apple-computer'
  elseif decorationTypeIdx == 4 then
    decorationType = 'ibm-computer'
  elseif decorationTypeIdx >= 5 and decorationTypeIdx <= 6 then
    decorationType = 'ti-99'
  elseif decorationTypeIdx == 7 then
    decorationType = 'pet-2001'
  end
  return getDecorationOfType(decorationType)
end

local appleComputerImg = love.graphics.newImage('assets/OldComps/84applemac.png')
local ibmComputerImg = love.graphics.newImage('assets/OldComps/ibm5150.png')
local ti99Img = love.graphics.newImage('assets/OldComps/ti-99-4a.png')
local pet2001Img = love.graphics.newImage('assets/OldComps/pet2001-8.png')

function getDecorationOfType(decorationType)
  if decorationType == 'apple-computer' then return { img = appleComputerImg, scale = 1.66, h = 50, w = 200 } end
  if decorationType == 'ibm-computer' then return { img = ibmComputerImg, scale = 1.66, h = 50, w = 200 } end
  if decorationType == 'ti-99' then return { img = ti99Img, scale = 1.66, h = 50, w = 200 } end
  if decorationType == 'pet-2001' then return { img = pet2001Img, scale = 1.66, h = 50, w = 200 } end
  error "no such decoration type"
end

return Platform
