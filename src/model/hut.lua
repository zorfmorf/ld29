
Hut = class()

function Hut:__init(x, y)
    self.stage = 1  
    self.x = x
    self.y = y
end

function Hut:getImage()
    
    return "hut"..self.stage
end

