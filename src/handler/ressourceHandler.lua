
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
    
    -- "rock" sort of terrain
    imgData:paste(tileSource, 0, 0, 9 * tilesize , 1 * tilesize, tilesize, tilesize)
    tileset["dirt"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 3 * tilesize, tilesize, tilesize, tilesize)
    tileset["dirt_edge_dl"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 4 * tilesize, tilesize, tilesize, tilesize)
    tileset["dirt_edge_ul"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 5 * tilesize, tilesize, tilesize, tilesize)
    tileset["dirt_edge_ur"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 6 * tilesize, tilesize, tilesize, tilesize)
    tileset["dirt_edge_dr"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 7 * tilesize, tilesize, tilesize, tilesize)
    tileset["dirt_edge_d"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 8 * tilesize, tilesize, tilesize, tilesize)
    tileset["dirt_edge_u"] = love.graphics.newImage(imgData)
    
    --buildings and placeables
    imgData:paste(tileSource, 0, 0, 3 * tilesize, 2 * tilesize, tilesize, tilesize)
    tileset["hut1"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 4 * tilesize, 2 * tilesize, tilesize, tilesize)
    tileset["shaft"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 4 * tilesize, 3 * tilesize, tilesize, tilesize)
    tileset["shaft_up"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 4 * tilesize, 4 * tilesize, tilesize, tilesize)
    tileset["shaft_bottom"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 5 * tilesize, 4 * tilesize, tilesize, tilesize)
    tileset["rocks1"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 6 * tilesize, 4 * tilesize, tilesize, tilesize)
    tileset["rocks2"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 2 * tilesize, 3 * tilesize, tilesize, tilesize)
    tileset["tree1"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 3 * tilesize, 3 * tilesize, tilesize, tilesize)
    tileset["tree2"] = love.graphics.newImage(imgData)
    
    
    --icons
    imgData:paste(tileSource, 0, 0, 0, 4 * tilesize, tilesize, tilesize)
    tileset["wood"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, tilesize, 4 * tilesize, tilesize, tilesize)
    tileset["stone"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, 0, 6 * tilesize, tilesize, tilesize)
    tileset["arrow_up"] = love.graphics.newImage(imgData)
    imgData:paste(tileSource, 0, 0, tilesize, 6 * tilesize, tilesize, tilesize)
    tileset["arrow_down"] = love.graphics.newImage(imgData)
    
end