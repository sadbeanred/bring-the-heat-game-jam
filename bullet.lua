Bullet = {

}
Bullet.__index = Bullet

BULLET_SPEED = 1000


function Bullet:new(x, y, xd, yd)
    local bullet = setmetatable({}, self)
    bullet.collider = world:newCircleCollider(x, y, 10)
    bullet.collider:applyLinearImpulse(BULLET_SPEED * xd, BULLET_SPEED * yd)
    return bullet
end





function Bullet:update(dt)


end
