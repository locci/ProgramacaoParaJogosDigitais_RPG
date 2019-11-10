-- luacheck: globals love

local Vec = require 'common.vec'
local State = require 'state'
local MessageBox = require 'view.message_box'
local BattleField = require 'view.battlefield'
local CharacterStats = require 'view.character_stats'
local TurnCursor = require 'view.turn_cursor'
local ListMenu = require 'view.list_menu'
local STORE = require 'model.store'
local Sound = require 'common.sound'

local PlayerTurnState = require 'common.class' (State)

local TURN_OPTIONS = { 'Fight', 'Skill', 'Item', 'Run' }
local DEFAULT_OPTIONS = { 'Fight', 'Skill', 'Item', 'Run' }

function PlayerTurnState:_init(stack)
  self:super(stack)
  self.character = nil
  self.menu = ListMenu(TURN_OPTIONS)
end

function PlayerTurnState:enter(params)
  self.character = params.currentChar
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
  Sound.play('page')
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
  local allItems = self.character:getAllItems()
  local allSkills = self.character:getAllSkills()

  if key == 'down' then
    Sound.play('updown')
    self.menu:next()
  elseif key == 'up' then
    Sound.play('updown')
    self.menu:previous()
  elseif key == 'm'  and _G.fightState then
    if self.character:get_side() == false and combat[1] ~= nil and combat[2] == nil
        and self.character:get_hp() > 0 then
      Sound:play('monster')
      table.insert(combat, self.character)
      table.insert(_G.combat, combat)
      self:view():add('message', message)
      message:set("Combat selected: " .. combat[1]:get_name() .. " vs " .. combat[2]:get_name())
      combat = {}
      _G.select = "hero"
    end
  elseif key == 'h' then
    if self.character:get_side() and combat[1] == nil and _G.fightState and
            checkTable(self.character) then
      Sound:play('sword')
      table.insert(_G.heroSelect, self.character)

      table.insert(combat, self.character)
      self:view():add('message', message)
      local str = self.character:get_name() .. " selected"
      message:set(str)
      _G.select = "monster"
      if self.character:get_hp() <= 0 then
        self:view():add('message', message)
        str = str .. '\nThis monster is gone!!'
        message:set(str)
        _G.select = "monster"
      end
    end
  elseif key == 'i'  and _G.storeQuest then
    self:view():add('message', message)
    self.character, merchandise = STORE.select_item(self.character, merchandise, message)
  elseif key == 'k' then
    table.insert(_G.team, self.character)
  elseif key == 'return' then
    local option = TURN_OPTIONS[self.menu:current_option()]
    if option == "Skill" then
      local SKILLS = {}
      for _,item in pairs(allSkills) do
        table.insert(SKILLS, item.name)
      end
      table.insert(SKILLS, "Back")
      TURN_OPTIONS = SKILLS
      self.menu = ListMenu(SKILLS)
      self:_show_menu()
      _G.lastOption = "Skill"
    elseif option == "Item" then
      local ITEMS = {}
      for _,item in pairs(allItems) do
        table.insert(ITEMS, item.name)
      end
      table.insert(ITEMS, "Back")
      TURN_OPTIONS = ITEMS
      self.menu = ListMenu(ITEMS)
      self:_show_menu()
      _G.lastOption = "Item"
    elseif option == "Back" then
      TURN_OPTIONS = DEFAULT_OPTIONS
      self.menu = ListMenu(TURN_OPTIONS)
      self:_show_menu()
    elseif option == "Fight" or option == "Run" then
      return self:pop({ action = option, character = self.character })

    elseif _G.lastOption == "Skill" then
      local skill = allSkills[option]
      self.character:set_skill(skill)
      self:view():add('message', message)
      local str = skill.name .. ' selected'
      message:set(str)
    elseif _G.lastOption == "Item" then
      local item = allItems[option]
      self.character:set_item(item)
      self:view():add('message', message)
      local str = item.name .. ' selected'
      message:set(str)
    end

  elseif key == 'h' then
    if self.character:get_side() and combat[1] == nil and _G.fightState and
            checkTable(self.character) then
      Sound:play('charge')
      table.insert(_G.heroSelect, self.character)
      table.insert(combat, self.character)
      self:view():add('message', message)
      local str = "You select The " .. self.character:get_name()
      message:set(str)
    end
    if self.character:get_hp() <= 0 then
      self:view():add('message', message)
      local str = 'You are dead!!! Get out!!!'
      message:set(str)
    end
  elseif key == 'b' and _G.storeQuest then
    local view = self:view():add('message', message)
    local char = STORE.select_buyer(self.character, merchandise, checkTable(self.character)
      , message, view)
    table.insert(merchandise, char)
  elseif key == "escape" then
    love.event.quit()
  end
end

return PlayerTurnState
