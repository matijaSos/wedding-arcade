bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'
Gamestate = require 'libs.hump.gamestate'

local gameOver = require 'gamestates.gameOver'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'
FlyingObstacle = require 'entities.FlyingObstacle'
Brandy = require 'entities.Brandy'
Musician = require 'entities.Musician'

misc = require 'misc'
generatePlatforms = require 'generatePlatforms'

-- TODO(matija): make these constants written in caps.
local tileSize = 32
local gravity = 3000

local scanline = nil
local player = nil
local game ={}
local entities = {}


function game:enter(oldState, playerConfig)
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)
    hudFont = love.graphics.newFont(18)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    scanline = Scanline()
    addEntity(scanline)

    local platforms = generatePlatforms({x=0, y=800, width=200}, tileSize)
    addEntities(platforms)

    player = Player(platforms[1].x, platforms[1].y, playerConfig)
    addEntity(player)

    local musicians = {
      Musician(scanline, 200, 1, 150, 200),
      Musician(scanline, 400, -1, 150, 300),
      Musician(scanline, 500, -1, 100, 250),
      Musician(scanline, 600, 1, 100, 300),
      Musician(scanline, 650, 1, 200, 200),
      Musician(scanline, 800, 1, 200, 300),
      Musician(scanline, 900, -1, 150, 250)
    }
    addEntities(musicians)
end

function game:update(dt)
    if player.x <= scanline.x or player.y > love.graphics.getWidth() * 2.5 then
      Gamestate.push(gameOver)
    end

    camera:update(dt)
    camera:follow(player.x, player.y)

    for i, e in ipairs(entities) do
      e:update(dt, world, gravity)
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

function game:draw()
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
    love.graphics.print("Score: xxx", 10, 10)
    love.graphics.print(
      'isJumpDurationTracked: ' .. tostring(player.isJumpDurationTracked), 10, 30
    )
    love.graphics.print('jumpDuration: ' .. tostring(player.jumpDuration), 10, 50)
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
      tileSize
    )
    addEntities(newPlatforms)
  end
end

function maybeGenerateNewFlyingObstacle(dt)
  -- TODO: Make chance of flying obstacle proportional to time passed (dt), somehow.
  if math.random(0, 1000) < 15 then
    local cameraX, cameraY = camera:toWorldCoords(0, 0)
    local x = cameraX + love.graphics.getWidth() + 100
    local y = math.random(cameraY, cameraY + love.graphics.getHeight())
    addEntity(FlyingObstacle(x, y))
  end
end

function maybeGenerateNewCollectables(dt)
  -- TODO: Make chance of collectable proportional to time passed (dt), somehow.
  if math.random(0, 1000) < 10 then
    generateBrandy()
  end
end

local lastPlatformWithBrandy = nil
function generateBrandy()
  local cameraX, cameraY = camera:toWorldCoords(0, 0)
  local minX = cameraX + love.graphics.getWidth() + 100

  local platforms = getPlatforms()
  local platform = nil
  for i, p in ipairs(platforms) do
    if p.x > minX then platform = p break end
  end

  if not (platform == nil or lastPlatformWithBrandy == platform) then
    -- TODO: 40 is now hardcoded! Get the number from Brandy somehow, based on Brandies height?
    local y = platform.y - 80
    local x = math.random(platform.x, platform.x + platform.w)
    addEntity(Brandy(x, y))
    lastPlatformWithBrandy = platform
  end
end

return game
