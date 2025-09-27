GWorld = {}
GWorld.__index = GWorld

Gravity = 7500
WindowWidth = 1024
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
    obj.centreWall = addStaticObject(obj.world, (WindowWidth-WallWidth)/2, WindowHeight-JumpHeight, WallWidth, WallHeight)

    -- obj.leftMarginWall = addStaticObject(obj.world, CloseSideWallMargin, WindowHeight-(JumpHeight*1.75), WallWidth, WallHeight)
    -- obj.rightMarginWall = addStaticObject(obj.world, WindowWidth-CloseSideWallMargin-WallWidth, WindowHeight-(JumpHeight*1.75), WallWidth, WallHeight)
    
    obj.leftMarginWall, obj.rightMarginWall = addMirroredWalls(obj.world, CloseSideWallMargin, WindowHeight-(JumpHeight*1.75), WallWidth, WallHeight)

    obj.leftWall = addStaticObject(obj.world, 0, WindowHeight-(JumpHeight*1.75)+WallHeight, WallWidth*.75, WallHeight)
    obj.rightWall = addStaticObject(obj.world, WindowWidth-WallWidth*.75, WindowHeight-(JumpHeight*1.75)+WallHeight, WallWidth*.75, WallHeight)
    -- new left wall. use 2.5 jump height above window. one wall margin away from left margin wall
    obj.newLeftWall = addStaticObject(obj.world, WallWidth+(CloseSideWallMargin*2), WindowHeight-(JumpHeight*2.5), WallWidth/4, WallHeight)
    obj.newRightWall = addStaticObject(obj.world, WindowWidth-(WallWidth*1.75)-CloseSideWallMargin, WindowHeight-(JumpHeight*2.5), WallWidth/4, WallHeight)
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

function addCollisionClasses(world)
    world:addCollisionClass('FirePlayer')
    world:addCollisionClass('IcePlayer', {ignores = {'FirePlayer'}})
    world:addCollisionClass('FireBullet', {ignores = {'IcePlayer'}})
    world:addCollisionClass('IceBullet', {ignores = {'FirePlayer'}})
    world:addCollisionClass('EnergyField', {ignores = {'FirePlayer', 'IcePlayer'}})
end