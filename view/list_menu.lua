
local Vec = require 'common.vec'

local ListMenu = require 'common.class' ()

ListMenu.GAP = 4
ListMenu.PADDING = Vec(24, 8)

function ListMenu:_init(options)
  self.font = love.graphics.newFont('assets/fonts/VT323-Regular.ttf', 36)
  self.font:setFilter('nearest', 'nearest')
  self.position = Vec()
  self.options = {}
  local vert_offset = 0
  local max_width = 0
  for i, option in ipairs(options) do
    self.options[i] = love.graphics.newText(self.font, option)
    local width, height = self.options[i]:getDimensions()
    if width > max_width then
      max_width = width
    end
    vert_offset = vert_offset + height + ListMenu.GAP
  end
  self.size = Vec(max_width, vert_offset)
  self.current = 1
end

function ListMenu:reset_cursor()
  self.current = 1
end

function ListMenu:next()
  self.current = math.min(#self.options, self.current + 1)
end

function ListMenu:previous()
  self.current = math.max(1, self.current - 1)
end

function ListMenu:current_option()
  return self.current
end

function ListMenu:get_dimensions()
  return (self.size + ListMenu.PADDING * 2):get()
end

function ListMenu:draw()
  local g = love.graphics
  local size = self.size + ListMenu.PADDING * 2
  local voffset = 0
  g.push()
  g.translate(self.position:get())
  g.setColor(1, 1, 1)
  g.setLineWidth(4)
  g.rectangle('line', 0, 0, size:get())
  g.translate(ListMenu.PADDING:get())
  for i, option in ipairs(self.options) do
    local height = option:getHeight()
    if i == self.current then
      local left = - ListMenu.PADDING.x * 0.5
      local right = - ListMenu.PADDING.x * 0.25
      local top, bottom = voffset + height * .25, voffset + height * .75
      g.polygon('fill', left, top, right, (top + bottom) / 2, left, bottom)
    end
    g.setColor(1, 1, 1)
    g.draw(option, 0, voffset)
    voffset = voffset + height + ListMenu.GAP
  end
  g.pop()
end

return ListMenu

