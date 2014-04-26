
World = class()

function World:__init(numberOfLayers)
    
    self.x = love.graphics:getWidth() / 2
    self.y = love.graphics:getHeight()
    
    local n = 1
    if numberOfLayers ~= nil then n = numberOfLayers end
    
    self.layers = {}
    for i=1,n do
        self.layers[i] = Layer:new(i)
    end
    self.layers[n].active = true
end

