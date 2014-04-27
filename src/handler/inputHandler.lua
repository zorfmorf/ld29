
local oldMousePos = nil

function inputHandler_update(dt)
    
    if state == "ingame" then
        
        if love.mouse.isDown( "r" ) then
            
            if oldMousePos ~= nil then
                
                local x,y = love.mouse.getPosition()
               
                gameScreen_Camera_shift(x - oldMousePos[1], y - oldMousePos[2])
                oldMousePos = {x, y}
                
            end
            
        end
        
    end
    
end

function inputHandler_keypressed(key, isrepeat)
   
    if key == "escape" then love.event.push("quit") end
    
    if state == "ingame" then
        if key == " " then state = "fin" end
        if key == "up" then gameHandler_layerup() end
        if key == "down" then gameHandler_layerdown() end
        if key == "return" then questHandler_acceptQuest() end
    end
   
end

function inputHandler_keyreleased(key, isrepeat)
    
end

function inputHandler_mousepressed( x, y, button )
    if state == "ingame" then
        if button == "r" then oldMousePos = {x, y} gameHandler_deselect() end
        if button == "l" then gameScreen_click(x, y) end
        if button == "wu" then gameScreen_Camera_zoomOut() end
        if button == "wd" then gameScreen_Camera_zoomIn() end
    end
end

function inputHandler_mousereleased( x, y, button )
    if state == "ingame" and button == "r" then oldMousePos = nil end
end