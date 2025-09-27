require "player"

iceConfig = {
    left = "left",
    up = "up",
    down = "down",
    right = "right",
}
fireConfig = {
    up = "w",
    left = "a",
    down = "s",
    right = "d",
}
IcePlayer = {}
FirePlayer = {}



function love.load()
    wf = require "lib/windfield"

    world = wf.newWorld(0, 500)

    ground = world:newRectangleCollider(100, 400, 600, 100)
    wall = world:newRectangleCollider(300, 100, 100, 50)
    wall2 = world:newRectangleCollider(500, 100, 100, 50)

    ground:setType("static")
    wall:setType("static")
    wall2:setType("static")
    IcePlayer = Player:new(iceConfig)
    FirePlayer = Player:new(fireConfig)
end

function love.update(dt)
    IcePlayer:update(dt)
    FirePlayer:update(dt)
    world:update(dt)
end


function love.draw()
    world:draw()
    

end

function love.keypressed(key)
end
