-- luacheck: globals love

local Stack = require 'stack'
local View  = require 'view'
_G.team = {}

local _game
local _stack
local img

function love.load()
  _game = {
    view = View()
  }
  _stack = Stack(_game)
  _stack:push('choose_quest')
end

function love.update(dt)
  local g = love.graphics
  g.setBackgroundColor(0,0,250)
  _stack:update(dt)
  _game.view:update(dt)
end

function love.draw()
  _game.view:draw()
end

for eventname, _ in pairs(love.handlers) do
  love[eventname] = function (...)
    _stack:forward(eventname, ...)
  end
end
