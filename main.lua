require "player"
require "game"
require "gworld"
require "crystal"
require "crystalmanager"

iceConfig = {
    left = "left",
    up = "up",
    down = "down",
    right = "right",
    name = "Ice",
    shoot = "return",
    colour= {0,0,1},
    spawn = {
        x = 350,
        y = 100,
    }
}

fireConfig = {
    up = "w",
    left = "a",
    down = "s",
    right = "d",
    name = "Fire",
    shoot = "space",
    colour= {1,0,0},
    spawn = {
        x = 200,
        y = 100,
    }
}

IcePlayer = {}
FirePlayer = {}
GameWorld = {}

Entities = {}



function love.load()


    GameWorld = GWorld:new()
    IcePlayer = Player:new(iceConfig)
    FirePlayer = Player:new(fireConfig)
    IceCrystalManager = CrystalManager:new("Ice")
    FireCrystalManager = CrystalManager:new("Fire")
end

function love.update(dt)
    IcePlayer:update(dt)
    FirePlayer:update(dt)
    IceCrystalManager:update(dt)
    FireCrystalManager:update(dt)
    GameWorld.world:update(dt)
end


function love.draw()
    IcePlayer:draw()
    FirePlayer:draw()
    GameWorld.world:draw()
    IceCrystalManager:draw()
    FireCrystalManager:draw()
    Game:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit(0)
    end
    if IcePlayer then
        IcePlayer:keypressed(key)
    end
    if FirePlayer then
        FirePlayer:keypressed(key)
    end
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
