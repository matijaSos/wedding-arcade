Gamestate = require 'libs.hump.gamestate'
highscore = require 'libs.sick'

local menu = require 'gamestates.menu'
local game = require 'gamestates.game'
local gameOver = require 'gamestates.gameOver'

function love.load()
    highscore.set('highscore.txt', 5)

    love.window.setFullscreen(true, 'desktop')

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.quit()
    highscore.save()
    print("Thanks for playing! Come back soon!")
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end
end
