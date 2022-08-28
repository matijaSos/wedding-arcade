bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'
Gamestate = require 'libs.hump.gamestate'

local gameOver = require 'gamestates.gameOver'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'
FlyingObstacle = require 'entities.FlyingObstacle'

generatePlatforms = require 'generatePlatforms'

-- TODO(matija): make these constants written in caps.
local tileSize = 16
local gravity = 3000

local game = {}

function getAllEntities()
  return concatTables(
    concatTables(
      {player, scanline},
      platforms
    ),
    flyingObstacles
  )
end

function game:enter()
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)
    hudFont = love.graphics.newFont(12)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')
    camera.scale = 2

    scanline = Scanline()
    platforms = generatePlatforms({x=0, y=400, width=100}, tileSize)
    player = Player(platforms[1].x, platforms[1].y)
    flyingObstacles = {}

    for i, e in ipairs(getAllEntities()) do
      world:add(e, e:getRect())
    end
end

function game:update(dt)
    if player.isCaught then
        Gamestate.push(gameOver)
    end

    camera:update(dt)
    camera:follow(player.x, player.y)

    player:update(dt, world, gravity)
    scanline:update(dt)
    updatePlatforms(dt, world)
    updateFlyingObstacles(dt, world)
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
    love.graphics.print("Score: xxx", 10, 10)
    love.graphics.print('isJumpActive: ' .. tostring(player.isJumpActive), 10, 30)
    love.graphics.print('jumpDuration: ' .. tostring(player.jumpDuration), 10, 50)

end

function updatePlatforms(dt, world)
  cameraLeftEdgeAsWorldX = camera:toWorldCoords(0, 0)
  cameraRightEdgeAsWorldX = camera:toWorldCoords(camera.w, 0)
  cameraWidthAsWorldDx = cameraRightEdgeAsWorldX - cameraLeftEdgeAsWorldX

  -- If reaching the end of generated platforms, generate more platforms.
  if platforms[#platforms].x < cameraRightEdgeAsWorldX + cameraWidthAsWorldDx then
    local lastPlatform = platforms[#platforms]
    local newPlatforms = generatePlatforms({x=lastPlatform.x, y=lastPlatform.y, width=lastPlatform.w}, tileSize)
    platforms = concatTables(platforms, newPlatforms)
    for i, e in ipairs(newPlatforms) do
      world:add(e, e:getRect())
    end
  end

  -- Remove platforms that are significantly behind the scanline and will never be visible again.
  for i, p in ipairs(platforms) do
    if p.x + p.w < scanline.x - cameraWidthAsWorldDx then
      table.remove(platforms, tablefind(platforms, p))
      world:remove(p)
    end
  end
end

function updateFlyingObstacles(dt, world)
  -- TODO: This is duplicated from updatePlatforms, take care of this duplication.
  cameraLeftEdgeAsWorldX = camera:toWorldCoords(0, 0)
  cameraRightEdgeAsWorldX = camera:toWorldCoords(camera.w, 0)
  cameraWidthAsWorldDx = cameraRightEdgeAsWorldX - cameraLeftEdgeAsWorldX

  for i, fo in ipairs(flyingObstacles) do
    fo:update(dt, world)
  end

  -- Remove flying objects that went significantly behind the scanline and will never be visible again.
  for i, fo in ipairs(flyingObstacles) do
    if fo.x < scanline.x - cameraWidthAsWorldDx then
      destroyFlyingObstacle(world, fo)
    end
  end

  -- TODO: Make chance of flying obstacle proportional to time passed (dt), somehow.
  if math.random(0, 1000) < 15 then
    flyingObstacle = generateFlyingObstacle(world)
  end
end

function generateFlyingObstacle(world)
  -- TODO: This is duplicated from updatePlatforms, take care of this duplication.
  cameraLeftEdgeAsWorldX, cameraTopEdgeAsWorldY = camera:toWorldCoords(0, 0)
  cameraRightEdgeAsWorldX, cameraBottomEdgeAsWorldY = camera:toWorldCoords(camera.w, camera.h)
  cameraWidthAsWorldDx = cameraRightEdgeAsWorldX - cameraLeftEdgeAsWorldX

  local x = cameraRightEdgeAsWorldX + 100
  local y = math.random(cameraTopEdgeAsWorldY, cameraBottomEdgeAsWorldY)

  flyingObstacle = FlyingObstacle(x, y)

  table.insert(flyingObstacles, flyingObstacle)
  world:add(flyingObstacle, flyingObstacle:getRect())

  return flyingObstacle
end

function destroyFlyingObstacle(world, flyingObstacle)
  table.remove(flyingObstacles, tablefind(flyingObstacles, flyingObstacle))
  world:remove(flyingObstacle)
end

-- TODO(matija): put this in misc.
function tablefind(tab, el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

function concatTables(t1, t2)
  local t3 = {unpack(t1)}
  for i=1,#t2 do
    t3[#t3+1] = t2[i]
  end
  return t3
end

return game
