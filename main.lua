local Gamestate = require 'libs.hump.gamestate'
local highscore = require 'libs.sick'

local menu = require 'gamestates.menu'

function love.load()
    highscore.set('highscore.txt', 10)

    -- love.window.setFullscreen(true, 'desktop')
    love.window.setMode(1920, 1080)

    -- Print joystick info.
    local joysticks = love.joystick.getJoysticks()
    print('num of joysticks: ', #joysticks)
    for i, joystick in ipairs(joysticks) do
        print(joystick:getName())
    end

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
