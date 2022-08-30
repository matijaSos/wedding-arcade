
local loadMenuBgAssets = function ()
    return {
        backgroundImg = love.graphics.newImage('assets/pixel_art_city.png'),
        fillerBgImg = love.graphics.newImage('assets/sidewalk_and_sky.png'),
        balloonsBgImg = love.graphics.newImage('assets/balloons.png')
    }
end

local drawMenuBackground = function (bgAssets)
    local backgroundImg = bgAssets.backgroundImg
    local fillerBgImg = bgAssets.fillerBgImg
    local balloonsBgImg = bgAssets.balloonsBgImg

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setBackgroundColor(1,1,1)

    -- Background image
    love.graphics.setColor(1, 1, 1)
    -- Central img
    local sideSpaceWidth = (w - backgroundImg:getWidth()) / 2 
    love.graphics.draw(
        backgroundImg, 
        sideSpaceWidth,
        h - backgroundImg:getHeight()
    )
    -- Filling the sides, left and right simultaneously.
    for i = 0, sideSpaceWidth / fillerBgImg:getWidth() do
        local yPos = h - fillerBgImg:getHeight()
        local xPosLeft = sideSpaceWidth - (i + 1) * fillerBgImg:getWidth()
        love.graphics.draw(fillerBgImg, xPosLeft, yPos)
        
        local xPosRight = (w - sideSpaceWidth) + i * fillerBgImg:getWidth()
        love.graphics.draw(fillerBgImg, xPosRight, yPos)
    end

    -- Add balloons on top
    for i = 0, w / balloonsBgImg:getWidth() do
        love.graphics.draw(balloonsBgImg, i * balloonsBgImg:getWidth(), 0)
    end

end

return { 
    loadMenuBgAssets = loadMenuBgAssets,
    drawMenuBackground = drawMenuBackground
}
