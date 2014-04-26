
World = class()

function World:__init(numberOfLayers)
    
    self.x = love.graphics:getWidth() / 2
    self.y = love.graphics:getHeight() + 400
    
    local n = 1
    if numberOfLayers ~= nil then n = numberOfLayers end
    
    self.layers = {}
    for i=1,n do
        self.layers[i] = Layer:new(i)
        self.layers[i]:generateOuterLayer(i)
        
        if i == n then
            self.layers[i]:generateInnerLayer_Terrain(i)
            
        else
           -- self.layers[i]:generateInnerLayer_underground(i)
           self.layers[i]:generateInnerLayer_Terrain(i)
        end
    end
end

