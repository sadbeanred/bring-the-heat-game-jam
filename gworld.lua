GWorld = {}
GWorld.__index = GWorld

WindowWidth = 1024
WindowHeight = 768
GroundHeight = 50
GroundWidth = 800
JumpHeight = 200
WallHeight = 50
WallWidth = 200
CloseSideWallMargin = 100

function GWorld:new()
    local wf = require "lib/windfield"
    local obj = setmetatable({}, self)

    obj.world = wf.newWorld(0, 500)
    
    addCollisionClasses(obj.world)

    -- collision along the outside of the screen. a ground, a wall, and a ceiling. each will be one pixel wide, maybe even a line collision
    obj.leftBoundary = addStaticObject(obj.world, 0, 0, 1, WindowHeight)
    obj.rightBoundary = addStaticObject(obj.world, WindowWidth-1, 0, 1, WindowHeight)
    obj.topBoundary = addStaticObject(obj.world, 0, 0, WindowWidth, 1)
    obj.bottomBoundary = addStaticObject(obj.world, 0, WindowHeight-1, WindowWidth, 1)
    obj.ground = addStaticObject(obj.world, (WindowWidth-GroundWidth)/2, WindowHeight-GroundHeight, GroundWidth, GroundHeight)
    -- one jump up
    obj.centreWall = addStaticObject(obj.world, (WindowWidth-WallWidth)/2, WindowHeight-JumpHeight, WallWidth, WallHeight)

    -- two side walls, each with a close side wall margin, one left, one right, two jumps up
    obj.leftMarginWall = addStaticObject(obj.world, CloseSideWallMargin, WindowHeight-(JumpHeight*1.75), WallWidth, WallHeight)
    obj.rightMarginWall = addStaticObject(obj.world, WindowWidth-CloseSideWallMargin-WallWidth, WindowHeight-(JumpHeight*1.75), WallWidth, WallHeight)
    -- two side walls, each with no margin, one wall height below the close side walls
    obj.leftWall = addStaticObject(obj.world, 0, WindowHeight-(JumpHeight*1.75)+WallHeight, WallWidth, WallHeight)
    obj.rightWall = addStaticObject(obj.world, WindowWidth-WallWidth, WindowHeight-(JumpHeight*1.75)+WallHeight, WallWidth, WallHeight)
    return obj
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