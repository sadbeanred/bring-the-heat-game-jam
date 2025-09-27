GWorld = {}
GWorld.__index = GWorld

function GWorld:new()
    local wf = require "lib/windfield"
    local obj = setmetatable({}, self)

    obj.world = wf.newWorld(0, 500)
    
    addCollisionClasses(obj.world)
    
    obj.ground = obj.world:newRectangleCollider(100, 400, 600, 100)
    obj.wall = obj.world:newRectangleCollider(300, 100, 100, 50)
    obj.wall2 = obj.world:newRectangleCollider(500, 100, 100, 50)
    obj.ground:setType("static")
    obj.wall:setType("static")
    obj.wall2:setType("static")
    return obj
end

function addCollisionClasses(world)
    world:addCollisionClass('FirePlayer')
    world:addCollisionClass('IcePlayer', {ignores = {'FirePlayer'}})
    world:addCollisionClass('FireBullet', {ignores = {'IcePlayer'}})
    world:addCollisionClass('IceBullet', {ignores = {'FirePlayer'}})
    world:addCollisionClass('EnergyField', {ignores = {'FirePlayer', 'IcePlayer'}})
end