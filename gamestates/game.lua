bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'
Gamestate = require 'libs.hump.gamestate'
lume = require 'libs.lume.lume'

local gameOver = require 'gamestates.gameOver'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'
FlyingObstacle = require 'entities.FlyingObstacle'
Brandy = require 'entities.Brandy'
Coffee = require 'entities.Coffee'
Musician = require 'entities.Musician'

misc = require 'misc'
generatePlatforms = require 'generatePlatforms'

-- TODO(matija): make these constants written in caps.
TILE_SIZE = 24
local gravity = 3000
ONE_METER_IN_PX = 100
gameSpeedFactor = 0.8
gameEffect = nil  -- Or 'coffee' or 'brandy'

local game = {}

local scanline
local player
local entities

local ballonsBackground = love.graphics.newImage('assets/balloons.png')
local ballonsBackgroundCoffee = love.graphics.newImage('assets/balloons_coffee.png')
local ballonsBackgroundBrandy = love.graphics.newImage('assets/balloons_brandy.png')
local cityBackground = love.graphics.newImage('assets/city_and_sidewalk_1080.png')
local cityBackgroundCoffee = love.graphics.newImage('assets/city_and_sidewalk_coffee_1080.png')
local cityBackgroundBrandy = love.graphics.newImage('assets/city_and_sidewalk_brandy_1080.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 0.02


function game:enter(oldState, playerConfig)
    math.randomseed( os.time() )

    -- Initialization -> important to do it here so every time the game
    -- restarts we start with the correct values.
    scanline = nil
    player = nil
    entities = {}

    love.graphics.setBackgroundColor(1, 1, 1)
    hudFont = love.graphics.newFont(18)

    world = bump.newWorld(TILE_SIZE)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    scanline = Scanline()
    addEntity(scanline)

    local platforms = generatePlatforms({x=0, y=800, width=200}, TILE_SIZE)
    addEntities(platforms)

    player = Player(platforms[1].x, platforms[1].y, playerConfig)
    addEntity(player)

    -- Initialize score count
    score = 0
    startingX = platforms[1].x

    local musician1Img = love.graphics.newImage('assets/guitar-player.png')
    local musician1ImgScale = 0.4
    local musician2Img = love.graphics.newImage('assets/guitar-player2.png')
    local musician2ImgScale = 0.45
    local musician3Img = love.graphics.newImage('assets/guitar-player3.png')
    local musician3ImgScale = 0.45
    local musicians = {
      Musician(scanline, 0, 200, 1, 150, 200, musician1Img, musician1ImgScale),
      Musician(scanline, 20, 300, -1, 150, 300, musician2Img, musician2ImgScale),
      Musician(scanline, -20, 500, -1, 100, 250, musician3Img, musician3ImgScale),
      Musician(scanline, 5, 600, 1, 100, 300, musician2Img, musician2ImgScale),
      Musician(scanline, 25, 650, 1, 200, 200, musician1Img, musician1ImgScale),
      Musician(scanline, -10, 800, 1, 200, 300, musician2Img, musician2ImgScale),
      Musician(scanline, -25, 900, -1, 150, 250, musician3Img, musician3ImgScale)
    }
    addEntities(musicians)
end

function game:update(dt)
    if player.x <= scanline.x or player.y > love.graphics.getHeight() * 2.5 then
      Gamestate.push(gameOver, score)
    end

    camera:update(dt)
    camera:follow(player.x, player.y)

    for i, e in ipairs(entities) do
      e:update(dt, world, gravity)
    end

    metersProgressed = (player.x - startingX) / ONE_METER_IN_PX
    backgroundScroll = metersProgressed * BACKGROUND_SCROLL_SPEED

    -- Update score
    score = math.max(score, metersProgressed)

    -- Increase game speed
    if (metersProgressed < 50) then gameSpeedFactor = 1
    else gameSpeedFactor = 1 + math.sqrt((metersProgressed - 50) / 200) * 0.5 end

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

function drawBackground(backgroundScroll)
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(1, 1, 1)

    local activeCityBackground, activeBalloonsBackground = getActiveBackgrounds()

    local ballonsWidth = activeBalloonsBackground:getWidth()
    local ballonsRatio = ballonsWidth / width
    for i = backgroundScroll / ballonsRatio, width / ballonsWidth do
      love.graphics.draw(activeBalloonsBackground, i * ballonsWidth, 0)
    end

    local yPos = height - activeCityBackground:getHeight()
    local cityWidth = activeCityBackground:getWidth()

    local cityRatio = cityWidth / width
    for i = backgroundScroll / cityRatio, width / cityWidth  do
      love.graphics.draw(activeCityBackground, i * cityWidth, yPos)
    end
end

function getActiveBackgrounds()
  if gameEffect == 'coffee' then return cityBackgroundCoffee, ballonsBackgroundCoffee end
  if gameEffect == 'brandy' then return cityBackgroundBrandy, ballonsBackgroundBrandy end
  return cityBackground, ballonsBackground
end


function game:draw()
    drawBackground(-backgroundScroll)

    camera:attach()

    for i, e in ipairs(entities) do
      e:draw()
    end

    -- For debugging/testing.
    -- love.graphics.line(0, -100, 5000, -100)
    -- love.graphics.line(
    --     0, love.graphics.getHeight() + 100, 5000,
    --     love.graphics.getHeight() + 100
    -- )

    camera:detach()

    -- HUD
    love.graphics.setFont(hudFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. tostring(lume.round(score)) .. "m", 10, 10)
    love.graphics.print("gameSpeedFactor: " .. tostring(gameSpeedFactor), 10, 30)
    love.graphics.print(
      'isJumpDurationTracked: ' .. tostring(player.isJumpDurationTracked), 10, 50
    )
    love.graphics.print('jumpDuration: ' .. tostring(player.jumpDuration), 10, 70)
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
  return filterEntities(function (e) return e.isPlatform end)
end

function getFlyingObstacles()
  return filterEntities(function (e) return e.isFlyingObstacle end)
end

function getCollectables()
  return filterEntities(function (e) return e.isCollectable end)
end

function generateNewPlatformsIfNeeded()
  local cameraX = camera:toWorldCoords(0, 0)

  local platforms = getPlatforms()
  local lastPlatform = platforms[#platforms]
  -- If reaching the end of generated platforms, generate more platforms.
  if lastPlatform and lastPlatform.x < cameraX + love.graphics.getWidth()*2 then
    local newPlatforms = generatePlatforms(
      {x=lastPlatform.x, y=lastPlatform.y, width=lastPlatform.w},
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
    generateCollectable(Brandy, 80)
  end
  if math.random(0, 1000) < 10 then
    generateCollectable(Coffee, 40)
  end
end

local lastPlatformWithCollectable = nil
function generateCollectable(collectableConstructor, collectableHeight)
  local cameraX, cameraY = camera:toWorldCoords(0, 0)
  local minX = cameraX + love.graphics.getWidth() + 100

  local platforms = getPlatforms()
  local platform = nil
  for i, p in ipairs(platforms) do
    if p.x > minX then platform = p break end
  end

  if not (platform == nil or lastPlatformWithCollectable == platform) then
    local y = platform.y - collectableHeight
    local x = math.random(platform.x, platform.x + platform.w)
    addEntity(collectableConstructor(x, y))
    lastPlatformWithCollectable = platform
  end
end

return game
