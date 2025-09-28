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
    gamepadIndex = 1,
    audio = {
        shoot = {
            love.audio.newSource("audio/ice-shoot-1.mp3", "static"),
            love.audio.newSource("audio/ice-shoot-2.mp3", "static")
        },
        jump = love.audio.newSource("audio/jump.mp3", "static"),
        land = love.audio.newSource("audio/land.mp3", "static"),
        death = love.audio.newSource("audio/ice-death.mp3", "static"),
        miss = love.audio.newSource("audio/ice-miss.mp3", "static"),
    }
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
    gamepadIndex = 2,
    audio = {
        shoot = {
            love.audio.newSource("audio/fire-shoot-1.mp3", "static"),
            love.audio.newSource("audio/fire-shoot-2.mp3", "static")
        },
        jump = love.audio.newSource("audio/jump.mp3", "static"),
        land = love.audio.newSource("audio/land.mp3", "static"),
        death = love.audio.newSource("audio/fire-death.mp3", "static"),
        miss = love.audio.newSource("audio/fire-miss.mp3", "static"),
    }
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

fireBarrelConfig = {
    audio = {
        kill = love.audio.newSource("audio/fire-barrel.mp3", "static"),
    },
    faction = "Fire",
    color = {1, 0, 0},
    spawnLocations = {
        {
            x= ((WindowWidth-GroundWidth)/4) + (CrystalSides/2),
            y = WindowHeight - (GroundHeight/1.5) - 50
        },
        {
            x = (CloseSideWallMargin/2) - (CrystalSides/2),
            y = WindowHeight - (JumpHeight*1.75) + WallHeight * .5 - (CrystalSides/2)
        },
        {
            x = WallWidth * 2 - (CrystalSides/2),
            y = WindowHeight - (JumpHeight * 2.6) - (CrystalSides/2)
        }
    }
}

waterBarrelConfig = {
    audio = {
        kill = love.audio.newSource("audio/water-barrel.mp3", "static"),
    },
    faction = "Ice",
    color = {0, 0, 1},
    spawnLocations = {
        {
            x = (WindowWidth - ((WindowWidth-GroundWidth)/3)) - (CrystalSides/2),
            y =WindowHeight - (GroundHeight/1.5) - 50
        },
        {
            x = WindowWidth - (CloseSideWallMargin/2) - (CrystalSides/2),
            y = WindowHeight - (JumpHeight*1.75) + WallHeight * .5 - (CrystalSides/2)
        },
        {
            x = WindowWidth - (WallWidth * 2) - (CrystalSides/2),
            y = WindowHeight - (JumpHeight * 2.6) - (CrystalSides/2)
        }
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
    IceCrystalManager = CrystalManager:new(waterBarrelConfig)
    FireCrystalManager = CrystalManager:new(fireBarrelConfig)
    backgroundMusic = love.audio.newSource("audio/bgm.mp3", "stream")
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
    if not backgroundMusic:isPlaying() then
        backgroundMusic:setVolume(0.8)
        backgroundMusic:play()
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
