-- background.lua (LÖVE 11+)
local Background = {}
Background.__index = Background
local mesh

local function clamp(x, a, b) return math.max(a, math.min(b, x)) end

function Background.new()
  return setmetatable({score = 0}, Background)
end

function Background:update(score)
  self.score = clamp(score or 0, -100, 100)
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()

  local t  = math.abs(self.score) / 100          -- 0..1 fill
  local fh = h * t
  local yBottom, yTop = h, h - fh

  local r,g,b = 0,0,0
  if self.score > 0 then r = 1 elseif self.score < 0 then b = 1 end

  -- x,y, u,v, r,g,b,a  (correct attribute order)
  local verts = {
    {0,  yBottom, 0,1,  r,g,b,.8},   -- bottom left  = color
    {w,  yBottom, 1,1,  r,g,b,.8},   -- bottom right = color
    {w,  yTop,    1,0,  0,0,0,.8},   -- top right    = black
    {0,  yTop,    0,0,  0,0,0,.8},   -- top left     = black
  }

  if not mesh then
    mesh = love.graphics.newMesh(verts, "fan", "dynamic")
  else
    for i=1,#verts do mesh:setVertex(i, verts[i]) end
  end
end

function Background:draw()
  love.graphics.push("all")
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  if mesh then
    love.graphics.setColor(1,1,1,1) -- no tint
    love.graphics.draw(mesh, 0, 0)
  end
  love.graphics.pop()
end

return Background

