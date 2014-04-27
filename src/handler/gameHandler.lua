
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
    
end

function gameHandler_allowHut()
    buildings["hut11"] = Hut:new()
end

function gameHandler_allowShaft()
    buildings["shaft"] = Shaft:new()
end

function gameHandler_allowSmithy()
    buildings["smith"] = Smith:new()
end

function gameHandler_canGoDown()
    return active > 1 and world.layers[active - 1].available
end

function gameHandler_isTopLevel()
    return active >= size
end

function gameHandler_isBottomLevel()
    return active == 1
end

function gameHandler_LevelCanBeBuilt()
    return #world.layers[active].structures > 0
end

function gameHandler_shaftCanBeBuilt(lvl, x, y)
    return lvl > 1 and world.layers[lvl - 1].inner[y] ~= nil and world.layers[lvl - 1].inner[y][x] ~= nil
end

local function respawnDiamond()
    for i,cand in pairs(world.layers[1].structures) do
        if cand.__name == "rock" then
            world.layers[1].structures[i] = Diamond:new(cand.x, cand.y)
        end
    end
end

local function clearRocks(lvl, x, y)
    for i,cand in pairs(world.layers[lvl].structures) do
        if cand.x == x and cand.y == y then
            world.layers[lvl].structures[i] = nil
            if cand.__name == "diamond" then respawnDiamond() end
            return
        end
    end
end

-- tries to return struct at specified position
local function getStruct(x, y)
    
    if world.layers[active].inner[y] == nil or world.layers[active].inner[y][x] == nil then return nil end
    
    for i,cand in pairs(world.layers[active].structures) do
        
        if cand.x == x and cand.y == y then
            return cand
        end
    
    end

    return "nüscht nil" --- iiiieeeeeeeh was ist denn das da im code

end


local function isClearable(rock)
    
    -- DONT LOOK HERE ITS NOT HEALTHY
    
    local t = getStruct(rock.x - 1, rock.y)
    if t ~= nil and (t == "nüscht nil" or t.__name ~= "rock") then return true end
        t = getStruct(rock.x + 1, rock.y)
    if t ~= nil and (t == "nüscht nil" or t.__name ~= "rock") then return true end
        t = getStruct(rock.x, rock.y - 1)
    if t ~= nil and (t == "nüscht nil" or t.__name ~= "rock") then return true end
        t = getStruct(rock.x, rock.y + 1)
    if t ~= nil and (t == "nüscht nil" or t.__name ~= "rock") then return true end
    
    return false
end

local function plotIsEmpty(x, y)
    
    for i,cand in pairs(world.layers[active].structures) do
        
        if cand.x == x and cand.y == y then return false end
        
    end
    
    return true
end

function gameHandler_update(dt)
    
    for i,id in pairs(structureEventQueue) do
        
        --fieldEventQueue = {}
        
        local struct = world.layers[active].structures[id]
        
        if gameState == "free" and struct.__name == "tree" and 
            struct.durability > 0 and struct.flagged == false then
           
            struct.flagged = true
            world.tasks[#world.tasks + 1] = {active, struct}
            
        end
        
        if gameState == "free" and struct.__name == "rock" and isClearable(struct) and struct.flagged == false then
            
            struct.flagged = true
            world.tasks[#world.tasks + 1] = {active, struct}
            
            break
            
        end
        
        if gameState == "free" and struct.__name == "hut" and struct:upgradable() and struct.flagged == false then
            
            struct.durability = 10
            struct.flagged = true
            world.tasks[#world.tasks + 1] = {active, struct}
            struct:upgrade()
            break
            
        end
        
        if gameState == "free" and struct.__name == "diamond" and struct.flagged == false then
            
            struct.flagged = true
            world.tasks[#world.tasks + 1] = {active, struct}
            break
        end
        
    end
    
    structureEventQueue = {}
    
    for i,id in pairs(fieldEventQueue) do
        
        if gameState ~= "free" then
            
            if world.layers[active].inner[id[2]] ~= nil and world.layers[active].inner[id[2]][id[1]] ~= nil then
               
                if buildings[gameState]:affordable() then
                   
                    if buildings[gameState].__name == "hut" and plotIsEmpty(id[1], id[2]) then
                        local hut = Hut:new(id[1], id[2])
                        world.tasks[#world.tasks + 1] = {active, hut}
                        table.insert(world.layers[active].structures, hut)
                        buildings[gameState]:pay()
                        gameState = "free"
                        love.mouse.setVisible(true)
                        break
                    end
                    
                    if buildings[gameState].__name == "smith" and plotIsEmpty(id[1], id[2]) then
                        local smith = Smith:new(id[1], id[2])
                        world.tasks[#world.tasks + 1] = {active, smith}
                        table.insert(world.layers[active].structures, smith)
                        buildings[gameState]:pay()
                        gameState = "free"
                        love.mouse.setVisible(true)
                        break
                    end
                    
                    
                    if buildings[gameState].__name == "shaft" and plotIsEmpty(id[1], id[2]) then
                        
                        local nx = id[1] - 2
                        local ny = id[2] - 1
                        
                        if gameHandler_shaftCanBeBuilt(active, nx, ny) then
                            
                            local shaft = Shaft:new(id[1], id[2])
                            world.tasks[#world.tasks + 1] = {active, shaft}
                            table.insert(world.layers[active].structures, shaft)
                            
                            -- now add shaft into lower layer
                            clearRocks(active - 1, nx, ny)
                            table.insert(world.layers[active - 1].structures, ShaftBottom:new(nx, ny))
                            
                            buildings[gameState]:pay()
                            gameState = "free"
                            love.mouse.setVisible(true)
                            
                        end
                    end
                    
                end
                
            end
            
        end
        
        break
        
    end

    fieldEventQueue = {}
    
    
    -- update all villagers
    for i=1,size do
        for j,villy in pairs(world.layers[i].villager) do
            
           villy:update(dt)
            
        end
    end
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
    gameState = "free"
    love.mouse.setVisible(true)
    if active < size then 
        world.layers[active].active = false
        active = active + 1
        world.layers[active].active = true
    end
end

function gameHandler_deselect()
    if gameState ~= "free" then
        gameState = "free"
        love.mouse.setVisible(true)
    end
end

function gameHandler_layerdown()
    structureEventQueue = {}
    fieldEventQueue = {}
    gameState = "free"
    love.mouse.setVisible(true)
    if active > 1 then 
        world.layers[active].active = false
        active = active - 1
        world.layers[active].active = true
    end
end
