

Structure = class()
function Structure:__init(x, y)
    self.x = x
    self.y = y
end

Hut = Structure:extends{
    stage = 1    
}
Hut.__name = "hut"
function Hut:getImage()
    
    return "hut"..self.stage
end


Tree = Structure:extends()
Tree.__name = "tree"
function Tree:__init(x, y)
    self.t = math.random(1,2)
    self.x = x
    self.y = y
end
function Tree:getImage()
    return "tree"..self.t
end
