
Layer = class()

function Layer:__init(size)
    
    self.active = false -- whether the player is viewing this layer
    
    self.inner = nil
    
    --generate outer layer
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