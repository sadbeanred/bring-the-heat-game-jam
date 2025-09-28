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



function Player:new(config)
    local obj = setmetatable({}, self)
    obj.config = config
    obj.collider = GameWorld.world:newRectangleCollider(obj.config.spawn.x, obj.config.spawn.y, obj.size.x, obj.size.y)
    obj.collider:setObject(obj)
    obj.collider:setCollisionClass(config.name .. "Player")
    obj.facing = { x = 0, y = 0 }
    obj.bullets = {}
    obj.invulnerableTime = 0
    return obj
end

function Player:update(dt)
    self.invulnerableTime = math.max(self.invulnerableTime - dt, 0)
    local px, py = self.collider:getLinearVelocity()
    if love.keyboard.isDown(self.config.left) and px > -300 then
        self.facing.x = -1
        self.collider:applyLinearImpulse(-1000, 0)
    end
    if love.keyboard.isDown(self.config.right) and px < 300 then
        self.facing.x = 1
        self.collider:applyLinearImpulse(1000, 0)
    end
    if love.keyboard.isDown(self.config.up) and py == 0 then
        -- self.facing.y = 1
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

function Player:keypressed(key)
    if key == self.config.shoot then
        local px, py = self.collider:getPosition()
        local bullet = Bullet:new(self, px, py, self.facing.x, self.facing.y)
        table.insert(self.bullets, bullet)
    end
end

function Player:kill()
    if not self:isInvulnerable() then
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
    love.graphics.setColor(unpack(self.config.colour))
    local px, py = self.collider:getPosition()
    local drawCenter = { x = px - (self.size.x / 2), y = py - (self.size.y / 2) }
    love.graphics.rectangle("fill", drawCenter.x, drawCenter.y, self.size.x, self.size.y)
    love.graphics.pop()
    if self:isInvulnerable() then
        love.graphics.push("all")
        love.graphics.setColor(0,0,.8, .3)
        love.graphics.circle("fill", px,py, self.size.x)
        love.graphics.pop()
    end
end
