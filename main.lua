bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'

Player = require "entities.Player"
Platform = require 'entities.Platform'

local tileSize = 16
local gravity = 900

function love.load()
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    player = Player(300, 50)

    -- Add some platforms
    entities = {player, unpack(generatePlatforms())}

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

    local dx = 0
    local dy = 0

    -- TODO(matija): extract this to player or provide interface for the player.
    if love.keyboard.isDown("right") then
        dx = player.xMovSpeed * dt
    end
    if love.keyboard.isDown("left") then
        dx = -player.xMovSpeed * dt
    end
    
    -- Apply gravity
    if not player.isGrounded then
        player.yCurrVelocity = player.yCurrVelocity + gravity * dt
    end

    if love.keyboard.isDown('up') and player.isGrounded then
        player.yCurrVelocity = -600
        --player.isGrounded = false
    end

    dy = player.yCurrVelocity * dt

    local goalX = player.x + dx
    local goalY = player.y + dy

    player.x, player.y, collisions, collLen = world:move(player, goalX, goalY)

    -- If e.g. player walks or jumps off the platform, we want
    -- him to start falling.
    if collLen == 0 then
        player.isGrounded = false
    end

    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then
            -- Couldn't go as high as wanted - blocked from above
            -- (e.g. when jumping, bumped head in the platform above).
            player.yCurrVelocity = 0

        -- NOTE(matija): Checking normal is important because want player to keep
        -- falling if there was a side collision (e.g. against a wall). Normal
        -- will be -1 in case of the floor collision.
        elseif coll.normal.y < 0 then
            -- Couldn't go as low as wanted - blocked from below (e.g. fell on the
            -- ground).
            player.isGrounded = true
            player.yCurrVelocity = 0
        end

        print ('normal', coll.normal.y)
    end


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


    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: xxx", 10, 10)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end


function generatePlatforms()
    local minPlatformLengthInTiles = 4
    local maxPlatformLengthInTiles = 20

    local minY = -100
    local maxY = love.graphics.getHeight() + 100

    local minXDist = 10
    local maxXDist = 200

    local minYDist = 50
    local maxYDist = 200

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
