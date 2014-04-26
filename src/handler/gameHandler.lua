
world = nil

local active = nil

local size = 5

ressources = nil

local clickEventQueue = {}

function gameHandler_init()
    world = World:new(size)
    active = size
    world.layers[active].active = true
    
    ressources = {}
    ressources["wood"] = 0
    ressources["stone"] = 0
end


function gameHandler_update(dt)
    
    for i,id in pairs(clickEventQueue) do
        
        local struct = world.layers[active].structures[id]
        
        if struct.__name == "tree" then
           
            world.layers[active].structures[id] = nil
            ressources["wood"] = ressources["wood"] + 1
            
        end
        
    end
    
    clickEventQueue = {}
    
end

function gameHandler_structureClicked(i)
    table.insert(clickEventQueue, i)
end

function gameHandler_layerup()
    clickEventQueue = {}
    if active < size then 
        world.layers[active].active = false
        active = active + 1
        world.layers[active].active = true
    end
end


function gameHandler_layerdown()
    clickEventQueue = {}
    if active > 1 then 
        world.layers[active].active = false
        active = active - 1
        world.layers[active].active = true
    end
end
