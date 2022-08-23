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
local gravity = 2100

local game = {}

function game:enter()
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    player = Player(100, 50)
    scanline = Scanline()

    -- Add some platforms
    entities = {player, scanline, unpack(generatePlatforms(tileSize))}

    for i, e in ipairs(entities) do
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

    for i, e in ipairs(entities) do
      if e.isFlyingObstacle then
        e:update(dt, world)
      end
    end

    -- Remove flying objects that went significantly left from the camera.
    cameraX = camera:toWorldCoords(0, 0)
    for i, e in ipairs(entities) do
      if e.isFlyingObstacle then
        if e.x < cameraX - love.graphics.getWidth() then
          destroyFlyingObstacle(entities, world, e)
        end
      end
    end

    -- TODO: Make chance of flying obstacle proportional to time passed (dt), somehow.
    if math.random(0, 1000) < 10 then
      flyingObstacle = generateFlyingObstacle(entities, world)
    end

end

function game:draw()
    camera:attach()

    for i, e in ipairs(entities) do
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
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: xxx", 10, 10)

end

function generateFlyingObstacle(entities, world)
  cameraX, cameraY = camera:toWorldCoords(0, 0)
  local x = cameraX + love.graphics.getWidth() + 100
  local y = math.random(cameraY, cameraY + love.graphics.getHeight())

  flyingObstacle = FlyingObstacle(x, y)

  table.insert(entities, flyingObstacle)
  world:add(flyingObstacle, flyingObstacle:getRect())

  return flyingObstacle
end

function destroyFlyingObstacle(entities, world, flyingObstacle)
  table.remove(entities, tablefind(entities, flyingObstacle))
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

return game
