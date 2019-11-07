
local Vec = require 'common.vec'
local State = require 'state'
local MessageBox = require 'view.message_box'
local BattleField = require 'view.battlefield'
local CharacterStats = require 'view.character_stats'
local TurnCursor = require 'view.turn_cursor'
local ListMenu = require 'view.list_menu'
local Sound = require 'common.sound'
local STORE = require 'model.store'

local PlayerTurnState = require 'common.class' (State)

local TURN_OPTIONS = { 'Fight', 'Skill', 'Item', 'Run' }
local DEFAULT_OPTIONS = { 'Fight', 'Skill', 'Item', 'Run' }

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
local merchandise = {}
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
  elseif key == 'm'  and _G.fightState then
    print(self.character:get_side() == false, combat[1] ~= nil, combat[2] == nil)
    if self.character:get_side() == false and combat[1] ~= nil and combat[2] == nil then
      Sound:play("monster")
      table.insert(combat, self.character)
      table.insert(_G.combat, combat)
      --table.insert(_G.combat, self.character)
      print("monstro inserido na batalha")
      self:view():add('message', message)
      message:set("Combat selected: " .. combat[1]:get_name() .. " vs " .. combat[2]:get_name())
      combat = {}
    end
  elseif key == 'i'  and _G.storeQuest then
    --[[if self.character:get_side() == false and merchandise[1] ~= nil and merchandise[2] == nil then
        local operation = merchandise[1]:get_money() - self.character:get_price()
        if operation >= 0  then
          Sound:play('regmachine')
          table.insert(merchandise, self.character)
          self:view():add('message', message)
          message:set("You buy: " .. merchandise[2]:get_name())
          self.character = merchandise[1]
          if merchandise[2]:get_appearance() == 'unguentoPW' then
            self.character:set_power(merchandise[2]:get_gain())
          elseif merchandise[2]:get_appearance() == 'unguentoRE' then
            self.character:set_resistance(merchandise[2]:get_gain())
          else
            self.character:set_velocity(merchandise[2]:get_gain())
          end
          self.character:set_money(self.character:get_price())
          local gain = merchandise[2]
          merchandise = {}
        else
        end
    end]]
    self:view():add('message', message)
    self.character, merchandise = STORE:select_item(self.character, merchandise, message, view)
  elseif key == 'k' then
    table.insert(_G.team, self.character)
  elseif key == 'return' then
    local option = TURN_OPTIONS[self.menu:current_option()]
    print(option)
    if option == "Skill" then
      local SKILLS = {'Skill01', 'Skill02', 'Skill03', 'Back'}
      TURN_OPTIONS = SKILLS
      self.menu = ListMenu(SKILLS)
      self:_show_menu()
    elseif option == "Back" then
      TURN_OPTIONS = DEFAULT_OPTIONS
      self.menu = ListMenu(TURN_OPTIONS)
      self:_show_menu()
    else
      return self:pop({ action = option, character = self.character })
    end
  elseif key == 'h' then
    print(self.character:get_side(), combat[1] == nil, _G.fightState,
            checkTable(self.character))
    if self.character:get_side() and combat[1] == nil and _G.fightState and
            checkTable(self.character) then
      Sound:play('sword')
      table.insert(_G.heroSelect, self.character)
      --table.insert(_G.combat, self.character)
      print("heroi inserido na batalha")
      table.insert(combat, self.character)
      self:view():add('message', message)
      local str = "You select The " .. self.character:get_name()
      print(str)
      message:set(str)
    end

  elseif key == 'b' then --buyer
    --[[if self.character:get_side() and merchandise[1] == nil and _G.storeQuest and
            checkTable(self.character) then
      Sound:play('coins')
      table.insert(_G.heroSelect, self.character)
      table.insert(merchandise, self.character)
      self:view():add('message', message)
      local str = "You select The " .. self.character:get_name() .. "... good  shop!!"
      message:set(str)
    end]]
    local view = self:view():add('message', message)
    local char = STORE:select_buyer(self.character, merchandise, checkTable(self.character)
      , message, view)
    table.insert(merchandise, char)


  elseif key == "escape" then
    love.event.quit()
  end
end

return PlayerTurnState
