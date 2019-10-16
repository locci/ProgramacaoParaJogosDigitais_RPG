
local Box = require 'common.box'
local Vec = require 'common.vec'
local BattleField = require 'common.class' ()

local VPADDING = 64

function BattleField:_init()
  self.bounds = Box(32, 32+512, 32, 32 + VPADDING*2 + 64*4 + 16*3)
end

function BattleField:west_team_origin()
  return Vec(self.bounds.left + 64, self.bounds.top + 64)
end

function BattleField:east_team_origin()
  return Vec(self.bounds.right - 64, self.bounds.top + 64)
end

function BattleField:draw()
  local g = love.graphics
  g.setColor(1, 1, 1)
  g.setLineWidth(4)
  g.rectangle('line', self.bounds:get_rectangle())
end

return BattleField

