-- luacheck: globals love

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
  local strHp = ("HP: %d/%d"):format(self.character:get_hp())
  local strPw = ("PW: %d"):format(self.character:get_power())
  local strRs = ("RS: %d"):format(self.character:get_resistance())
  local strSp = ("SP: %d"):format(self.character:get_velocity())
  if self.character:get_side() then
    local strMN = ("$$: %d"):format(self.character:get_money())
    g.print((strHp .. "\n" .. strPw .. "\n" .. strRs .. "\n" .. strSp .. "\n" ..
            strMN):format(self.character:get_hp()))
  else
    g.print((strHp .. "\n" .. strPw .. "\n" .. strRs .. "\n"
            .. strSp):format(self.character:get_hp()))
  end
  g.pop()
end

return CharacterStats
