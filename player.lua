require "bullet"
Player = {
    -- facing = {x=0,y=0} ,
    -- bullets = {}
    size = {
        x = 40,
        y = 40
    }
}
Player.__index = Player


RESPAWN_INVULNERABILITY_TIME = 1

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
    obj.facing = config.start_facing
    obj.bullets = {}
    obj.invulnerableTime = 0
    obj.jumpCooldown = 0
    obj.shootCooldown = 0
    obj.sprite = love.graphics.newImage(config.sprite)

    return obj
end

function Player:update(dt)
    self.shootCooldown = self.shootCooldown + dt
    self.invulnerableTime = math.max(self.invulnerableTime - dt, 0)
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
    else
        if love.keyboard.isDown(self.config.shoot) then
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

    local removableItems = {}
    if self.bullets then
        for i, bullet in ipairs(self.bullets) do
            bullet:update(dt)

            if (bullet.collider:isDestroyed()) then
                table.insert(removableItems, i)
            end
        end
    end
    for _, i in ipairs(removableItems) do
        table.remove(self.bullets, i)
    end
    self:handleCollision()
end

function Player:handleCollision()
    if self.collider:enter("KillField") then
        self.collider:setType("static")
        self:respawn()
        self.collider:setType("dynamic")
    end
end

function Player:tryMoveHorizontal(movementAmount, isSprinting)
    local px, py = self.collider:getLinearVelocity()
    local maxSpeed = isSprinting and (xMaxSpeed * sprintFactor) or xMaxSpeed
    if (math.abs(px) < maxSpeed) then
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
    if self.shootCooldown > .25 then
        local px, py = self.collider:getPosition()

        local bullet = Bullet:new(self, px, py, round(self.facing.x), round(self.facing.y))
        table.insert(self.bullets, bullet)
        self.shootCooldown = 0
    end
end

function Player:keypressed(key)
    -- if key == self.config.shoot then
    --     self:tryShoot()
    --     local px, py = self.collider:getPosition()
    --     local bullet = Bullet:new(self, px, py, self.facing.x, self.facing.y)
    --     table.insert(self.bullets, bullet)
    -- end
end

function Player:kill()
    if not self:isInvulnerable() then
        Screen:setShake(20)
        self:respawn()
        return true
    end
    return false
end

function Player:respawn()
    self.invulnerableTime = RESPAWN_INVULNERABILITY_TIME
    self.collider:setPosition(self.config.spawn.x, self.config.spawn.y)
end

function Player:isInvulnerable()
    return self.invulnerableTime > 0
end

function Player:draw()
    love.graphics.push("all")
    -- love.graphics.setColor(unpack(self.config.colour))
    love.graphics.setColor(1, 1, 1)
    local px, py = self.collider:getPosition()
    local drawCenter = { x = px - (self.size.x / 2), y = py - (self.size.y / 2) }

    love.graphics.draw(
        self.sprite,
        px,
        py,
        self.collider:getAngle(),
        .1 * (self.facing.x * -1),
        .1,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )

    -- love.graphics.rectangle("fill", drawCenter.x, drawCenter.y, self.size.x, self.size.y)
    love.graphics.pop()

    if self:isInvulnerable() then
        love.graphics.push("all")
        love.graphics.setColor(0, 0, .8, .3)
        love.graphics.circle("fill", px, py, self.size.x)
        love.graphics.pop()
    end
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

function round(num)
    local addVal = num >= 0 and 0.5 or -0.5
    return math.floor(num + addVal)
end
