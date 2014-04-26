
-----------------STRUCTURE
Structure = class{
    cost = {},
    yield = {},
    flagged = false
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

-------------------- HUT
Hut = Structure:extends{
    cost = { wood=1 },
    yield = {},
    stage = 1,
    upgrades = { {stone=1} }
}
Hut.__name = "hut"
function Hut:getImage()
    return "hut"..self.stage
end
function Hut:upgradable()
    
    if self.upgrades[self.stage] == nil then return false end
    
    for t,c in pairs(self.upgrades[self.stage]) do
        
        if ressources[t] < c then return false end
        
    end
    
    return true
end
function Hut:upgrade()
    for t,c in pairs(self.upgrades[self.stage]) do
        ressources[t] = ressources[t] - c
    end
    self.stage = self.stage + 1
end


------------------- SHAFT
Shaft = Structure:extends{
    cost = { wood=2 },
    yield = { stone=1 }
}
Shaft.__name = "shaft"
function Shaft:__init(x, y)
    self.x = x
    self.y = y
    self.durability = 8
    self.image = "sign"
end
function Shaft:getImage()
    return self.image
end
function Shaft:harvest(dt)
    self.durability = self.durability - dt
    if self.durability <= 0 then
        self.flagged = false
        self.image = "shaft"
    end
end

----------------- SHAFT BOTTOM
ShaftBottom = Structure:extends()
ShaftBottom.__name= "shaft_bottom"
function ShaftBottom:getImage()
    return "shaft_bottom"
end

-------------------- ROCK
Rock = Structure:extends()
Rock.__name = "rock"
function Rock:__init(x, y, level)
    self.t = math.random(1,2)
    self.x = x
    self.y = y
    self.type = "rocks"
    if level < 4 then if math.random(1,3) == 1 then self.type = "rocks_iron" end end
    if level < 3 then if math.random(1,5) == 1 then self.type = "rocks_gold" end end
end
function Rock:getImage()
    return self.type..self.t
end
function Rock:yield()
    if self.type == "rocks" then ressources["stone"] = ressources["stone"] + 1 end
    if self.type == "rocks_iron" then
        if ressources["iron"] == nil then ressources["iron"] = 0 end
        ressources["iron"] = ressources["iron"] + 1 
    end
    if self.type == "rocks_gold" then 
        if ressources["gold"] == nil then
            ressources["gold"] = 0
        end
        ressources["gold"] = ressources["gold"] + 1 
    end
end


-------------- DIAMOND
Diamond = Structure:extends()
Diamond.__name = "diamond"
function Diamond:getImage()
    return "diamond"
end

------------------- TREE
Tree = Structure:extends()
Tree.__name = "tree"
function Tree:__init(x, y)
    self.t = math.random(1,2)
    self.x = x
    self.y = y
    self.durability = 5
    self.image = "tree"
end
function Tree:harvest(dt)
    self.durability = self.durability - dt
    if self.durability <= 0 then
        self.image = "stump"
        self.flagged = false
        ressources["wood"] = ressources["wood"] + 1
    end
end
function Tree:getImage()
    return self.image..self.t
end
