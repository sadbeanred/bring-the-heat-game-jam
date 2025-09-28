require "player"
require "game"
require "gameover"
require "gworld"
require "menu"
require "crystal"
require "crystalManager"

joystick = love.joystick.getJoysticks()[1]

iceConfig = {
    left = "left",
    up = "up",
    down = "down",
    right = "right",
    name = "Ice",
    shoot = "return",
    colour = { 0, 0, 1 },
    spawn = {
        x = 100,
        y = 300,
    },
    joystickUp = "lefty",
    joystickLeft = "leftx",
    lookUp = "righty",
    lookLeft = "rightx",
    shootButton = "triggerright",
    jumpButton = "leftshoulder",
    sprintButton = "rightshoulder",
    gpIndex = 1
}

fireConfig = {
    up = "w",
    left = "a",
    down = "s",
    right = "d",
    name = "Fire",
    shoot = "space",
    colour = { 1, 0, 0 },
    spawn = {
        x = WindowWidth - 100 - 40,
        y = 300,
    },
    joystickUp = "lefty",
    joystickLeft = "leftx",
    lookUp = "righty",
    lookLeft = "rightx",
    shootButton = "triggerright",
    jumpButton = "leftshoulder",
    sprintButton = "rightshoulder",
    gpIndex = 2
}

menuConfig = {
    upKey = "up",
    downKey = "down",
    selectKey = "space",
    upButton = "dpup",
    downButton = "dpdown",
    yAxis = "lefty",
    selectButton = "a",
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
    Game:load()
end

function love.update(dt)
    if State.current == "Menu" then
        Menu:update(dt)
    end
    if State.current == "GameOver" then
        GameOver:update(dt)
    end
    if State.current == "Game" then
        IcePlayer:update(dt)
        FirePlayer:update(dt)
        GameWorld.world:update(dt)
        IceCrystalManager:update(dt)
        FireCrystalManager:update(dt)
    end
end

function love.draw()
    if State.current == "Game" then
        IcePlayer:draw()
        FirePlayer:draw()
        GameWorld.world:draw()
        IceCrystalManager:draw()
        FireCrystalManager:draw()
        Game:draw()
    elseif State.current == "Menu" then
        Menu:draw()
    elseif State.current == "GameOver" then
        GameOver:draw()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit(0)
    end
    if State.current == "Game" then
        if IcePlayer then
            IcePlayer:keypressed(key)
        end
        if FirePlayer then
            FirePlayer:keypressed(key)
        end
    elseif State.current == "Menu" then
        Menu:keypressed(key)
    elseif State.current == "GameOver" then
        GameOver:keypressed(key)
    end
end

function resize(w, h)
    local w1, h1 = window.width, window.height
    local scale = math.min(w / w1, h / h1)
    window.translateX, window.translateY, window.scale = (w - w1 * scale) / 2, (h - h1 * scale) / 2, scale
end

function love.resize(w, h)
    if window then
        resize(w, h)
    end
end
