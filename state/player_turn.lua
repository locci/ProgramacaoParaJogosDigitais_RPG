
local Vec = require 'common.vec'
local State = require 'state'
local MessageBox = require 'view.message_box'
local BattleField = require 'view.battlefield'
local CharacterStats = require 'view.character_stats'
local TurnCursor = require 'view.turn_cursor'
local ListMenu = require 'view.list_menu'
local Sound = require 'common.sound'

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
  self.menu.position:set(bfbox.right + 32,  ((bfbox.top + bfbox.bottom) / 2) + 40)
  self:view():add('turn_menu', self.menu)
end

function PlayerTurnState:_show_cursor()
  local atlas = self:view():get('atlas')
  local sprite_instance = atlas:get(self.character)
  local cursor   = TurnCursor(sprite_instance)
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

local combat = {}
_G.heroSelect = {}
_G.combat = {}

local checkTable = function(element)
  for _, j in ipairs(_G.heroSelect) do
    if j == element then return false end
  end
  return true
end

local battlefield = BattleField()
local bfbox = battlefield.bounds
local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))

function PlayerTurnState:on_keypressed(key)

  if key == 'down' then
    self.menu:next()
  elseif key == 'up' then
    self.menu:previous()
  elseif key == 'f'  and _G.fightState then
    if self.character:get_side() == false and combat[1] ~= nil and combat[2] == nil then
      Sound:play('monster')
      table.insert(combat, self.character)
      table.insert(_G.combat, combat)
      self:view():add('message', message)
      message:set("Combat selected: " .. combat[1]:get_name() .. " vs " .. combat[2]:get_name())
      combat = {}
    end
  elseif key == 'k' then
    table.insert(_G.team, self.character)
    print(#_G.team)
  elseif key == 'return' then
    local option = TURN_OPTIONS[self.menu:current_option()]
    return self:pop({ action = option, character = self.character })
  elseif key == 's' then
    if self.character:get_side() and combat[1] == nil and _G.fightState and
            checkTable(self.character) then
      Sound:play('sword')
      table.insert(_G.heroSelect, self.character)
      table.insert(combat, self.character)
      self:view():add('message', message)
      local str = "You select The " .. self.character:get_name()
      message:set(str)
    end
  end
end

return PlayerTurnState
