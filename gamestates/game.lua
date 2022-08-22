bump = require 'libs.bump.bump'
Camera = require 'libs.stalker-x.Camera'
Gamestate = require 'libs.hump.gamestate'

local pause = require 'gamestates.pause'

Player = require 'entities.Player'
Platform = require 'entities.Platform'
Scanline = require 'entities.Scanline'
generatePlatforms = require 'generatePlatforms'

-- TODO(matija): make these constants written in caps.
local tileSize = 16
local gravity = 2100

local game = {}

function game:enter()
    math.randomseed( os.time() )

    love.graphics.setBackgroundColor(1, 1, 1)

    world = bump.newWorld(tileSize)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('PLATFORMER')

    player = Player(100, 50)
    scanline = Scanline()

    -- Add some platforms
    entities = {player, scanline, unpack(generatePlatforms(tileSize))}

    for i, e in ipairs(entities) do
        world:add(e, e:getRect())    
    end

end

function game:update(dt)
    if player.isCaught then
        Gamestate.push(pause)
    end

    camera:update(dt)
    camera:follow(player.x, player.y)

    player:update(dt, world, gravity)
    scanline:update(dt)
end

function game:draw()
    camera:attach()

    for i, e in ipairs(entities) do
        e:draw()
    end

    -- For debugging/testing.
    love.graphics.line(0, -100, 5000, -100)
    love.graphics.line(
        0, love.graphics.getHeight() + 100, 5000,
        love.graphics.getHeight() + 100
    )

    camera:detach()

    -- HUD
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: xxx", 10, 10)

end

return game
