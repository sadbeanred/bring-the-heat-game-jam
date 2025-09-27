require "player"
require "gworld"

iceConfig = {
    left = "left",
    up = "up",
    down = "down",
    right = "right",
    collisionClass = "IcePlayer"
}
fireConfig = {
    up = "w",
    left = "a",
    down = "s",
    right = "d",
    collisionClass = "FirePlayer"
}
IcePlayer = {}
FirePlayer = {}
GameWorld = {}



function love.load()


    GameWorld = GWorld:new()
    IcePlayer = Player:new(iceConfig)
    FirePlayer = Player:new(fireConfig)
end

function love.update(dt)
    IcePlayer:update(dt)
    FirePlayer:update(dt)
    GameWorld.world:update(dt)
end


function love.draw()
    GameWorld.world:draw()
end

function love.keypressed(key)
end

function resize (w, h)
	local w1, h1 = window.width, window.height
	local scale = math.min (w/w1, h/h1)
	window.translateX, window.translateY, window.scale = (w-w1*scale)/2, (h-h1*scale)/2, scale
end

function love.resize (w, h)
    if window then
        resize (w, h)
    end
end
