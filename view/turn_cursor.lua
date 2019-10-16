
local Vec = require 'common.vec'
local TurnCursor = require 'common.class' ()

function TurnCursor:_init(selected_drawable)
  self.offset = Vec(0, -48)
  self.selected_drawable = selected_drawable
end

function TurnCursor:draw()
  if self.selected_drawable then
    local g = love.graphics
    local position = self.selected_drawable.position + self.offset
    g.push()
    g.translate(position:get())
    g.setColor(1, 1, 1)
    g.polygon('fill', -8, 0, 8, 0, 0, 8)
    g.pop()
  end
end

return TurnCursor

