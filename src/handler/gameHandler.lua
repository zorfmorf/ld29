
world = nil
local active = nil -- active world layer

local size = 5 -- amount of layers

ressources = nil

buildings = nil

local structureEventQueue = {}
local fieldEventQueue = {}

gameState = "free" -- "other: name of building to be placed?

function gameHandler_init()
    world = World:new(size)
    active = size
    world.layers[active].active = true
    
    ressources = {}
    ressources["wood"] = 0
    ressources["stone"] = 0
    
    buildings = {}
    buildings["hut1"] = Hut:new()
    buildings["shaft"] = Shaft:new()
end


function gameHandler_update(dt)
    
    for i,id in pairs(structureEventQueue) do
        
        local struct = world.layers[active].structures[id]
        
        if gameState == "free" and struct.__name == "tree" then
           
            world.layers[active].structures[id] = nil
            ressources["wood"] = ressources["wood"] + 1
            
        end
        
    end
    
    structureEventQueue = {}
    
    for i,id in pairs(fieldEventQueue) do
        
        if gameState ~= "free" then
            
            if world.layers[active].inner[id[2]] ~= nil and world.layers[active].inner[id[2]][id[1]] ~= nil then
               
                if buildings[gameState]:affordable() then
                   
                    if buildings[gameState].__name == "hut" then
                        table.insert(world.layers[active].structures, Hut:new(id[1], id[2]))
                    end
                    
                    if buildings[gameState].__name == "shaft" then
                        table.insert(world.layers[active].structures, Shaft:new(id[1], id[2]))
                    end
                    
                    buildings[gameState]:pay()
                    gameState = "free"
                    love.mouse.setVisible(true)
                   
                end
                
            end
            
        end
        
        break
        
    end
    
    
    fieldEventQueue = {}
    
end

function gameHandler_areaClicked(x, y)
    if #structureEventQueue == 0 then
        table.insert(fieldEventQueue, {x, y})
    end
end

function gameHandler_structureClicked(i)
    table.insert(structureEventQueue, i)
end

function gameHandler_buildClicked(i)
    love.mouse.setVisible( false )
    gameState = i
end

function gameHandler_layerup()
    structureEventQueue = {}
    fieldEventQueue = {}
    if active < size then 
        world.layers[active].active = false
        active = active + 1
        world.layers[active].active = true
    end
end


function gameHandler_layerdown()
    structureEventQueue = {}
    fieldEventQueue = {}
    if active > 1 then 
        world.layers[active].active = false
        active = active - 1
        world.layers[active].active = true
    end
end
