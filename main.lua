function love.load()
    circleX = 100
    circleY = 200
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        circleX = circleX + 100 * dt
    elseif love.keyboard.isDown("left") then
        circleX = circleX - 100 * dt
    elseif love.keyboard.isDown("up") then
        circleY = circleY - 100 * dt
    elseif love.keyboard.isDown("down") then
        circleY = circleY + 100 * dt
    end
end

function love.draw()
    love.graphics.print("Hello World, this is my arcade game", 400, 300)
    love.graphics.circle("line", circleX, circleY, 50)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
