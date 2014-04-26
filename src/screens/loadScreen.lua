
local nebulator = love.thread.newThread("misc/nebulator.lua")

local output = love.thread.getChannel("nebulator_output")
local percentage = love.thread.getChannel("nebulator_percentage")
local input = love.thread.getChannel("nebulator_input")

local loadValue = nil

function loadScreen_init()
    input:push(love.graphics:getWidth())
    input:push(love.graphics:getHeight())
    input:push(34534534)
    
    nebulator:start()
    loadValue = 0
end


function loadScreen_update(dt)
    
    if output:peek() == nil then
    
    
        local t = percentage:pop()
        
        while percentage:peek() do t = percentage:pop() end
        
        if t ~= nil then loadValue = t end
    
    else
        state = "ingame"
        gameScreen_generateBackground(output:pop())
    end
end

function loadScreen_draw()

    love.graphics.rectangle("fill", 50, love.graphics:getHeight() / 2 - 20, (love.graphics:getWidth() - 100) * loadValue, 40)
    
end