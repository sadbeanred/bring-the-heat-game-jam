local Thermo = {}
Thermo.__index = Thermo

local function clamp(x,a,b) return math.max(a, math.min(b, x)) end
local function map(x, a1,b1, a2,b2) return (x-a1)/(b1-a1)*(b2-a2)+a2 end

function Thermo.new(opts)
  local t = setmetatable({}, Thermo)
  t.x = opts.x or 200            -- gauge center
  t.y = opts.y or 200
  t.h = opts.length or 220       -- tube length
  t.w = opts.width or 24         -- tube thickness
  t.r = opts.bulbRadius or 28
  t.min = opts.min or 0
  t.max = opts.max or 100
  t.value = clamp(opts.value or t.min, t.min, t.max)
  t.colors = opts.colors or {
    tube={0.9,0.9,0.9},
    border={0.2,0.2,0.2},
    midline={0.3,0.3,0.3}
  }
  return t
end

function Thermo:set(v) self.value = clamp(v, self.min, self.max) end
function Thermo:add(dv) self:set(self.value + dv) end

function Thermo:draw()
  local pct = clamp((self.value - self.min)/(self.max - self.min), 0, 1)

  -- total width = tube length + bulb radius*2 + gap
  local gap = self.r * 0.2
  local totalW = self.h + gap + self.r*2
  local tubeX = self.x - (totalW - self.r*2)/2
  local tubeY = self.y - self.w/2

  local fillW = self.h * pct
  local fillX = tubeX + (self.h - fillW)

  local r = map(pct, 0,1, 0.1,1.0)
  local g = map(pct, 0,1, 0.6,0.1)
  local b = map(pct, 0,1, 0.9,0.1)

  -- tube
  love.graphics.setColor(self.colors.tube)
  love.graphics.rectangle("fill", tubeX, tubeY, self.h, self.w, self.w/2, self.w/2)
  love.graphics.setColor(self.colors.border)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", tubeX, tubeY, self.h, self.w, self.w/2, self.w/2)

  -- fill inside tube
  love.graphics.setScissor(tubeX, tubeY, self.h, self.w)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("fill", fillX, tubeY, fillW, self.w, self.w/2, self.w/2)
  love.graphics.setScissor()

  -- bulb (right side)
  local bulbX = tubeX + self.h + gap + self.r
  love.graphics.setColor(self.colors.tube)
  love.graphics.circle("fill", bulbX, self.y, self.r)
  love.graphics.setColor(self.colors.border)
  love.graphics.circle("line", bulbX, self.y, self.r)
  love.graphics.setColor(r,g,b)
  love.graphics.circle("fill", bulbX, self.y, self.r*0.85)

  -- ticks
  love.graphics.setColor(self.colors.border)
  for i=0,10 do
    local tx = tubeX + self.h - self.h*(i/10)
    local len = (i%5==0) and 14 or 8
    love.graphics.line(tx, tubeY + self.w + 4, tx, tubeY + self.w + 4 + len)
  end

  -- mid-line marker
  local midX = tubeX + self.h/2
  love.graphics.setColor(self.colors.midline)
  love.graphics.setLineWidth(3)
  love.graphics.line(midX, tubeY-6, midX, tubeY+self.w+6)

  -- value label near bulb
  love.graphics.setColor(1,1,1)
  love.graphics.printf(string.format("%d", math.floor(self.value)),
    bulbX + self.r + 8, self.y - 8, 80, "left")
end

return Thermo

