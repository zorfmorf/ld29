
local id = 1
local speed = 2 -- speed in both directions per second

Villager = class()
Villager.__name = "Villager"

function Villager:__init(x, y, layer)
    self.x = x
    self.y = y
    self.layer = layer
    self.path = nil
    self.id = id
    id = id + 1
end

function Villager:generateTask()
    
    if #world.tasks > 0 then self.task = table.remove(world.tasks, 1) end
end

function Villager:generatePath()
    
    self.path = {}
    
    local current = { self.x, self.y }

    local task = self.task[2]
    
    if self.layer ~= self.task[1] then
        
        for i,cand in pairs(world.layers[self.layer].structures) do
            
            if (self.layer > self.task[1] and cand.__name == "shaft") or
               (self.layer < self.task[1] and cand.__name == "shaft_bottom") then
                task = cand
                break
            end
                
        end
        
    end
    
    
    while not (current[1] == task.x and current[2] == task.y) do
                
        local new = {0, 0, 1}
        
        if current[2] < task.y then new[2] = 1 end
        if current[2] > task.y then new[2] = -1 end
        if new[2] == 0 and current[1] > task.x then new[1] = -1 end
        if new[2] == 0 and current[1] < task.x then new[1] = 1 end
        
        if new[1] == 0 and new[2] == 0 then print("Error!!!!!!!!!!") break end

        self.path[#self.path + 1] = new
        current[1] = current[1] + new[1]
        current[2] = current[2] + new[2]

    end
    
end

function Villager:update(dt)
    
    if self.task == nil then self:generateTask() return end
    
    if self.task ~= nil then
        
        local task = self.task[2]
        
        if self.layer == self.task[1] and self.x == task.x and self.y == task.y then
            self.path = nil
            task:harvest(dt)
            if task.durability <= 0 then 
                self.task = nil 
                if task.__name == "hut" then 
                    local v = Villager:new(self.x, self.y, self.layer)
                    world.layers[self.layer].villager[v.id] = v
                end
                
                if task.__name == "shaft" then 
                    world.layers[self.layer - 1].available = true
                end
            end
        else
            
            -- check if we need to change elevation
            if self.path ~= nil and #self.path == 0 then
                for i,cand in pairs(world.layers[self.layer].structures) do
                    if cand.x == self.x and cand.y == self.y and cand.__name == "shaft" then
                        world.layers[self.layer].villager[self.id] = nil
                        self.x = self.x - 2
                        self.y = self.y - 1
                        self.layer = self.layer - 1
                        world.layers[self.layer].villager[self.id] = self
                        self.path = nil
                    end
                    if cand.x == self.x and cand.y == self.y and cand.__name == "shaft_bottom" then
                        world.layers[self.layer].villager[self.id] = nil
                        self.x = self.x + 2
                        self.y = self.y + 1
                        self.layer = self.layer + 1
                        world.layers[self.layer].villager[self.id] = self
                        self.path = nil
                    end
                end
            end
        
            if self.path == nil or #self.path == 0 then self:generatePath() return end
            
            local n = self.path[1]
            
            if n[3] >= 0 then
                n[3] = n[3] - dt * speed
                self.x = self.x + n[1] * dt * speed
                self.y = self.y + n[2] * dt * speed
            else
                self.x = math.floor(self.x + 0.5)
                self.y = math.floor(self.y + 0.5)
                table.remove(self.path, 1)
            end
            
        end
    end
end