
local generatePlatforms = function (tileSize)
    local minPlatformLengthInTiles = 4
    local maxPlatformLengthInTiles = 20

    local minY = -100
    local maxY = love.graphics.getHeight() + 100

    local minXDist = 10
    local maxXDist = 200

    local minYDist = 50
    local maxYDist = 150

    local platforms = {}

    -- 1st platform
    local platformX = 0
    local platformY = 350
    local platformLengthInTiles = 7

    for i=1, 20 do
        table.insert(platforms,
            Platform(
                platformX, platformY,
                platformLengthInTiles * tileSize, tileSize * 2
            )
        )

        -- Determine data for the next platform
        local newPlatformLengthInTiles = math.random(
            minPlatformLengthInTiles, maxPlatformLengthInTiles
        )
        local newPlatformX = platformX + platformLengthInTiles * tileSize
                             + math.random (minXDist, maxXDist)
        local newPlatformY = clamp(
            platformY + getRandomSign() * math.random(minYDist, maxYDist),
            minY, maxY
        )

        platformX = newPlatformX
        platformY = newPlatformY
        platformLengthInTiles = newPlatformLengthInTiles
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
