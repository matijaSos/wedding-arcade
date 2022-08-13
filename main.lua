function love.load()
    circleX = 100
    circleY = 200

    Object = require "lib.classic.classic"
    require "Player"
    player = Player(100, 100)
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + 100 * dt
    elseif love.keyboard.isDown("left") then
        player.x = player.x - 100 * dt
    elseif love.keyboard.isDown("up") then
        player.y = player.y - 100 * dt
    elseif love.keyboard.isDown("down") then
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
