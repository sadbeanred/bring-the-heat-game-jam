CrystalManager = {}
CrystalManager.__index = CrystalManager

Interval = 5

CrystalLocations = {
   Fire = {
        {
            x= ((WindowWidth-GroundWidth)/4) + (CrystalSides/2),
            y = WindowHeight - (GroundHeight/1.5) - 50
        },
        {
            x = (CloseSideWallMargin/2) - (CrystalSides/2),
            y = WindowHeight - (JumpHeight*1.75) + WallHeight * .5 - (CrystalSides/2)
        },
        {
            x = WallWidth * 2 - (CrystalSides/2),
            y = WindowHeight - (JumpHeight * 2.6) - (CrystalSides/2)
        }
    },
    Ice = {
        {
            x = (WindowWidth - ((WindowWidth-GroundWidth)/3)) - (CrystalSides/2),
            y =WindowHeight - (GroundHeight/1.5) - 50
        },
        {
            x = WindowWidth - (CloseSideWallMargin/2) - (CrystalSides/2),
            y = WindowHeight - (JumpHeight*1.75) + WallHeight * .5 - (CrystalSides/2)
        },
        {
            x = WindowWidth - (WallWidth * 2) - (CrystalSides/2),
            y = WindowHeight - (JumpHeight * 2.6) - (CrystalSides/2)
        }
    }
}
function CrystalManager:new(faction)
    local obj = setmetatable({}, self)
    obj.faction = faction
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
            DestroyCrystal(crystal.faction)
            table.remove(self.crystals, i)
        end
    end
end

function CrystalManager:spawnCrystal()
    for i, location in ipairs(CrystalLocations[self.faction]) do
        if next(GameWorld.world:queryRectangleArea(location.x, location.y, CrystalSides, CrystalSides, {"Crystal"})) == nil then
            local crystal = Crystal:new(location.x, location.y, self.faction)
            table.insert(self.crystals, crystal)
            break
        end
    end
end

function CrystalManager:draw()
    for i, crystal in ipairs(self.crystals) do
        crystal:draw()
    end
end
