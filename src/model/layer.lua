
Layer = class()

function Layer:__init()
    
    self.active = false -- whether the player is viewing this layer
    self.inner = nil
    self.outer = nil
    self.available = false -- if it can be seen by the user
    self.structures = {}
    self.villager = {}

end

function Layer:generateOuterLayer(size)
    
    self.outer = {}
    for i=1,6 do
        self.outer[i] = {}
        
        for j=1,size*4 do
            
            local mod = i
            if i > 3 then mod = i - 3 end
            
            if (i <= 3 and j == 1) or (i > 3 and j == 2) then
                self.outer[i][j] = "cliff_edge_l"..mod
            end
            
            if (i <= 3 and j == size * 4) or (i > 3 and j == size * 4 - 1) then
                self.outer[i][j] = "cliff_edge_r"..mod
            end
            
            if (i <= 3 and j > 1 and j < size * 4) or ( i > 3 and j > 2 and j < size * 4 - 1) then 
                self.outer[i][j] = "cliff" 
            end
            
        end
        
    end
end


function Layer:generateInnerLayer_underground(size)
    
    self.inner = {}
    
    local start = (size * 4) / 2
    
    -- first populate with grass
    for i = 1, 2 + size * 2 do
        
        self.inner[i] = {}
        
        for j = 1, size * 4 do
            
            if j >= (start + 2) - i * 2 and j <= (start - 1) + i * 2 
                and j >= (start) - ((2 + size * 2) - i) * 2 and j <= start + 1 + ((2 + size * 2) - i) * 2 then
                
                self.inner[i][j] = "dirt"
            
            end 
            
        end
        
    end
    
    -- now make the edges pretty
    for i,row in pairs(self.inner) do
        
        for j,entry in pairs(row) do
            
            if self.inner[i][j - 1] == nil and (self.inner[i - 1] == nil or self.inner[i - 1][j] == nil) then
                self.inner[i][j] = "dirt_edge_ul"
            end
            
            if self.inner[i][j - 1] ~= nil and self.inner[i][j + 1] ~= nil and (self.inner[i - 1] == nil or self.inner[i - 1][j] == nil) then
                self.inner[i][j] = "dirt_edge_u"
            end
            
            if self.inner[i][j - 1] ~= nil and self.inner[i][j + 1] ~= nil and (self.inner[i + 1] == nil or self.inner[i + 1][j] == nil) then
                self.inner[i][j] = "dirt_edge_d"
            end
            
            if self.inner[i][j + 1] == nil and (self.inner[i - 1] == nil or self.inner[i - 1][j] == nil) then
                self.inner[i][j] = "dirt_edge_ur"
            end
            
            if self.inner[i][j - 1] == nil and (self.inner[i + 1] == nil or self.inner[i + 1][j] == nil) then
                self.inner[i][j] = "dirt_edge_dl"
            end
            
            if self.inner[i][j + 1] == nil and (self.inner[i + 1] == nil or self.inner[i + 1][j] == nil) then
                self.inner[i][j] = "dirt_edge_dr"
            end
            
            -- add some rocks
            table.insert(self.structures, Rock:new(j, i, size))
        end
        
    end
    
    if size == 1 then
        local tx = math.random(2, 3)
        local ty = math.random(2, 3)
        for i,rock in pairs(self.structures) do
           
            if rock.x == tx and rock.y == ty then 
               self.structures[i] = Diamond:new(tx, ty)
               return 
            end
            
        end
    end
    
end

function Layer:generateInnerLayer_Terrain(size)
    
    table.insert(self.structures, Hut:new(6, 5))
    table.insert(self.structures, Hut:new(8, 8))
    table.insert(self.structures, Hut:new(4, 6))
    for i,hut in pairs(self.structures) do
        hut.durability = 0
        hut.stage = 1
    end
    
    local v1 = Villager:new(6, 5, size)
    local v2 = Villager:new(8, 8, size)
    local v3 = Villager:new(4, 6, size)
    
    self.villager[v1.id] = v1
    self.villager[v2.id] = v2
    self.villager[v3.id] = v3
    
    self.inner = {}
    
    local start = (size * 4) / 2
    
    -- first populate with grass
    for i = 1, 2 + size * 2 do
        
        self.inner[i] = {}
        
        for j = 1, size * 4 do
            
            if j >= (start + 2) - i * 2 and j <= (start - 1) + i * 2 
                and j >= (start) - ((2 + size * 2) - i) * 2 and j <= start + 1 + ((2 + size * 2) - i) * 2 then
                
                self.inner[i][j] = "grass"..math.random(1,2)
                
                if j > size * 2 and i > size and math.random(1,4) == 1 then
                    table.insert(self.structures, Tree:new(j, i))
                end
            end 
            
        end
        
    end
    
    -- now make the edges pretty
    for i,row in pairs(self.inner) do
        
        for j,entry in pairs(row) do
            
            if self.inner[i][j - 1] == nil and (self.inner[i - 1] == nil or self.inner[i - 1][j] == nil) then
                self.inner[i][j] = "grass_edge_ul"
            end
            
            if self.inner[i][j - 1] ~= nil and self.inner[i][j + 1] ~= nil and (self.inner[i - 1] == nil or self.inner[i - 1][j] == nil) then
                self.inner[i][j] = "grass_edge_u"
            end
            
            if self.inner[i][j - 1] ~= nil and self.inner[i][j + 1] ~= nil and (self.inner[i + 1] == nil or self.inner[i + 1][j] == nil) then
                self.inner[i][j] = "grass_edge_d"
            end
            
            if self.inner[i][j + 1] == nil and (self.inner[i - 1] == nil or self.inner[i - 1][j] == nil) then
                self.inner[i][j] = "grass_edge_ur"
            end
            
            if self.inner[i][j - 1] == nil and (self.inner[i + 1] == nil or self.inner[i + 1][j] == nil) then
                self.inner[i][j] = "grass_edge_dl"
            end
            
            if self.inner[i][j + 1] == nil and (self.inner[i + 1] == nil or self.inner[i + 1][j] == nil) then
                self.inner[i][j] = "grass_edge_dr"
            end
            
        end
        
    end
    
end