
local Vec = require 'common.vec'
local MessageBox = require 'common.class' ()

function MessageBox:_init(position)
  self.message = nil
  self.position = Vec(position:get())
  self.font = love.graphics.newFont('assets/fonts/VT323-Regular.ttf', 36)
  self.font:setFilter('nearest', 'nearest')
end

function MessageBox:set(message)
  self.message = love.graphics.newText(self.font, message)
end

function MessageBox:draw()
  if self.message then
    local g = love.graphics
    g.push()
    g.setColor(1, 1, 1)
    g.translate(self.position:get())
    g.draw(self.message)
    g.pop()
  end
end

return MessageBox

