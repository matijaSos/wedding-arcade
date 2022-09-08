
local loadMenuBgAssets = function ()
    return {
        cityBgImg = love.graphics.newImage('assets/city_and_sidewalk_1080.png'),
        balloonsBgImg = love.graphics.newImage('assets/balloons.png')
    }
end

local drawMenuBackground = function (bgAssets)
    local cityBgImg = bgAssets.cityBgImg
    local balloonsBgImg = bgAssets.balloonsBgImg
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setBackgroundColor(1,1,1)

    -- Background image
    love.graphics.setColor(1, 1, 1)

    -- Draw city
    love.graphics.draw(cityBgImg, 0, h - cityBgImg:getHeight())

    -- Add balloons on top
    for i = 0, w / balloonsBgImg:getWidth() do
        love.graphics.draw(balloonsBgImg, i * balloonsBgImg:getWidth(), 0)
    end

end

return { 
    loadMenuBgAssets = loadMenuBgAssets,
    drawMenuBackground = drawMenuBackground
}
