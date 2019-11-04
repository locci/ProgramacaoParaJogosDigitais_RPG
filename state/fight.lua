-- luacheck: globals love

--local Combat = require 'combat.combat_quest'
local Vec = require 'common.vec'
local MessageBox = require 'view.message_box'
local SpriteAtlas = require 'view.sprite_atlas'
local BattleField = require 'view.battlefield'
local State = require 'state'
local Stack = require 'stack'
local MessageBox = require 'view.message_box'
local CharacterStats = require 'view.character_stats'
local TurnCursor = require 'view.turn_cursor'
local ListMenu = require 'view.list_menu'
local Clash = require 'clashCalc'

_G.hero   = {}
_G.noHero = {}

local FightState = require 'common.class' (State)

local FIGHTER_GAP = 96

local MESSAGES = {
  Fight = "%s attacked ",
  Skill = "%s unleashed a skill",
  Item = "%s used an item",
}

function FightState:_init(stack)
  self:super(stack)
end

local ch1, ch2
function FightState:addChars(char1, char2)
  ch1, ch2 = char1, char2
end

function FightState:enter(char1, char2)
  local atlas = SpriteAtlas()
  local battlefield = BattleField()
  local bfbox = battlefield.bounds
  local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))
  local party_origin = battlefield:east_team_origin()

  print("\nenter\n")
  local pos = party_origin + Vec(0, 1) * FIGHTER_GAP
  atlas:add(char1, pos, char1:get_appearance())

  party_origin = battlefield:west_team_origin()
  pos = party_origin + Vec(0, 1) * FIGHTER_GAP

  self:view():add('message', message)
  local str = "Fight!!!"
  message:set(str)
end

function FightState:leave()
  --self:view():get('atlas'):clear()
  --self:view():remove('atlas')
  --self:view():remove('battlefield')
  self:view():remove('message')
end

function FightState:update(_)
  --[[local current_character = self.turns[self.next_turn]
  self.next_turn = self.next_turn % #self.turns + 1
  local params = { current_character = current_character }]]
  return self:push('fight', ch1, ch2)
end


local combat = {}

local battlefield = BattleField()
local bfbox = battlefield.bounds
local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))


function FightState:resume(params)
  return self:pop()
end

return FightState
