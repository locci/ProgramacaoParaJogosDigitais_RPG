-- luacheck: globals love

local PALETTE_DB = require 'database.palette'
local State = require 'state'
local ListMenu = require 'view.list_menu'
local Vec = require 'common.vec'
local imSelec = require 'view.imageSelector'
local Sound = require 'common.sound'

local ChooseQuestState = require 'common.class' (State)

local LMARGIN = 32

function ChooseQuestState:_init(stack)
  self:super(stack)
  local options = self:_load_quests()
  local h = love.graphics.getHeight()
  self.menu = ListMenu(options)
  self.menu.position = Vec(LMARGIN, h / 2)
end

function ChooseQuestState:_load_quests()
  local options = {}
  local quest_names = love.filesystem.getDirectoryItems('database/quests')
  self.quests = {}
  for i, name in ipairs(quest_names) do
    name = name:sub(1, -5)
    local quest = require('database.quests.' .. name)
    options[i] = quest.title
    self.quests[i] = quest
  end
  return options
end

function ChooseQuestState:enter()
  love.graphics.setBackgroundColor(PALETTE_DB.black)
  self:view():add('quest_menu', self.menu)
end

function ChooseQuestState:suspend()
  self:view():remove('quest_menu')
end

function ChooseQuestState:resume()
  self:view():add('quest_menu', self.menu)
end

function ChooseQuestState:leave()
  self:view():remove('quest_menu')
end

_G.storeQuest = true

function ChooseQuestState:on_keypressed(key)
  if key == 'down' then
    Sound.play('updown')
    self.menu:next()
  elseif key == 'up' then
    Sound.play('updown')
    self.menu:previous()
  elseif key == 'return' then
    local option = self.menu:current_option()
    local params = { quest = self.quests[option] }
    local name = params.quest.title
    _G.environment = params.quest.environment
    Sound.play('page')
    imSelec.set_image(name)
    _G.quest = params.quest
    _G.whichEncounter = 1
    _G.heros = {}
    _G.monsters = {}
    _G.allHeros = {}
    _G.select = "hero"
    _G.numberOfHeros = #_G.quest.party
    return self:push('follow_quest', params)
  elseif key == 'escape' then
    return self:pop()
  end
end

return ChooseQuestState
