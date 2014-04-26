
class = require 'misc/30logclean'

require 'model/layer'
require 'model/hut'
require 'model/world'

require 'handler/gameHandler'
require 'handler/inputHandler'
require 'handler/ressourceHandler'

require 'screens/gameScreen'
require 'screens/loadScreen'

function love.load()
    
    -- debugger
    --if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    math.randomseed(os.time())
    
    state = "loading"
    
    ressourceHandler_loadTiles()
    gameHandler_init()
    gameScreen_init()
    loadScreen_init()
    
end

function love.update(dt)
    
    if state == "loading" then
        loadScreen_update(dt)
    end
    
    if state == "ingame" then
        gameHandler_update(dt)
        gameScreen_update(dt)
    end
    
    inputHandler_update(dt)
end

function love.draw()
    
    if state == "loading" then
        loadScreen_draw()
    end
    
    if state == "ingame" then
        gameScreen_draw()
    end
    
end

function love.keypressed(key, isrepeat)
   
    inputHandler_keypressed(key, isrepeat)
   
end

function love.keyreleased(key, isrepeat)
    
    inputHandler_keyreleased(key, isrepeat)
    
end

function love.mousepressed( x, y, button )
    inputHandler_mousepressed( x, y, button )
end

function love.mousereleased( x, y, button )
    inputHandler_mousereleased( x, y, button )
end