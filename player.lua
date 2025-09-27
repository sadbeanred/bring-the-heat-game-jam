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



function Player:new(config)
    local obj = setmetatable({}, self)
    obj.config = config
    obj.collider = GameWorld.world:newRectangleCollider(obj.config.spawn.x, obj.config.spawn.y, obj.size.x, obj.size.y)
    obj.collider:setObject(obj)
    obj.collider:setCollisionClass(config.name .. "Player")
    obj.facing = {x=0, y=0}
    obj.bullets = {}
    return obj
end


function Player:update(dt)
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
        self.facing.y = 1
        self.collider:applyLinearImpulse(0, -5000)
    end

    if self.bullets then
        for i, bullet in ipairs(self.bullets) do
            bullet:update(dt)
        end
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
