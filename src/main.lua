
class = require 'misc/30logclean'

require 'model/layer'
require 'model/structures'
require 'model/villager'
require 'model/world'

require 'handler/gameHandler'
require 'handler/inputHandler'
require 'handler/ressourceHandler'
require 'handler/questHandler'

require 'screens/gameScreen'
require 'screens/loadScreen'

function love.load()
    
    love.audio.setVolume( 1.0 )
    
    -- debugger
    --if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    math.randomseed(os.time())
    
    state = "loading"
    
    ressourceHandler_loadTiles()
    ressourceHandler_loadAudioFiles()
    gameHandler_init()
    gameScreen_init()
    loadScreen_init()
    questHandler_init()
    
end

function love.update(dt)
    
    if state == "loading" then
        loadScreen_update(dt)
    end
    
    if state == "ingame" or state == "fin" then
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
    
    if state == "fin" then
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