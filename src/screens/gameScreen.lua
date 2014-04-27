
local xshift = 0
local yshift = 0
local scale = 4
local scaleV = {0.9, 1, 1.15, 1.3, 1.5}

tilesize = 32

local startupTime = 5

local stars = nil
local bkg = nil
local bkgrotation = 0

local finstate = 0
local fintimer = 0
local fintimer2 = 0
local findirection = 0
local particles = nil
local finFont = nil
local finalpha = 0

local brightness = 190 -- if < 255 it dimms the whole world down

function gameScreen_init()
    finFont = love.graphics.newFont("font/SFPixelate.ttf", 80)
    questFont = love.graphics.newFont("font/SFPixelate.ttf",22)
    local size = math.max(love.graphics:getWidth(), love.graphics:getHeight())
    local imgData = love.image.newImageData(size, size)
    for i=1,size*2 do
        
        local x, y = math.random(1, size - 2), math.random(1, size - 2)
       
        imgData:setPixel(x, y, 255, 255, 255, 255)
        imgData:setPixel(x + 1, y,  255, 255, 255, 100)
        imgData:setPixel(x, y + 1, 255, 255, 255, 100)
        imgData:setPixel(x - 1, y, 255, 255, 255, 100)
        imgData:setPixel(x, y - 1, 255, 255, 255, 100)
        
    end
    stars = love.graphics.newImage(imgData)
    
    -- generate ending particle system
    local system = love.graphics.newParticleSystem( love.graphics.newImage("res/fire.png"), 400 )
    system:setPosition( 0, 0 )
    system:setOffset( 0, 0 )
    system:setBufferSize( 1000 )
    system:setEmissionRate( 200 )
    system:setEmitterLifetime( -1 )
    system:setParticleLifetime( 5, 5 )
    system:setColors( 255, 100, 0, 0, 255, 255, 0, 123 )
    system:setSizes( 1, 3, 1 )
    system:setSpeed( 400, 500  )
    system:setDirection( math.rad(270) )
    system:setSpread( math.rad(60) )
    system:setRotation( math.rad(0), math.rad(0) )
    system:setSpin( math.rad(0.5), math.rad(1), 1 )
    system:setRadialAcceleration( 0 )
    system:setTangentialAcceleration( 0 )
    system:setLinearAcceleration( 0, 200, 0, 400 )
    
    particles = system

end

function gameScreen_update(dt)
    
    if startupTime > 0 then
        startupTime = math.max(0, startupTime - dt)
        if startupTime == 0 then questHandler_start() end
    end
    
    bkgrotation = bkgrotation - dt * 0.01
    
    if state == "fin" then
        
        
        fintimer = fintimer + dt
        
        if finstate == 0 then
            scale = 5
            
            if gameHandler_isBottomLevel() and yshift <= -1000 and xshift == 0 then
                finstate = 1
                fintimer = 0
            end
            
            if not gameHandler_isBottomLevel() and fintimer > 1 then
                fintimer = 0
                gameHandler_layerdown()
            end
            
            if yshift > -1000 then yshift = yshift - dt * 200 end
            if xshift > 0 then xshift = math.max(0, xshift - dt * 200) end
            if xshift < 0 then xshift = math.min(xshift + dt * 200, 0) end
            
        end
        
        if finstate == 1 then
            
            if fintimer > 5 then
                
                fintimer = 0
                finstate = 2
                findirection = 1
                
            end
            
        end
        
        if finstate == 2 then
            
            fintimer2 = fintimer2 + dt
            
            if fintimer > 0.1 then
                findirection = -findirection
                fintimer = 0
            end
            
            xshift = xshift + dt * 100 * findirection
            yshift = math.min(0, yshift + 100 * dt)
            
            if fintimer2 > 2 then
                fintimer2 = 0
                if not gameHandler_isTopLevel() then gameHandler_layerup() end
                if yshift >= 0 and scale < 5 then scale = scale + 1 end
            end
            
            if yshift >= 0 and scale == 5 then
                finstate = 3
                fintimer = 0
                fintimer2 = 0
                particles:start()
                gameHandler_burnVillagers()
            end
        
        end
    
        if finstate == 3 then
            
            particles:update(dt)
            
            if fintimer > 0.1 then
                findirection = -findirection
                fintimer = 0
            end
            
            xshift = xshift + dt * 100 * findirection
            yshift = yshift + dt * 40
            
            if yshift > 1000 then
                finstate = 4
            end
            
        end
        
        if finstate == 4 then
            particles:update(dt)
            
            if fintimer > 0.1 then
                findirection = -findirection
                fintimer = 0
            end
            
            xshift = xshift + dt * 100 * findirection
            
            finalpha = math.min(255, finalpha + dt * 20)
            
        end
        
        love.mouse.setVisible(false)
    end

end

