bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'

local tileSize = 16
local gravity = 900

function love.load()
    love.graphics.setBackgroundColor(1, 1, 1)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    Player = require "entities.Player"
    player = Player(300, 50)

    -- Add some platforms
    Platform = require 'entities.Platform'
    p1 = Platform(120, 360, tileSize * 40, tileSize)
    p2 = Platform(140, 200, tileSize * 6, tileSize)

    entities = {p1, p2, player}
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

    camera:detach()

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: xxx", 10, 10)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
