bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'
Gamestate = require 'libs.hump.gamestate'
lume = require 'libs.lume.lume'

local gameOver = require 'gamestates.gameOver'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'
FlyingObstacle = require 'entities.FlyingObstacle'

misc = require 'misc'
generatePlatforms = require 'generatePlatforms'

-- TODO(matija): make these constants written in caps.
local tileSize = 16
local gravity = 3000

local game = {}

function getAllEntities()
  return misc.concatTables(
    misc.concatTables(
      {player, scanline},
      platforms
    ),
    flyingObstacles
  )
end

function game:enter(oldState, playerConfig)
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)
    hudFont = love.graphics.newFont(12)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    scanline = Scanline()
    platforms = generatePlatforms({x=0, y=400, width=100}, tileSize)
    player = Player(platforms[1].x, platforms[1].y, playerConfig)
    flyingObstacles = {}

    for i, e in ipairs(getAllEntities()) do
      world:add(e, e:getRect())
    end

    -- Initialize score count
    score = 0
    startingX = platforms[1].x
end

function game:update(dt)
    if player.isCaught then
        Gamestate.push(gameOver, score)
    end

    camera:update(dt)
    camera:follow(player.x, player.y)

    player:update(dt, world, gravity)
    scanline:update(dt)
    updatePlatforms(dt, world)
    updateFlyingObstacles(dt, world)

    -- Update score
    score = math.max(score, player.x - startingX)
end

function game:draw()
    camera:attach()

    for i, e in ipairs(getAllEntities()) do
        e:draw()
    end

    -- For debugging/testing.
    love.graphics.line(0, -100, 5000, -100)
    love.graphics.line(
        0, love.graphics.getHeight() + 100, 5000,
        love.graphics.getHeight() + 100
    )

    camera:detach()

    -- HUD
    love.graphics.setFont(hudFont)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. tostring(lume.round(score)), 10, 10)
    love.graphics.print('isJumpDurationTracked: ' .. tostring(player.isJumpDurationTracked), 10, 30)
    love.graphics.print('jumpDuration: ' .. tostring(player.jumpDuration), 10, 50)

end

function game:leave()
end

function updatePlatforms(dt, world)
  cameraX = camera:toWorldCoords(0, 0)

  -- If reaching the end of generated platforms, generate more platforms.
  if platforms[#platforms].x < cameraX + love.graphics.getWidth()*2 then
    local lastPlatform = platforms[#platforms]
    local newPlatforms = generatePlatforms({x=lastPlatform.x, y=lastPlatform.y, width=lastPlatform.w}, tileSize)
    platforms = misc.concatTables(platforms, newPlatforms)
    for i, e in ipairs(newPlatforms) do
      world:add(e, e:getRect())
    end
  end

  -- Remove platforms that are significantly behind the scanline and will never be visible again.
  for i, p in ipairs(platforms) do
    if p.x + p.w < scanline.x - love.graphics.getWidth() then
      table.remove(platforms, misc.tablefind(platforms, p))
      world:remove(p)
    end
  end
end

function updateFlyingObstacles(dt, world)
  cameraX = camera:toWorldCoords(0, 0)

  for i, fo in ipairs(flyingObstacles) do
    fo:update(dt, world)
  end

  -- Remove flying objects that went significantly left from the camera.
  for i, fo in ipairs(flyingObstacles) do
    if fo.x < cameraX - love.graphics.getWidth() then
      destroyFlyingObstacle(world, fo)
    end
  end

  -- TODO: Make chance of flying obstacle proportional to time passed (dt), somehow.
  if math.random(0, 1000) < 15 then
    flyingObstacle = generateFlyingObstacle(world)
  end
end

function generateFlyingObstacle(world)
  cameraX, cameraY = camera:toWorldCoords(0, 0)
  local x = cameraX + love.graphics.getWidth() + 100
  local y = math.random(cameraY, cameraY + love.graphics.getHeight())

  flyingObstacle = FlyingObstacle(x, y)

  table.insert(flyingObstacles, flyingObstacle)
  world:add(flyingObstacle, flyingObstacle:getRect())

  return flyingObstacle
end

function destroyFlyingObstacle(world, flyingObstacle)
  table.remove(flyingObstacles, misc.tablefind(flyingObstacles, flyingObstacle))
  world:remove(flyingObstacle)
end

return game
