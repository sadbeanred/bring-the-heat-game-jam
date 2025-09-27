require "game"
Bullet = {

}
Bullet.__index = Bullet

BULLET_SPEED = 1000


function Bullet:new(from, x, y, xd, yd)
    local bullet = setmetatable({}, self)
    bullet.collider = GameWorld.world:newCircleCollider(x, y, 10)
    bullet.collider:applyLinearImpulse(BULLET_SPEED * xd, BULLET_SPEED * yd)
    bullet.collider:setCollisionClass(from.config.name .. "Bullet")
    bullet.from = from
    return bullet
end

function Bullet:update(dt)
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
end
