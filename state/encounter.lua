
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
local FightState = require 'state.fight'

_G.hero   = {}
_G.noHero = {}

local EncounterState = require 'common.class' (State)

local CHARACTER_GAP = 96

local MESSAGES = {
  Fight = "%s attacked ",
  Skill = "%s unleashed a skill",
  Item = "%s used an item",
}

local Fight
function EncounterState:_init(stack)
  self:super(stack)
  self.turns = nil
  self.next_turn = nil
  Fight = FightState(stack)
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


local combat = {}
_G.fightState = true

local battlefield = BattleField()
local bfbox = battlefield.bounds
local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))

function EncounterState:resume(params)
  print("params=", params)
  if params.action ~= 'Run' then
    if params.action == 'Fight' then
       _G.fightState = true
    else
      _G.fightState = false
    end
    if params.action == 'Skill' then
        print('skill: gera alguma coisa.')
    end
  else
    local tab = {}

    for _, j in ipairs(_G.combat) do
      tab = j
      local char1 = tab[1]
      local char2 = tab[2]

      print(char1:get_name() .. " vs " .. char2:get_name())
      local pos1, pos2 = Vec(10, 10), Vec(20, 20)
      local statsChar1 = CharacterStats(pos1, char1)
      local statsChar2 = CharacterStats(pos2, char2)

      Fight:addChars(char1, char2)
      --while char1:get_hp() > 0 and char2:get_hp() > 0 do

        if(Clash.acerto(char1:get_uncertainty())) then
          char2:hit(char1:get_power())
          print("heroi acertou \nvida inimigo:", char2:get_hp())
          if(char2:get_hp() <= 0) then break end
        end
        if(Clash.acerto(char2:get_uncertainty())) then
          char1:hit(char2:get_power())
          print("inimigo acertou \nvida heroi:", char1:get_hp())
          if(char1:get_hp() <= 0) then break end
        end
        print()
        --[[statsChar1:draw()
        statsChar2:draw()]]

        --[[self:view():add('char1_stats', statsChar1)
        self:view():add('char2_stats', statsChar2)]]

        Fight:update()

        love.timer.sleep(1)

        --[[
        local bfbox = self:view():get('battlefield').bounds
        local position = Vec(bfbox.right + 16, bfbox.top)
        local char_stats = CharacterStats(position, self.character)
        self:view():add('char_stats', char_stats)
        ]]
      --end
      Fight:leave()
    end
    _G.combat = {}
    _G.heroSelect = {}
    --precisa colocar aqui uma condiçao
    --so vai para a proxima quest quando os herois vencerem, se os monstros vencerem paraq o jogo
    print("params=", params)
  
    print("fim do enter do encounter")
    local party = _G.quest.party

    --[[Esperamos que de certo. Se nao der,
        vai ter varias vezes a mesma tabela.]]

    table.insert(_G.heros, char1)
    table.insert(_G.monsters, char2)

    _G.whichEncounter = _G.whichEncounter + 1
    local herosAlive, monstersAlive = true, true
    if #_G.heros == #party then
      local dead = 0
      for _, hero in pairs(_G.heros) do
        local hp = hero:get_hp()
        if  hp <= 0 then
          dead = dead + 1
        end
      end
      if dead == #party then 
        herosAlive = false
      end
    end
    if herosAlive == false then
      return self:pop(params)
    end
  end
end

return EncounterState
