Gamestate = require 'libs.hump.gamestate'

local menu = require 'gamestates.menu'
local game = require 'gamestates.game'
local gameOver = require 'gamestates.gameOver'

function love.load()
    love.window.setFullscreen(true, 'desktop')

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end
    --[[
    elseif Gamestate.current() == game and key == 'p' then
        Gamestate.push(gameOver)
    end
    ]]--
end
