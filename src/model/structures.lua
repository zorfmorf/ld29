

Structure = class{
    cost = {},
    yield = {}
}
function Structure:__init(x, y)
    self.x = x
    self.y = y
end
function Structure:affordable()
    
    for t,c in pairs(self.cost) do
        if ressources[t] < c then return false end
    end
    
    return true
end
function Structure:pay()
    for t,c in pairs(self.cost) do
        ressources[t] = ressources[t] - c
    end
end

Hut = Structure:extends{
    cost = { wood=1 },
    yield = {},
    stage = 1    
}
Hut.__name = "hut"
function Hut:getImage()
    return "hut"..self.stage
end

Shaft = Structure:extends{
    cost = { wood=2 },
    yield = { stone=1 }
}
Shaft.__name = "shaft"
function Shaft:getImage()
    return "shaft"
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
