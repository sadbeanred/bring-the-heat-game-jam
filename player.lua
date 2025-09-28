require "bullet"
Player = {
    -- facing = {x=0,y=0} ,
    -- bullets = {}
    size = {
        x=40,
        y=40
    }
}
Player.__index = Player

xAcceleration = 50
xMaxSpeed = 300
yAcceleration = 150
sprintFactor = 2

function Player:new(config)
    local obj = setmetatable({}, self)
    obj.onGround = false
    obj.config = config
    obj.collider = GameWorld.world:newRectangleCollider(obj.config.spawn.x, obj.config.spawn.y, obj.size.x, obj.size.y)
    obj.collider:setObject(obj)
    obj.collider:setCollisionClass(config.name .. "Player")
    obj.facing = {x=0, y=0}
    obj.bullets = {}
    obj.jumpCooldown = 0
    obj.shootCooldown = 0
    return obj
end


function Player:update(dt)
    local px, py = self.collider:getLinearVelocity()
    local joysticks = love.joystick.getJoysticks()

    if #joysticks > 0 and joysticks[self.config.gpIndex]:isGamepad() then
        local joystick = joysticks[self.config.gpIndex]
        local axisX = joystick:getGamepadAxis(self.config.joystickLeft)
        local axisY = joystick:getGamepadAxis(self.config.joystickUp)
        local lookX = joystick:getGamepadAxis(self.config.lookLeft)
        local lookY = joystick:getGamepadAxis(self.config.lookUp)
        if axisX > 0.3 then
            self:tryMoveHorizontal(axisX, joystick:isGamepadDown(self.config.sprintButton))
        end
        if axisX < -0.3 then
            self:tryMoveHorizontal(axisX, joystick:isGamepadDown(self.config.sprintButton))
        end
        if axisY < -0.8 then
            self:tryJump(axisY, dt)
        end
        if math.abs(lookX) > 0.3 or math.abs(lookY) > 0.3 then
            self.facing.x = lookX
            self.facing.y = lookY
        end
        local aButton = joystick:isGamepadDown(self.config.jumpButton)
        if aButton and py == 0 then
            self.collider:applyLinearImpulse(0, -5000)
        end

        local trigger = joystick:getGamepadAxis(self.config.shootButton)
        if trigger > 0.5 then
            self:tryShoot(dt)
        end
    end
    if love.keyboard.isDown(self.config.left) and px > -300 then
        self.facing.x = -1
        self.collider:applyLinearImpulse(-1000, 0)
    end
    if love.keyboard.isDown(self.config.right) and px < 300 then
        self.facing.x = 1
        self.collider:applyLinearImpulse(1000, 0)
    end
    if love.keyboard.isDown(self.config.up) and py == 0 then
        self.collider:applyLinearImpulse(0, -5000)
    end

    if self.bullets then
        for i, bullet in ipairs(self.bullets) do
            bullet:update(dt)
        end
    end
    self:handleCollision()

end

function Player:tryMoveHorizontal(movementAmount, isSprinting)
    local px, py = self.collider:getLinearVelocity()
    local maxSpeed = isSprinting and (xMaxSpeed * sprintFactor) or xMaxSpeed
    if(math.abs(px) < maxSpeed) then
        --self.facing.x =  1
        local accel = isSprinting and (xAcceleration * sprintFactor) or xAcceleration
        self.collider:applyLinearImpulse(movementAmount * accel, 0)
    end
end


function Player:tryJump(movementAmount, dt)
    if self.onGround then
        self.jumpCooldown = self.jumpCooldown + dt
        if self.jumpCooldown < 0.1 then
            self.collider:applyLinearImpulse(0, movementAmount * yAcceleration * dt * 500)
        else
            self.onGround = false
            self.jumpCooldown = 0
        end
    end
end

function Player:handleCollision()
    if self.collider:enter("KillField") then
        self:respawn()
    end
    if self.collider:enter("Terrain") then
        self.onGround = true
    end
end

function Player:tryShoot(dt)
    self.shootCooldown = self.shootCooldown + dt
    if self.shootCooldown > 0.1 then
        local px, py = self.collider:getPosition()
        local bullet = Bullet:new(self, px,py, self.facing.x, self.facing.y)
        table.insert(self.bullets, bullet)
        self.shootCooldown = 0
    end
end

function Player:keypressed(key)
    if key == self.config.shoot then
        local px, py = self.collider:getPosition()
        local bullet = Bullet:new(self, px,py, self.facing.x, self.facing.y)
        table.insert(self.bullets, bullet)
    end
end


function Player:respawn()
    self.collider:setPosition(self.config.spawn.x, self.config.spawn.y)
end


function Player:draw ()
    love.graphics.push("all")     -- save transform, color, line style, etc.
    love.graphics.setColor(unpack(self.config.colour)) -- red
    local px, py = self.collider:getPosition()
    love.graphics.rectangle("fill", px-(self.size.x/2), py- (self.size.y/2), self.size.x, self.size.y)
    love.graphics.pop()
end
