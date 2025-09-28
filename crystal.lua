Crystal = {}
Crystal.__index = Crystal
CrystalSides = 15
CrystalCornerRadius = 3

function Crystal:new(x, y, faction)
    local obj = setmetatable({}, self)
    obj.collider = GameWorld.world:newBSGRectangleCollider(x, y, CrystalSides, CrystalSides, CrystalCornerRadius)
    obj.collider:setType("static")
    obj.collider:setCollisionClass(faction.."Crystal")
    obj.faction = faction
    return obj
end

function Crystal:update(dt)
    if(self.faction == "Ice" and self.collider:enter("FireBullet")) then
        self.collider:destroy()
    end
    if(self.faction == "Fire" and self.collider:enter("IceBullet")) then
        self.collider:destroy()
    end
end

function Crystal:draw()
    love.graphics.setColor(self.faction == "Fire" and {1, 0, 0} or {0, 0, 1})
    local px, py = self.collider:getPosition()
    love.graphics.rectangle("fill", px - (CrystalSides / 2) + .5, py - (CrystalSides / 2) -.1, CrystalSides-.5,  CrystalSides-.5, CrystalCornerRadius*1.75)
end
