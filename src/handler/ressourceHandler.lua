
function ressourceHandler_loadTiles()
    
    tileset = {}
    
    local tileSource = love.image.newImageData("res/tileset.png")
    
    local imgData = love.image.newImageData(tilesize, tilesize)
    
    -- grass
    imgData:paste(tileSource, 0, 0, 8 * tilesize, 0, tilesize, tilesize)
    tileset["grass"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 0 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_dl"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 1 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_ul"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 2 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_ur"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 3 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_dr"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 4 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_d"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 5 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_l"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 6 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_u"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 7 * tilesize, 0, tilesize, tilesize)
    tileset["grass_edge_r"] = love.graphics.newImage(imgData)
    
    --cliff
    imgData:paste(tileSource, 0, 0, tilesize * 2, 1 * tilesize, tilesize, tilesize)
    tileset["cliff"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 0, 1 * tilesize, tilesize, tilesize)
    tileset["cliff_edge_l1"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 0, 2 * tilesize, tilesize, tilesize)
    tileset["cliff_edge_l2"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 0, 3 * tilesize, tilesize, tilesize)
    tileset["cliff_edge_l3"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, tilesize, 1 * tilesize, tilesize, tilesize)
    tileset["cliff_edge_r1"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, tilesize, 2 * tilesize, tilesize, tilesize)
    tileset["cliff_edge_r2"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, tilesize, 3 * tilesize, tilesize, tilesize)
    tileset["cliff_edge_r3"] = love.graphics.newImage(imgData)
    
end