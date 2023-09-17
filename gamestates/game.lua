bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'
Gamestate = require 'libs.hump.gamestate'
lume = require 'libs.lume.lume'

local input = require 'input'
local inputR, inputL = input.right, input.left
local Control = input.Control


local gameOver = require 'gamestates.gameOver'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'
FlyingObstacle = require 'entities.FlyingObstacle'
Slowdown = require 'entities.Slowdown'
Speedup = require 'entities.Speedup'
Monster = require 'entities.Monster'

misc = require 'misc'
generatePlatforms = require 'generatePlatforms'

-- TODO(matija): make these constants written in caps.
TILE_SIZE = 48
local gravity = 3000
ONE_METER_IN_PX = 100
gameSpeedFactor = 0.8
GameEffect = nil -- Or 'coffee' or 'brandy'

local game = {}

local scanline
local player
local entities
local monster
local cities = {}
local activeCity

local possibleCities = {
  { 1, 5 },
  { 2, 6 },
  -- { 3, 5 },
  -- { 4, 6 },
  -- { 5, 5 },
  -- { 6, 6 },
  -- { 7, 4 },
  -- { 8, 5 }
}

local backgrounds

local function loadCities()
  for index, city in ipairs(possibleCities) do
    local city_index, number_of_layers = city[1], city[2]
    -- print city_index to screen
    cities[city_index] = {}
    for layer = 1, number_of_layers do
      cities[city_index][layer] =
          love.graphics.newImage('assets/city_' .. city_index .. '/' .. layer .. '.png')
    end
  end
end

local function setCity(cityIndex)
  activeCity = cities[cityIndex]
end

local pixelFontPath = 'assets/computer_pixel-7.ttf'
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 0.02
local circuitsBackground = love.graphics.newImage('assets/bg_circuit_long_big.png')
local airshipsBackground = love.graphics.newImage('assets/airships/out.png')
-- create a new image that consists of two airships images back to back

-- local airshipsBackground = love.graphics.newImage('assets/balloons.png')



function game:enter(oldState, playerConfig)
  math.randomseed(os.time())

  -- Initialization -> important to do it here so every time the game
  -- restarts we start with the correct values.
  scanline = nil
  player = nil
  entities = {}
  loadCities()
  setCity(2)

  love.graphics.setBackgroundColor(1, 1, 1)
  hudFont = love.graphics.newFont(pixelFontPath, 64)

  world = bump.newWorld(TILE_SIZE)

  camera = Camera()
  camera:setFollowLerp(0.2)
  camera:setFollowStyle('PLATFORMER')

  scanline = Scanline()
  addEntity(scanline)

  local platforms = generatePlatforms({ x = 0, y = 800, width = 200 }, TILE_SIZE)
  addEntities(platforms)

  player = Player(platforms[1].x, platforms[1].y, playerConfig)
  addEntity(player)

  -- Initialize score count
  score = 0
  startingX = platforms[1].x

  local monsterImg = love.graphics.newImage('assets/monsters/pixelated_jquery.png')
  monster = Monster(scanline, 0, -1000, platforms[1].y, 150, 400, monsterImg, 0.5)
  world:add(monster, monster:getRect())
end

function game:update(dt)
  -- for cityIndex = 1, 8 do
  --   if inputL:down("background" .. cityIndex) then
  --     setCity(cityIndex)
  --   end
  -- end
  if player.x <= scanline.x or player.y > love.graphics.getHeight() * 2.5 then
    Gamestate.push(gameOver, score)
  end

  camera:update(dt)
  camera:follow(player.x, player.y)

  monster:update(dt, world, player.x, player.y)
  for i, e in ipairs(entities) do
    e:update(dt, world, gravity)
  end

  metersProgressed = (player.x - startingX) / ONE_METER_IN_PX
  backgroundScroll = metersProgressed * BACKGROUND_SCROLL_SPEED

  -- Update score
  score = math.max(score, metersProgressed)

  -- Increase game speed
  if (metersProgressed < 50) then
    gameSpeedFactor = 1
  else
    gameSpeedFactor = 1 + math.sqrt((metersProgressed - 50) / 200) * 0.5
  end

  -- Destroy any entities that have gone far beyond the scanline.
  for i, e in ipairs(entities) do
    if e.x + e.w < scanline.x - love.graphics.getWidth() then
      destroyEntity(e)
    end
  end


  -- Destroy any collectables that have been collected.
  local collectables = getCollectables()
  for i, c in ipairs(collectables) do
    if c.hasBeenCollected then destroyEntity(c) end
  end

  generateNewPlatformsIfNeeded()
  maybeGenerateNewFlyingObstacle(dt)
  maybeGenerateNewCollectables(dt)
end

function drawSingleBackground(baseBackgroundScroll)
  local width, height = love.graphics.getWidth(), love.graphics.getHeight()

  love.graphics.setColor(1, 1, 1)

  local circuitsWidth = circuitsBackground:getWidth()
  local yPos = height - circuitsBackground:getHeight()
  local cityRatio = circuitsWidth / width

  for j = baseBackgroundScroll / cityRatio - 1, width / circuitsWidth do
    love.graphics.draw(circuitsBackground, j * circuitsWidth, yPos)
  end
end

