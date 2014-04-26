
class = require 'misc/30logclean'

require 'model/layer'
require 'model/world'

require 'handler/gameHandler'
require 'handler/stateHandler'

require 'screens/gameScreen'

function love.load()
    
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
