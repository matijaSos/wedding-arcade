local loadMenuBgAssets = function()
    return {
        cityBgImg = love.graphics.newImage('assets/city_2/7.png'),
    }
end

local drawMenuBackground = function(bgAssets)
    local cityBgImg = bgAssets.cityBgImg
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setBackgroundColor(1, 1, 1)

    -- Background image
    love.graphics.setColor(1, 1, 1)

    -- Draw city
    love.graphics.draw(cityBgImg, 0, h - cityBgImg:getHeight())
end

return {
    loadMenuBgAssets = loadMenuBgAssets,
    drawMenuBackground = drawMenuBackground
}
