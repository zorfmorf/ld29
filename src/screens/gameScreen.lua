
local xshift = 0
local yshift = 0
local scale = 1

local tilesize = 32

function gameScreen_init()
    
end

function gameScreen_update(dt)
    
end

function gameScreen_draw()
    
    love.graphics.translate(xshift, yshift)
    
    for i,layer in pairs(world.layers) do
        
        for j,row in pairs(layer.tiles) do
            
            for k,entry in pairs(row) do
                
                local centerIndex = math.floor(#layer.tiles / 2 + 0.5) 
                print(centerIndex)
                
                if entry == 1 then
                    love.graphics.rectangle("line", world.x - tilesize / 2 + (k - centerIndex) * tilesize, 
                                                    world.y - tilesize / 2 + (j - centerIndex) * tilesize, 
                                                    tilesize, tilesize)
                end
                
            end
        
        end
        
    end
    
end
