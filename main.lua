bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'

local tileSize = 16
local gravity = 1900

function love.load()
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    player = Player(100, 50)
    scanline = Scanline()

    -- Add some platforms
    entities = {player, scanline, unpack(generatePlatforms())}

    for i, e in ipairs(entities) do
        world:add(e, e:getRect())    
    end

    -- TODO(matija): should I do this here?
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
end

function love.update(dt)
    camera:update(dt)
    camera:follow(player.x, player.y)

    player:update(dt, world, gravity)
    scanline:update(dt)

    --print (player.x, player.y, len)
    print ('yVel:', player.yCurrVelocity)
    print('isGrounded:', player.isGrounded)
end

function love.draw()
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

function love.quit()
  print("Thanks for playing! Come back soon!")
end


-- TODO(matija): extract this to a separate file.
function generatePlatforms()
    local minPlatformLengthInTiles = 4
    local maxPlatformLengthInTiles = 20

    local minY = -100
    local maxY = love.graphics.getHeight() + 100

    local minXDist = 10
    local maxXDist = 200

    local minYDist = 50
    local maxYDist = 150

    local platforms = {}

    -- 1st platform
    local platformX = 0
    local platformY = 350
    local platformLengthInTiles = 7

    for i=1, 20 do
        table.insert(platforms,
            Platform(
                platformX, platformY,
                platformLengthInTiles * tileSize, tileSize * 2
            )
        )

        -- Determine data for the next platform
        local newPlatformLengthInTiles = math.random(
            minPlatformLengthInTiles, maxPlatformLengthInTiles
        )
        local newPlatformX = platformX + platformLengthInTiles * tileSize
                             + math.random (minXDist, maxXDist)
        local newPlatformY = clamp(
            platformY + getRandomSign() * math.random(minYDist, maxYDist),
            minY, maxY
        )

        platformX = newPlatformX
        platformY = newPlatformY
        platformLengthInTiles = newPlatformLengthInTiles
    end
    
    return platforms
end

function getRandomSign()
    if math.random(0, 1) == 0 then return -1 else return 1 end
end

function clamp(val, lower, upper)
    return math.max(lower, math.min(upper, val))
end
