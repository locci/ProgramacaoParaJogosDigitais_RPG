
--local Combat = require 'combat.combat_quest'
local Vec = require 'common.vec'
local MessageBox = require 'view.message_box'
local SpriteAtlas = require 'view.sprite_atlas'
local BattleField = require 'view.battlefield'
local State = require 'state'
local Stack = require 'stack'
_G.hero   = {}
_G.noHero = {}

local EncounterState = require 'common.class' (State)

local CHARACTER_GAP = 96

local MESSAGES = {
  Fight = "%s attacked ",
  Skill = "%s unleashed a skill",
  Item = "%s used an item",
}

function EncounterState:_init(stack)
  self:super(stack)
  self.turns = nil
  self.next_turn = nil
end

function EncounterState:enter(params)
  local atlas = SpriteAtlas()
  local battlefield = BattleField()
  local bfbox = battlefield.bounds
  local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))
  local n = 0
  local party_origin = battlefield:east_team_origin()
  self.turns = {}
  self.next_turn = 1
  _G.hero = {}
  for i, character in ipairs(params.party) do
    local pos = party_origin + Vec(0, 1) * CHARACTER_GAP * (i - 1)
    self.turns[i] = character
    atlas:add(character, pos, character:get_appearance())
    n = n + 1
    table.insert(_G.hero, character)
  end
  local encounter_origin = battlefield:west_team_origin()
  _G.noHero = {}
  for i, character in ipairs(params.encounter) do
    local pos = encounter_origin + Vec(0, 1) * CHARACTER_GAP * (i - 1)
    self.turns[n + i] = character
    atlas:add(character, pos, character:get_appearance())
    table.insert(_G.noHero, character)
  end
  self:view():add('atlas', atlas)
  self:view():add('battlefield', battlefield)
  self:view():add('message', message)
  local str = "You stumble upon an encounter \n" .. "Are you prepered?"
  message:set(str)
end

function EncounterState:leave()
  self:view():get('atlas'):clear()
  self:view():remove('atlas')
  self:view():remove('battlefield')
  self:view():remove('message')
end

function EncounterState:update(_)
  local current_character = self.turns[self.next_turn]
  self.next_turn = self.next_turn % #self.turns + 1
  local params = { current_character = current_character }
  return self:push('player_turn', params)
end

local pairCombat = function(params)

  local message = noHero[1]:get_name()

  return message, {}

end

local combat = {}

function EncounterState:resume(params)
  local A = {}
  local oponente
  if params.action ~= 'Run' then
    oponente , A = pairCombat(params)
    --table.insert(combat, A)
    local message = MESSAGES[params.action]:format(params.character:get_name())
    self:view():get('message'):set(message .. oponente)
  else
    return self:pop()
  end
end

return EncounterState


