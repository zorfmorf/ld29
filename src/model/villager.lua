
local speed = 2 -- speed in both directions per second

Villager = class()
Villager.__name = "Villager"

function Villager:__init(x, y, layer)
    self.x = x
    self.y = y
    self.layer = layer
    self.path = nil
end

function Villager:generateTask()
    
    if #world.tasks > 0 then self.task = table.remove(world.tasks, 1) end
end

function Villager:generatePath()
    
    self.path = {}
    
    local current = { self.x, self.y }

    local task = self.task[2]
    
    
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
    
    if self.task ~= nil and self.task[1] == self.layer then
        
        local task = self.task[2]
        
        if self.x == task.x and self.y == task.y then
            task:harvest(dt)
            if task.durability <= 0 then self.task = nil end
        else
        
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