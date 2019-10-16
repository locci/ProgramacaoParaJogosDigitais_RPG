
local ATLAS_DB    = require 'database.atlas'
local PALLETE_DB  = require 'database.palette'

local AtlasRenderer = require 'common.class' ()

function AtlasRenderer:_init()
  self.texture = love.graphics.newImage('assets/textures/' .. ATLAS_DB.texture)
  self.texture:setFilter('nearest', 'nearest')
  self.sprites = {}
  for name, sprite in pairs(ATLAS_DB.sprites) do
    sprite.quad = self:makeQuad(sprite.frame)
    self.sprites[name] = sprite
  end
  self.instances = {}
end

function AtlasRenderer:makeQuad(frame)
  local x, y = unpack(frame)
  return love.graphics.newQuad(
    x * (ATLAS_DB.frame_width + ATLAS_DB.gap_width),
    y * (ATLAS_DB.frame_height + ATLAS_DB.gap_height),
    ATLAS_DB.frame_width, ATLAS_DB.frame_height,
    self.texture:getDimensions()
  )
end

function AtlasRenderer:getDimensions() -- luacheck: no self
  local w, h = love.graphics.getDimensions()
  return w / ATLAS_DB.frame_width / 2, h / ATLAS_DB.frame_height / 2
end

function AtlasRenderer:add(name, pos, sprite_id)
  local instance = { position = pos, sprite_id = sprite_id }
  self.instances[name] = instance
  return instance
end

function AtlasRenderer:get(name)
  return self.instances[name]
end

function AtlasRenderer:clear()
  self.instances = {}
end

function AtlasRenderer:draw()
  local g = love.graphics
  g.push()
  for _, instance in pairs(self.instances) do
    local tex, sprite = self.texture, self.sprites[instance.sprite_id]
    local x, y = instance.position:get()
    x = math.floor(x)
    y = math.floor(y)
    g.setColor(PALLETE_DB[sprite.color])
    g.draw(tex, sprite.quad, x, y, 0, 4, 4,
           ATLAS_DB.frame_width/2, ATLAS_DB.frame_height/2)
  end
  g.pop()
end

return AtlasRenderer

