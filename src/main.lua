
class = require 'misc/30logclean'

require 'model/layer'
require 'model/world'

require 'handler/gameHandler'
require 'handler/ressourceHandler'
require 'handler/stateHandler'

require 'screens/gameScreen'

function love.load()
    
    ressourceHandler_loadTiles()
    gameHandler_init()
    gameScreen_init()
    
end

function love.update(dt)
    
    if state == "ingame" then
        gameHandler_update(dt)
        gameScreen_update(dt)
    end
    
end

function love.draw()
    
    if state == "ingame" then
        gameScreen_draw()
    end
    
end

function love.keypressed(key, isrepeat)
   
    if key == "escape" then love.event.push("quit") end
    
    if key == "up" then gameScreen_Camera_up() end
    if key == "down" then gameScreen_Camera_down() end
    if key == "left" then gameScreen_Camera_left() end
    if key == "right" then gameScreen_Camera_right() end
   
end

function love.keyreleased(key, isrepeat)
    
end