
-- lastPlatform is information about the previous platform, from which we
-- continue adding new platforms.
-- lastPlatform.x
-- lastPlatform.y
-- lastPlatform.width (in pixels)
--
-- TILE_SIZE is size of one tile in pixels.
local generatePlatforms = function (lastPlatform, tileSize)
    local minPlatformLengthInTiles = 4
    local maxPlatformLengthInTiles = 20

    local minY = -100
    local maxY = love.graphics.getHeight() + 100

    local minXDist = 20
    local maxXDist = 250

    local minYDist = 50
    local maxYDist = 200

    local platforms = {}

    local platformX = lastPlatform.x
    local platformY = lastPlatform.y
    local platformLengthInTiles = lastPlatform.width / tileSize

    for i=1, 20 do
        -- Determine data for the next platform.
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
        local platform = Platform(
          platformX, platformY,
          platformLengthInTiles * tileSize, tileSize * 2
        )

        table.insert(platforms, platform)
    end

    -- Add some supporting platforms
    -- TODO: Still, sometimes a generated platform might block important jump. Not often, but it can happen.
    --   Also, they are not super useful in game. They do give a feeling of more stuff on the screen which is nice,
    --   but they don't make game easier.
    --   Maybe better strategy would be to generate secondary train of platforms that follows some rules in order
    --   to not create problems for the main train of platforms?
    local numSupportingPlatforms = 15
    local minYDistForSupportingPlatform = 300
    local supportingPlatformsMinX = lastPlatform.x
    local supportingPlatformsMaxX = platforms[#platforms].x - 1
    for i = 1, numSupportingPlatforms do
      while true do
        local newPlatformLengthInTiles = math.random(
          minPlatformLengthInTiles, maxPlatformLengthInTiles
        )
        local newPlatform = Platform(
          math.random(supportingPlatformsMinX, supportingPlatformsMaxX),
          math.random(minY, maxY),
          newPlatformLengthInTiles * tileSize,
          tileSize * 2
        )

        local isPositionedOk = true
        for i=1,#platforms do
          local p = platforms[i]
          local isOverlappingViaX = not (p.x >= newPlatform.x + newPlatform.w or p.x + p.w <= newPlatform.x)
          local yDist = math.abs(newPlatform.y - p.y)
          if isOverlappingViaX and yDist <= minYDistForSupportingPlatform then isPositionedOk = false break end
        end

        if isPositionedOk then
          table.insert(platforms, newPlatform)
          break
        end
      end
    end

    table.sort(platforms, function (p1, p2) return p1.x < p2.x end)
    return platforms
end

function getRandomSign()
    if math.random(0, 1) == 0 then return -1 else return 1 end
end

function clamp(val, lower, upper)
    return math.max(lower, math.min(upper, val))
end

return generatePlatforms