function drawCityBackground(baseBackgroundScroll)
  local width, height = love.graphics.getWidth(), love.graphics.getHeight()


  local activeBackgrounds = getActiveBackgrounds()
  -- put a transparent overlay over the background
  love.graphics.setColor(1, 1, 1)

  for i = 1, #activeBackgrounds do
    local activeCityBackground = activeBackgrounds[i]
    local yPos = height - activeCityBackground:getHeight()
    local cityWidth = activeCityBackground:getWidth()
    local cityRatio = cityWidth / width
    local backgroundScroll = baseBackgroundScroll / 5 * i
    for j = backgroundScroll / cityRatio - 1, width / cityWidth do
      love.graphics.draw(activeCityBackground, j * cityWidth, yPos)
    end
  end

  local airshipsRatio = airshipsBackground:getWidth()
  local airshipsWidth = airshipsRatio / width
  local airshipsBackgroundScroll = baseBackgroundScroll / 5 * 4
  for i = airshipsBackgroundScroll / airshipsWidth - 1, width / airshipsRatio do
    love.graphics.draw(airshipsBackground, i * airshipsRatio, 40)
  end

  love.graphics.setColor(1, 1, 1, 0.2)
  love.graphics.rectangle('fill', 0, 0, width, height)


  -- draw a white rectangle across the entire screen
  -- love.graphics.setColor(1, 1, 1, 0.15)
  -- love.graphics.rectangle('fill', 0, 0, width, height)
end

function getActiveBackgrounds()
  local backgrounds = {
    [Slowdown.effectName] = activeCity,
    [Speedup.effectName] = activeCity,
  }
  return backgrounds[GameEffect] or activeCity
end

function drawOverlay(overlay)
  love.graphics.setColor(1, 1, 1, 0.5)
  local scale = love.graphics:getWidth() / overlay:getWidth()
  love.graphics.draw(overlay, 0, 0, 0, scale, scale)
end

function game:draw()
  drawCityBackground(-backgroundScroll)
  -- drawSingleBackground(-backgroundScroll)

  if GameEffect == Speedup then
    drawOverlay(Speedup.overlay)
  end

  camera:attach()

  for i, e in ipairs(entities) do
    e:draw()
  end
  for i, e in ipairs(entities) do
    if e.isPlatform then
      e:drawFence()
    end
  end
  monster:draw()

  camera:detach()

  if GameEffect == Slowdown then
    drawOverlay(Slowdown.overlay)
  end

  -- HUD
  love.graphics.setFont(hudFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Score: " .. tostring(lume.round(score)) .. "m", 10, 10, love.graphics.getWidth(), 'center')
end

function game:leave()
end

function addEntity(e)
  table.insert(entities, e)
  world:add(e, e:getRect())
end

function destroyEntity(entity)
  table.remove(entities, misc.tablefind(entities, entity))
  world:remove(entity)
end

function addEntities(newEntities)
  for k, e in ipairs(newEntities) do addEntity(e) end
end

function filterEntities(p)
  return misc.filterArray(entities, p)
end

function getPlatforms()
  return filterEntities(function(e) return e.isPlatform end)
end

function getFlyingObstacles()
  return filterEntities(function(e) return e.isFlyingObstacle end)
end

function getCollectables()
  return filterEntities(function(e) return e.isCollectable end)
end

function generateNewPlatformsIfNeeded()
  local cameraX = camera:toWorldCoords(0, 0)

  local platforms = getPlatforms()
  local lastPlatform = platforms[#platforms]
  -- If reaching the end of generated platforms, generate more platforms.
  if lastPlatform and lastPlatform.x < cameraX + love.graphics.getWidth() * 2 then
    local newPlatforms = generatePlatforms(
      { x = lastPlatform.x, y = lastPlatform.y, width = lastPlatform.w },
      TILE_SIZE
    )
    addEntities(newPlatforms)
  end
end

function maybeGenerateNewFlyingObstacle(dt)
  -- TODO: Make chance of flying obstacle proportional to time passed (dt), somehow.
  if math.random(0, 1000) < 10 then
    local cameraX, cameraY = camera:toWorldCoords(0, 0)
    local x = cameraX + love.graphics.getWidth() + 100
    local y = math.random(cameraY, cameraY + love.graphics.getHeight())
    addEntity(FlyingObstacle(x, y))
  end
end

function maybeGenerateNewCollectables(dt)
  -- TODO: Make chance of collectable proportional to time passed (dt), somehow.
  if math.random(0, 1000) < 10 then
    generateCollectable(Slowdown, 80)
  end
  if math.random(0, 1000) < 10 then
    generateCollectable(Speedup, 40)
  end
end

local lastPlatformWithCollectable = nil
function generateCollectable(collectableConstructor, collectableHeight)
  local cameraX, cameraY = camera:toWorldCoords(0, 0)
  local minX = cameraX + love.graphics.getWidth() + 100

  local platforms = getPlatforms()
  local platform = nil
  for i, p in ipairs(platforms) do
    if p.x > minX then
      platform = p
      break
    end
  end

  if not (platform == nil or lastPlatformWithCollectable == platform) then
    -- todo(filip): the -6 is hardcoded to match the sin in collectable:update
    local y = platform.y - collectableHeight - 6
    local x = math.random(platform.x, platform.x + platform.w)
    addEntity(collectableConstructor(x, y))
    lastPlatformWithCollectable = platform
  end
end

return game
