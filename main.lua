function love.load()
    wf = require "lib/windfield"

    world = wf.newWorld(0, 500)

    player = world:newRectangleCollider(350, 100, 80, 80)
    ground = world:newRectangleCollider(100, 400, 600, 100)
    wall = world:newRectangleCollider(300, 100, 100, 50)
    wall2 = world:newRectangleCollider(500, 100, 100, 50)
    ground:setType("static")
    wall:setType("static")
    wall2:setType("static")
end

function love.update(dt)
    local px, py = player:getLinearVelocity()
    if love.keyboard.isDown("left") and px > -300 then
        player:applyLinearImpulse(-5000, 0)
    end
    if love.keyboard.isDown("right") and px < 300 then
        player:applyLinearImpulse(5000, 0)
    end
    if love.keyboard.isDown("up") and py == 0 then
        player:applyLinearImpulse(0, -5000)
    end
    world:update(dt)
end

function love.draw()
    world:draw()
    

end

function love.keypressed(key)
end