Crystal = {}
Crystal.__index = Crystal
CrystalSides = 15
CrystalCornerRadius = 3

function Crystal:new(x, y, config)
    local obj = setmetatable({}, self)
    obj.collider = GameWorld.world:newBSGRectangleCollider(x, y, CrystalSides, CrystalSides, CrystalCornerRadius)
    obj.collider:setType("static")
    obj.collider:setCollisionClass(config.faction.."Crystal")
    obj.config = config
    return obj
end

function Crystal:update(dt)
    if((self.config.faction == "Ice" and self.collider:enter("FireBullet")) or
         (self.config.faction == "Fire" and self.collider:enter("IceBullet"))) then
          self.config.audio.kill:clone():play()
          self.collider:destroy()
    end
end

function Crystal:draw()
    love.graphics.setColor(self.config.color)
    local px, py = self.collider:getPosition()
    love.graphics.rectangle("fill", px - (CrystalSides / 2) + .5, py - (CrystalSides / 2) -.1, CrystalSides-.5,  CrystalSides-.5, CrystalCornerRadius*1.75)
end
