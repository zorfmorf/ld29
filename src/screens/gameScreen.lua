
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

-- convert screen coordinates to world coordinates
function gameScreen_convertScreen(x, y)
    local nx = ((x - xshift) - love.graphics.getWidth() / 2) / scaleV[scale] + love.graphics.getWidth() / 2
    local ny = ((y - yshift) - love.graphics.getHeight() / 2) / scaleV[scale] + love.graphics.getHeight() / 2
    return nx, ny
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
             
             -- draw tiles
            for j,row in pairs(layer.inner) do
            
                for k,entry in pairs(row) do
                    
                    if entry ~= nil then
                        
                        -- check for mouse position. again the bad style shit
                        --if mouse hover then draw reddish
                        local x, y = gameScreen_convertScreen( love.mouse.getPosition() )
                        if math.abs(x - (world.x + (k - centerXIndex) * tilesize)) < tilesize / 2 and
                            math.abs(y - (world.y + (j - centerYIndex  - baseHeight) * tilesize)) < tilesize / 2 then
                            
                            -- bad style but we will use this place to handle clicks as we already know everything relevant
                            if love.mouse.isDown( "l" ) then 
                                gameHandler_areaClicked(k, j)
                            
                            end
                        end
                        
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
        
            --draw structures
            for i,structure in pairs(layer.structures) do
                
                --if mouse hover then draw reddish
                local x, y = gameScreen_convertScreen( love.mouse.getPosition() )
                if structure.flagged ~= false or
                    (math.abs(x - (world.x + (structure.x - centerXIndex) * tilesize)) < tilesize / 2 and
                    math.abs(y - (world.y + (structure.y - centerYIndex  - baseHeight) * tilesize)) < tilesize / 2) then
                    love.graphics.setColor(230, 130, 130, 150)
                    
                    -- bad style but we will use this place to handle clicks as we already know everything relevant
                    if love.mouse.isDown( "l" ) then gameHandler_structureClicked(i) end
                    
                    if structure.__name == "hut" and structure:upgradable() then
                        love.graphics.setColor(130, 230, 130, 255)
                        love.graphics.draw(tileset["arrow_up"], 
                                            world.x + (structure.x - centerXIndex) * tilesize, 
                                            world.y + (structure.y - centerYIndex  - baseHeight) * tilesize - tilesize * 0.8,
                                            0, 1, 1, tilesize / 2, tilesize / 2)
                    end
                end
                
                love.graphics.draw(tileset[structure:getImage()], 
                                            world.x + (structure.x - centerXIndex) * tilesize, 
                                            world.y + (structure.y - centerYIndex  - baseHeight) * tilesize,
                                            0, 1, 1, tilesize / 2, tilesize / 2)
                if structure.__name == "shaft_bottom" then
                    love.graphics.draw(tileset["shaft_up"], 
                                            world.x + (structure.x - centerXIndex) * tilesize, 
                                            world.y + (structure.y - centerYIndex  - baseHeight) * tilesize - tilesize,
                                            0, 1, 1, tilesize / 2, tilesize / 2)
                    
                end
                
                love.graphics.setColor(255, 255, 255, 255)
            end
            
            for i,guy in pairs(layer.villager) do
                love.graphics.draw(villager, 
                                    world.x + (guy.x - centerXIndex) * tilesize, 
                                    world.y + (guy.y - centerYIndex  - baseHeight) * tilesize - tilesize,
                                    0, 1, 1, 4, -tilesize - 4)
            end
            
            break
        
        end
    
    end

    -- definition line
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.line(world.x + tilesize / 2, world.y + tilesize * 4 - tilesize / 2, world.x + tilesize / 2, lineHeight + tilesize / 2)
    
    -- now draw the hud
    love.graphics.origin()
    love.graphics.setColor(255, 255, 255, 255)
    
    -- ressource display
    local sh = 10
    for i,res in pairs(ressources) do
        
        love.graphics.draw(tileset[i], love.graphics.getWidth() - tilesize - 5, sh)
        love.graphics.print(res, love.graphics.getWidth() - tilesize - 30, sh + tilesize / 3)
        sh = sh + 40
        
    end
    
    
    -- scale arrows
    local x, y = love.mouse.getPosition()
    
    if gameHandler_canGoDown() then
        love.graphics.setColor(255, 255, 255, 255)
        local sc = 1
        if math.abs(x - (love.graphics.getWidth() - tilesize - 5)) < tilesize / 1.5 and 
            math.abs(y - (love.graphics.getHeight() - tilesize * 8)) < tilesize / 1.5 then
            
            sc = 1.5
        end
        
        love.graphics.draw(tileset["arrow_down"], love.graphics.getWidth() - tilesize - 5, love.graphics.getHeight() - tilesize * 8, 0, 
                        sc, sc, tilesize / 2, tilesize / 2)
    end
    
    if not world.layers[5].active then
        love.graphics.setColor(255, 255, 255, 255)
        local sc = 1
        if math.abs(x - (love.graphics.getWidth() - tilesize - 5)) < tilesize / 1.5 and 
            math.abs(y - (love.graphics.getHeight() - tilesize * 10 - 5)) < tilesize / 1.5 then
            
            sc = 1.5
        end
        love.graphics.draw(tileset["arrow_up"], love.graphics.getWidth() - tilesize - 5, love.graphics.getHeight() - tilesize * 10 - 5, 0,
                            sc, sc, tilesize / 2, tilesize / 2)
    end
    
    --build panel
    sh = 10
    for i,build in pairs(buildings) do
        
        love.graphics.setColor(255, 255, 255, 255)
        
        if world.layers[1].active or not gameHandler_LevelCanBeBuilt() or not build:affordable() 
            or (not gameHandler_isTopLevel() and build.__name == "hut") then 
            love.graphics.setColor(100, 100, 100, 150)
        else
            
            
            if math.abs((love.graphics.getWidth() - tilesize - sh) - (x - tilesize / 2)) < tilesize / 2 and
               math.abs((love.graphics.getHeight() - tilesize * 1.5) - (y - tilesize / 2)) < tilesize / 2 then
                love.graphics.setColor(230, 130, 130, 150)
                
                -- bad style but we will use this place to handle clicks as we already know everything relevant
                if love.mouse.isDown( "l" ) then gameHandler_buildClicked(i) end
            end
        end
        
        love.graphics.draw(tileset[i], love.graphics.getWidth() - tilesize - sh, love.graphics.getHeight() - tilesize * 1.5)
        sh = sh + 40
        
    end
    
    -- draw mouse icon if necessary
    
    if gameState ~= "free" then
        love.graphics.draw(tileset[gameState], love.mouse.getX(), love.mouse.getY(), 0, 1, 1, tilesize / 2, tilesize / 2)
    end
    
    if state == "gameover" then
        love.graphics.setColor(0, 0, 0, 150)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 100, 100, 200)
        love.graphics.print("Game over")
    end

end

function gameScreen_click(x, y)
    
    if math.abs(x - (love.graphics.getWidth() - tilesize - 5)) < tilesize / 1.5 and
        math.abs(y - (love.graphics.getHeight() - tilesize * 8)) < tilesize / 1.5 and
        gameHandler_canGoDown() then
        gameHandler_layerdown()
    end
    
    if math.abs(x - (love.graphics.getWidth() - tilesize - 5)) < tilesize / 1.5 and 
        math.abs(y - (love.graphics.getHeight() - tilesize * 10 - 5)) < tilesize / 1.5 and
        not world.layers[5].active then
        gameHandler_layerup()
    end
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