-- lastPlatform is information about the previous platform, from which we
-- continue adding new platforms.
-- lastPlatform.x
-- lastPlatform.y
-- lastPlatform.width (in pixels)
--
-- TILE_SIZE is size of one tile in pixels.
local generatePlatforms = function(lastPlatform, tileSize)
    local minPlatformLengthInTiles = 2
    local maxPlatformLengthInTiles = 10

    local minY = -100
    local maxY = love.graphics.getHeight() + 100

    local minXDist = 20
    local maxXDist = 300

    local minYDist = 50
    local maxYDist = 250

    local platforms = {}

    local platformX = lastPlatform.x
    local platformY = lastPlatform.y
    local platformLengthInTiles = lastPlatform.width / tileSize

    for i = 1, 20 do
        -- Determine data for the next platform.
        local newPlatformLengthInTiles = math.random(
            minPlatformLengthInTiles, maxPlatformLengthInTiles
        )
        local newPlatformX = platformX + platformLengthInTiles * tileSize
            + math.random(minXDist, maxXDist)
        local newPlatformY = clamp(
            platformY + getRandomSign() * math.random(minYDist, maxYDist),
            minY, maxY
        )

        platformX = newPlatformX
        platformY = newPlatformY
        platformLengthInTiles = newPlatformLengthInTiles

        table.insert(platforms,
            Platform(platformX, platformY, platformLengthInTiles, TILE_SIZE, TILE_SIZE)
        )
    end

    return platforms
end

function getRandomSign()
    if math.random(0, 1) == 0 then return -1 else return 1 end
end

function clamp(val, lower, upper)
    return math.max(lower, math.min(upper, val))
end

return generatePlatforms
