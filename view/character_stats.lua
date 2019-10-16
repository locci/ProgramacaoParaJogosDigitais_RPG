
local CharacterStats = require 'common.class' ()

function CharacterStats:_init(position, character)
  self.position = position
  self.character = character
  self.font = love.graphics.newFont('assets/fonts/VT323-Regular.ttf', 36)
  self.font:setFilter('nearest', 'nearest')
end

function CharacterStats:draw()
  local g = love.graphics
  g.push()
  g.setFont(self.font)
  g.setColor(1, 1, 1)
  g.translate(self.position:get())
  g.print(self.character:get_name())
  g.translate(0, self.font:getHeight())
  g.print(("HP: %d/%d"):format(self.character:get_hp()))
  g.pop()
end

return CharacterStats

