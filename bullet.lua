require "game"
Bullet = {}
Bullet.__index = Bullet

BULLET_SPEED = 100
local BULLET_SIZE = 6


function Bullet:new(from, x, y, xd, yd)
    local bullet = setmetatable({}, self)
    bullet.collider = GameWorld.world:newCircleCollider(x, y, BULLET_SIZE)
    bullet.collider:setMass(.1)
    bullet.collider:setGravityScale(.01)
    bullet.collider:applyLinearImpulse(BULLET_SPEED * xd, BULLET_SPEED * yd)
    bullet.collider:setCollisionClass(from.config.name .. "Bullet")
    bullet.from = from
    bullet.lifetime = 0
    bullet.maxAge = 3
    return bullet
end

function Bullet:update(dt)
    self.lifetime = self.lifetime + dt

    if self.collider:enter("IcePlayer") and self.from.config.name == "Fire" then
        local collision_data = self.collider:getEnterCollisionData('IcePlayer')
        self.collider:destroy()
        KillPlayer(collision_data.collider:getObject())
    end

    if self.collider:enter("FirePlayer") and self.from.config.name == "Ice" then
        local collision_data = self.collider:getEnterCollisionData('FirePlayer')
        self.collider:destroy()
        KillPlayer(collision_data.collider:getObject())
    end
    if (not self.collider:isDestroyed()) then
        if self.lifetime > self.maxAge then
            self.collider:destroy()
        end
    end

    if self.collider:enter("EnergyField") or
        self.collider:enter("Terrain")
    then
        self.collider:destroy()
    end
end

function Bullet:draw()
    if(self.collider == nil or self.collider:isDestroyed()) then
        return
    end
    local px, py = self.collider:getPosition()
    love.graphics.push("all")
    if self.from.config.name == "Fire" then
        love.graphics.setColor(1,.2,.2)
    else
        love.graphics.setColor(.2,.2,1)
    end
    love.graphics.circle("fill", px, py, BULLET_SIZE)
    love.graphics.pop()
end