function gameScreen_generateBackground(imgData)
    
    for i = 0,imgData:getHeight() - 1 do
       
        local factor = math.max(0, i - love.graphics:getHeight() / 2.9) / (imgData:getHeight() - 1) 
       
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
    
    --love.graphics.setBackgroundColor(191, 226, 248, 100)
    
    love.graphics.setColor(150, 200, 210, 200)
    love.graphics.draw(stars, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, bkgrotation, 
        1, 1, stars:getWidth() / 2, stars:getWidth() / 2)
    love.graphics.draw(bkg, 0, 0)
    
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics:getHeight() / 2)
    love.graphics.scale(scaleV[scale], scaleV[scale])
    love.graphics.translate(-love.graphics.getWidth() / 2, -love.graphics:getHeight() / 2)
    
    
    love.graphics.translate(xshift / scaleV[scale], yshift / scaleV[scale])
    
    love.graphics.setColor(brightness, brightness, brightness, 255)
    
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
                
                love.graphics.setColor(brightness, brightness, brightness, 255)
            end
            
            for i,guy in pairs(layer.villager) do
                love.graphics.draw(charset[guy:getImage()], 
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
    
    
    if state == "ingame" and not questHandler_newQuest() then
    
        --menu bar ?
        --love.graphics.rectangle("fill", love.graphics.getWidth() - 50, 0, 50, love.graphics.getHeight())
        
        -- ressource display
        local sh = 10
        if ressources["wood"] ~= nil then        
            love.graphics.draw(tileset["wood"], love.graphics.getWidth() - tilesize - 5, sh)
            love.graphics.print(ressources["wood"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
            sh = sh + 40
        end
        if ressources["stone"] ~= nil then        
            love.graphics.draw(tileset["stone"], love.graphics.getWidth() - tilesize - 5, sh)
            love.graphics.print(ressources["stone"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
            sh = sh + 40
        end
        if ressources["iron"] ~= nil then        
            love.graphics.draw(tileset["iron"], love.graphics.getWidth() - tilesize - 5, sh)
            love.graphics.print(ressources["iron"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
            sh = sh + 40
        end
        if ressources["gold"] ~= nil then        
            love.graphics.draw(tileset["gold"], love.graphics.getWidth() - tilesize - 5, sh)
            love.graphics.print(ressources["gold"], love.graphics.getWidth() - tilesize - 40, sh + tilesize / 3)
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
                or (not gameHandler_isTopLevel() and (build.__name == "hut" or build.__name == "smith")) then 
                love.graphics.setColor(100, 100, 100, 150)
            else
                
                
                if math.abs((love.graphics.getWidth() - tilesize - 10) - (x - tilesize / 2)) < tilesize / 2 and
                   math.abs((love.graphics.getHeight() - tilesize * 1.5 - sh) - (y - tilesize / 2)) < tilesize / 2 then
                    love.graphics.setColor(230, 130, 130, 150)
                    
                    -- bad style but we will use this place to handle clicks as we already know everything relevant
                    if love.mouse.isDown( "l" ) then gameHandler_buildClicked(i) end
                end
            end
            
            love.graphics.draw(tileset[i], love.graphics.getWidth() - tilesize - 10, love.graphics.getHeight() - tilesize * 1.5 - sh)
            sh = sh + 40
            
        end
        
        --quest short info
        if questHandler_getShortQuestText() ~= nil then
            love.graphics.setFont(questFont)
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Current Task: "..questHandler_getShortQuestText(), 10, 10)
        end
        
        -- draw mouse icon if necessary
        
        if gameState ~= "free" then
            love.graphics.draw(tileset[gameState], love.mouse.getX(), love.mouse.getY(), 0, 1, 1, tilesize / 2, tilesize / 2)
        end

    end
    
    -- draw questPanel
    if state == "ingame" and questHandler_newQuest() then
        love.graphics.setColor(0, 0, 0, 180)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(questHandler_getBerny(), love.graphics.getWidth() / 2 - 300, love.graphics.getHeight() / 2, 0, 1, 1, 64, 64)
        love.graphics.setFont(questFont)
        local w, wrap = questFont:getWrap(questHandler_getCurrentQuestText(), 600)
        love.graphics.printf(questHandler_getCurrentQuestText(), love.graphics.getWidth() / 2 - 200,
            love.graphics.getHeight() / 2, 600, "left", 0, 1, 1, 0, questFont:getHeight() * wrap / 2)
        love.graphics.print("Press space to go on", love.graphics.getWidth() / 2 - 200,
            love.graphics.getHeight() / 2 + questFont:getHeight() * wrap / 2 + 50)
    end
    
    if state == "fin" then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(particles, love.graphics:getWidth() / 2, love.graphics.getHeight() * 1.3)
        
        if finstate == 4 then
            
            love.graphics.setColor(0, 0, 0, finalpha)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            
            love.graphics.setColor(215, 141, 141, finalpha)
            love.graphics.setFont(finFont)
            love.graphics.print("fin", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 
                0, 1, 1, finFont:getWidth("fin") / 2, finFont:getHeight() / 2)
            
        end
        
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
   
   xshift = math.max(-500, math.min(xshift + x, 500))
   yshift = math.max(-1000, math.min(yshift + y, 200))
    
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