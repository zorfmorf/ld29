
world = nil

local active = nil

local size = 5

function gameHandler_init()
    world = World:new(size)
    active = size
    world.layers[active].active = true
end


function gameHandler_update(dt)
    
    
end

function gameHandler_layerup()
    if active < size then 
        world.layers[active].active = false
        active = active + 1
        world.layers[active].active = true
    end
end


function gameHandler_layerdown()
    if active > 1 then 
        world.layers[active].active = false
        active = active - 1
        world.layers[active].active = true
    end
end
