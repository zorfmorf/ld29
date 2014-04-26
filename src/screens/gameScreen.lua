
local xshift = 0
local yshift = 0
local scale = 2
local scaleV = {0.5, 0.7, 0.85, 1, 1.15, 1.3, 1.5}

tilesize = 32

local bkg = nil

function gameScreen_init()
    
end

function gameScreen_update(dt)
    
end

function gameScreen_generateBackground(imgData)
    
    for i = 0,imgData:getHeight() - 1 do
       
        local factor = math.max(0, i - love.graphics:getHeight() / 1.9) / (imgData:getHeight() - 1) 
       
        for j= 0,imgData:getWidth() - 1 do
            

            local r, g, b, a = imgData:getPixel(j, i)
            
            imgData:setPixel(j, i, r, g, b, math.floor(a * factor))
           
        end
        
    end
    
    bkg = love.graphics.newImage(imgData)
end

function gameScreen_draw()
    
    love.graphics.setBackgroundColor(0, 0, 0, 255)
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(bkg, 0, 0)
    
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics:getHeight() / 2)
    love.graphics.scale(scaleV[scale], scaleV[scale])
    love.graphics.translate(-love.graphics.getWidth() / 2, -love.graphics:getHeight() / 2)
    
    
    love.graphics.translate(xshift / scaleV[scale], yshift / scaleV[scale])
    
    love.graphics.setColor(255, 255, 255, 255)
    
    local lineHeight = 0
    
    for i,layer in pairs(world.layers) do
        
        lineHeight = lineHeight + 1
        
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
                                    
                    --love.graphics.rectangle("line", world.x - tilesize / 2 + (k - centerXIndex) * tilesize, 
                     --                               world.y - tilesize / 2 + (j - centerYIndex - baseHeight) * tilesize, 
                    --                                tilesize, tilesize)
                end
            end

        end
        
        if layer.active then
            
            baseHeight = baseHeight + math.floor(#layer.inner / 2 + 0.5)
                        
            for j,row in pairs(layer.inner) do
            
                for k,entry in pairs(row) do
                    
                    if entry ~= nil then
                        love.graphics.draw(tileset[entry], 
                                            world.x + (k - centerXIndex) * tilesize, 
                                            world.y + (j - centerYIndex  - baseHeight) * tilesize,
                                            0, 1, 1, tilesize / 2, tilesize / 2)
                                        
                        lineHeight = world.y + (j - centerYIndex  - baseHeight) * tilesize
                                        
                        --love.graphics.rectangle("line", world.x - tilesize / 2 + (k - centerXIndex) * tilesize, 
                        --                                world.y - tilesize / 2 + (j - centerYIndex - baseHeight) * tilesize, 
                         --                               tilesize, tilesize)
                    end
                end
            
            end
            
            break
        
        end
    
    end

    -- definition line
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.line(world.x + tilesize / 2, world.y + tilesize * 4 - tilesize / 2, world.x + tilesize / 2, lineHeight + tilesize / 2)
    
end

function gameScreen_Camera_shift(x , y)
   
   xshift = xshift + x
   yshift = yshift + y
    
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

function gameScreen_Camera_zoomOut()
    scale = math.min(scale + 1, #scaleV)
end

function gameScreen_Camera_zoomIn()
    scale = math.max(scale - 1, 1)
end