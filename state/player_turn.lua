
local Vec = require 'common.vec'
local CharacterStats = require 'view.character_stats'
local TurnCursor = require 'view.turn_cursor'
local ListMenu = require 'view.list_menu'
local State = require 'state'

local PlayerTurnState = require 'common.class' (State)

local TURN_OPTIONS = { 'Fight', 'Skill', 'Item', 'Run' }

function PlayerTurnState:_init(stack)
  self:super(stack)
  self.character = nil
  self.menu = ListMenu(TURN_OPTIONS)
end

function PlayerTurnState:enter(params)
  self.character = params.current_character
  self:_show_menu()
  self:_show_cursor()
  self:_show_stats()
end

function PlayerTurnState:_show_menu()
  local bfbox = self:view():get('battlefield').bounds
  self.menu:reset_cursor()
  self.menu.position:set(bfbox.right + 32, (bfbox.top + bfbox.bottom) / 2)
  self:view():add('turn_menu', self.menu)
end

function PlayerTurnState:_show_cursor()
  local atlas = self:view():get('atlas')
  local sprite_instance = atlas:get(self.character)
  local cursor = TurnCursor(sprite_instance)
  self:view():add('turn_cursor', cursor)
end

function PlayerTurnState:_show_stats()
  local bfbox = self:view():get('battlefield').bounds
  local position = Vec(bfbox.right + 16, bfbox.top)
  local char_stats = CharacterStats(position, self.character)
  self:view():add('char_stats', char_stats)
end

function PlayerTurnState:leave()
  self:view():remove('turn_menu')
  self:view():remove('turn_cursor')
  self:view():remove('char_stats')
end

function PlayerTurnState:on_keypressed(key)
  if key == 'down' then
    self.menu:next()
  elseif key == 'up' then
    self.menu:previous()
  elseif key == 'return' then
    local option = TURN_OPTIONS[self.menu:current_option()]
    return self:pop({ action = option, character = self.character })
  end
end

return PlayerTurnState

