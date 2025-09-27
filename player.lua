Player = {}
Player.__index = Player


function Player:new(config)
    local obj = setmetatable({}, self)
    obj.config = config
    obj.collider = GameWorld.world:newRectangleCollider(350, 100, 80, 80)
    obj.collider:setCollisionClass(config.collisionClass)
    return obj
end


function Player:update(dt)
    local px, py = self.collider:getLinearVelocity()
    if love.keyboard.isDown(self.config.left) and px > -300 then
        self.collider:applyLinearImpulse(-5000, 0)
    end
    if love.keyboard.isDown(self.config.right) and px < 300 then
        self.collider:applyLinearImpulse(5000, 0)
    end
    if love.keyboard.isDown(self.config.up) and py == 0 then
        self.collider:applyLinearImpulse(0, -5000)
    end
end
