local Gamestate = require 'libs.hump.gamestate'
local highscore = require 'libs.sick'

local menu = require 'gamestates.menu'

function love.load()
    -- This file is stored in special folder where Love files are saved.
    -- Check https://love2d.org/wiki/love.filesystem for detailed info.
    -- On archlinux, this resolves to ~/.local/share/love/... .
    highscore.set('highscore.txt', 10)

    love.window.setFullscreen(true, 'desktop')
    --love.window.setMode(1920, 1080)

    -- Print joystick info.
    local joysticks = love.joystick.getJoysticks()
    print('num of joysticks: ', #joysticks)
    for i, joystick in ipairs(joysticks) do
        print(joystick:getName())
        print('button count: ', joystick:getButtonCount())
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
