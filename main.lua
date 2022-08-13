function love.load()
    Player = require "entities.Player"
    player = Player(100, 100)
end

function love.update(dt)
    -- TODO(matija): extract this to player or provide interface for the player.
    if love.keyboard.isDown("right") then
        player.x = player.x + 100 * dt
    end
    if love.keyboard.isDown("left") then
        player.x = player.x - 100 * dt
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - 100 * dt
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + 100 * dt
    end
end

function love.draw()
    love.graphics.print("Hello World, this is my arcade game", 400, 300)
    player:draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
