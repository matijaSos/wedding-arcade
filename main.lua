Gamestate = require 'libs.hump.gamestate'

local menu = require 'gamestates.menu'
local game = require 'gamestates.game'
local pause = require 'gamestates.pause'

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    elseif Gamestate.current() == game and key == 'p' then
        Gamestate.push(pause)
    end
end


