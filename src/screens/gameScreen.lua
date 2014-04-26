
local xshift = 0
local yshift = 0
local scale = 1

tilesize = 32

function gameScreen_init()
    
end

function gameScreen_update(dt)
    
end

function gameScreen_Camera_left()
    xshift = xshift + 100
end

function gameScreen_Camera_right()
    xshift = xshift - 100
end

function gameScreen_Camera_up()
    yshift = yshift + 100
end

function gameScreen_Camera_down()
    yshift = yshift - 100
end

function gameScreen_draw()
    
    love.graphics.translate(xshift, yshift)
    
    for i,layer in pairs(world.layers) do
        
        local baseHeight = (i - 1) * 6
        
        -- draw outline down
        local centerXIndex = math.floor(#layer.outer[1] / 2)
        local centerYIndex = math.floor(#layer.outer / 2)
        
        for j,row in pairs(layer.outer) do
            
            
            
            for k,entry in pairs(row) do
                if entry ~= nil then
                    love.graphics.draw(tileset[entry], 
                                        world.x + (k - centerXIndex) * tilesize, 
                                        world.y + (j - centerYIndex  - baseHeight) * tilesize,
                                        0, 1, 1, tilesize / 2, tilesize / 2)
                                    
                    love.graphics.rectangle("line", world.x - tilesize / 2 + (k - centerXIndex) * tilesize, 
                                                    world.y - tilesize / 2 + (j - centerYIndex - baseHeight) * tilesize, 
                                                    tilesize, tilesize)
                end
            end
            
        end
        
        if layer.active then
           --draw upper area
        end
    
    end
    
end
