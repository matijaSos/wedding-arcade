bump = require 'libs.bump.bump'

local tileSize = 16

function love.load()
    love.graphics.setBackgroundColor(1, 1, 1)

    world = bump.newWorld(tileSize)

    Player = require "entities.Player"
    player = Player(100, 100)

    -- Add some platforms
    Platform = require 'entities.Platform'
    p1 = Platform(120, 360, tileSize * 40, tileSize)
    p2 = Platform(140, 200, tileSize * 6, tileSize)

    entities = {p1, p2, player}
    for i, e in ipairs(entities) do
        world:add(e, e:getRect())    
    end
end

function love.update(dt)
    local dx = 0
    local dy = 0

    -- TODO(matija): extract this to player or provide interface for the player.
    if love.keyboard.isDown("right") then
        dx = 100 * dt
    end
    if love.keyboard.isDown("left") then
        dx = -100 * dt
    end
    if love.keyboard.isDown("up") then
        dy = -100 * dt
    end
    if love.keyboard.isDown("down") then
        dy = 100 * dt
    end

    local goalX = player.x + dx
    local goalY = player.y + dy

    player.x, player.y, collisions, len = world:move(player, goalX, goalY)
    print (player.x, player.y, len)
end

function love.draw()
    for i, e in ipairs(entities) do
        e:draw()
    end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
