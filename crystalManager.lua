CrystalManager = {}
CrystalManager.__index = CrystalManager

Interval = 5

function CrystalManager:new(config)
    local obj = setmetatable({}, self)
    obj.config = config
    obj.timer = 0
    obj.crystals = {}
    return obj
end

function CrystalManager:update(dt)
    self.timer = self.timer + dt
    if self.timer >= Interval then
        self:spawnCrystal()
        self.timer = 0
    end

    for i, crystal in ipairs(self.crystals) do
        crystal:update(dt)
        if(crystal.collider:isDestroyed()) then
            DestroyCrystal(crystal.config.faction)
            table.remove(self.crystals, i)
        end
    end
end

function CrystalManager:spawnCrystal()
    local availableLocations = {}
    for i, location in ipairs(self.config.spawnLocations) do
        if next(GameWorld.world:queryRectangleArea(location.x, location.y, CrystalSides, CrystalSides, {"Crystal"})) == nil then
            table.insert(availableLocations, location)
        end
    end
    if #availableLocations == 0 then
        return
    end
    local location = availableLocations[math.random(#availableLocations)]
    local crystal = Crystal:new(location.x, location.y, self.config)
    table.insert(self.crystals, crystal)
end

function CrystalManager:draw()
    for i, crystal in ipairs(self.crystals) do
        crystal:draw()
    end
end
