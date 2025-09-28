GWorld = {}
GWorld.__index = GWorld

Gravity = 7500
WindowWidth = 1020
WindowHeight = 768
GroundHeight = 50
GroundWidth = 800
JumpHeight = 200
WallHeight = 50
WallWidth = 200
SmallWallWidth = 75
CloseSideWallMargin = 100

function GWorld:new()
    local wf = require "lib/windfield"
    local obj = setmetatable({}, self)

    obj.world = wf.newWorld(0, Gravity)
    
    addCollisionClasses(obj.world)

    obj.leftBoundary = addStaticObject(obj.world, 0, 0, 1, WindowHeight)
    obj.rightBoundary = addStaticObject(obj.world, WindowWidth-1, 0, 1, WindowHeight)
    obj.topBoundary = addStaticObject(obj.world, 0, 0, WindowWidth, 1)
    obj.bottomBoundary = addStaticObject(obj.world, 0, WindowHeight-1, WindowWidth, 1)
    obj.ground = addStaticObject(obj.world, (WindowWidth-GroundWidth)/2, WindowHeight-GroundHeight, GroundWidth, GroundHeight)
    obj.centreWall = addStaticObject(obj.world, (WindowWidth-WallWidth*1.5)/2, WindowHeight-JumpHeight, WallWidth*1.5, WallHeight)

    obj.leftMarginWall, obj.rightMarginWall = addMirroredWalls(obj.world, CloseSideWallMargin, WindowHeight-(JumpHeight*1.75), WallWidth, WallHeight)
    obj.leftCornerWall, obj.rightCornerWall = addMirroredWalls(obj.world, 0, WindowHeight-(JumpHeight*1.75)+WallHeight, WallWidth*.75, WallHeight)
    obj.leftHighWall, obj.rightHighWall = addMirroredWalls(obj.world, WallWidth*1.75, WindowHeight-(JumpHeight*2.5), WallWidth/2, WallHeight*.75)
    obj.leftLookoutWall, obj.rightLookoutWall = addMirroredWalls(obj.world, WallWidth*1.5, WindowHeight-(JumpHeight*3.25), WallWidth/4, WallHeight*.75)

    obj.highCentreField = addEnergyField(obj.world, WallWidth*2.25, WindowHeight - (JumpHeight *2.4), WindowWidth - WallWidth*2.25, WindowHeight - (JumpHeight*2.4))

    obj.centreField = addEnergyField(obj.world, WindowWidth/2, WindowHeight - GroundHeight, WindowWidth/2, WindowHeight - JumpHeight + WallHeight)

    obj.leftEnergyField, obj.rightEnergyField = addMirroredEnergyFields(obj.world, WallWidth*1.75, WindowHeight - (JumpHeight *2.5), WallWidth*1.75, WindowHeight - (JumpHeight*3.25))
    

    
    return obj
end

function addMirroredWalls(world, x, y, width, height)
    local leftWall = addStaticObject(world, x, y, width, height)
    local rightWall = addStaticObject(world, WindowWidth - x - width, y, width, height)
    return leftWall, rightWall
end

function addStaticObject(world, x, y, width, height)
    local obj = world:newRectangleCollider(x, y, width, height)
    obj:setType("static")
    return obj
end

function addMirroredEnergyFields(world, x1, y1, x2, y2)
    local leftField = addEnergyField(world, x1, y1, x2, y2)
    local rightField = addEnergyField(world, WindowWidth - x2, y1, WindowWidth - x1, y2)
    return leftField, rightField
end

function addEnergyField(world, x1, y1, x2, y2)
    local obj = world:newLineCollider(x1, y1, x2, y2)
    obj:setType("static")
    obj:setCollisionClass('EnergyField')
    return obj
end

function addCollisionClasses(world)
    world:addCollisionClass('FirePlayer')
    world:addCollisionClass('IcePlayer', {ignores = {'FirePlayer'}})
    world:addCollisionClass('FireBullet', {ignores = {'FirePlayer'}})
    world:addCollisionClass('IceBullet', {ignores = {'IcePlayer'}})
    world:addCollisionClass('EnergyField', {ignores = {'FirePlayer', 'IcePlayer'}})
    world:addCollisionClass('IceCrystal', {ignores = {'FirePlayer', 'IcePlayer', 'IceBullet'}})
    world:addCollisionClass('FireCrystal', {ignores = {'FirePlayer', 'IcePlayer', 'FireBullet'}})
end