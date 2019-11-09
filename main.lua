-- luacheck: globals love

local Stack = require 'stack'
local View  = require 'view'
_G.team = {}

local _game
local _stack

_G.image   = {}
_G.contImg = 1

function love.load()
  _G.image[1] = love.graphics.newImage('assets/textures/conan.jpg')
  _G.image[2] = love.graphics.newImage('assets/textures/redsonja.jpg')
  _G.image[3] = love.graphics.newImage('assets/textures/icegiant.jpg')
  _G.image[4] = love.graphics.newImage('assets/textures/gameOver.jpg')
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
  local g = love.graphics
   g.draw(_G.image[_G.contImg])
  _game.view:draw()
end

for eventname, _ in pairs(love.handlers) do
  love[eventname] = function (...)
    _stack:forward(eventname, ...)
  end
end
