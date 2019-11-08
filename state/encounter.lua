
--local Combat = require 'combat.combat_quest'
local Vec = require 'common.vec'
--local MessageBox = require 'view.message_box'
local SpriteAtlas = require 'view.sprite_atlas'
local BattleField = require 'view.battlefield'
local State = require 'state'
--local Stack = require 'stack'
local MessageBox = require 'view.message_box'
local CharacterStats = require 'view.character_stats'
--local TurnCursor = require 'view.turn_cursor'
--local ListMenu = require 'view.list_menu'
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

  if params.action ~= 'Run' then
    if params.action == 'Fight' then
       _G.fightState = true
    else
      _G.fightState = false
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

        if(Clash.acerto(char1:get_uncertainty()) and
            char1:get_hp() > 0 and char2:get_hp() > 0) then
          char2:hit(char1:get_power())
          print("heroi acertou \nvida inimigo:", char2:get_hp())
          --if(char2:get_hp() <= 0) then break end
        end
        if(Clash.acerto(char2:get_uncertainty()) and
            char1:get_hp() > 0 and char2:get_hp() > 0) then
          char1:hit(char2:get_power())
          print("inimigo acertou \nvida heroi:", char1:get_hp())
          --if(char1:get_hp() <= 0) then break end
        end
        print()

        print("inserting\n")
        _G.heros[char1:get_index()] = char1
        _G.monsters[char2:get_index()] = char2
        print("\ninserted")

        Fight:update()

        love.timer.sleep(1)
      Fight:leave()
    end
    _G.combat = {}
    _G.heroSelect = {}

    local party = _G.quest.party
    local encounter = params.encounter
    --precisamos pegar todos os monstros aqui (os nomes deles)
    print(encounter)

    print()
    print("heros inserted = {")
    for i, hero in pairs(_G.heros) do
      print(i, hero)
    end
    print("}\nmonsters inserted = {")
    local numOfMonsters = 0
    for i, monster in pairs(_G.monsters) do
      numOfMonsters = numOfMonsters + 1
      print(i, monster)
    end
    print("}\n")
    
    print("G.heros: ", #_G.heros)
    print("party: ", #party)
    print("numOfMonsters: ", numOfMonsters)
    print("G.numberOfMonsters: ", _G.numberOfMonsters)

    _G.whichEncounter = _G.whichEncounter + 1
    local herosAlive, monstersAlive = true, true
    
    if #_G.heros == #party then
      local dead = 0
      print("todos os herois surgiram")
      for _, hero in pairs(_G.heros) do
        local hp = hero:get_hp()
        if  hp <= 0 then
          dead = dead + 1
        end
      end
      if dead == #party then
        herosAlive = false
      end
      print("mortos=", dead)
    end

    if _G.numberOfMonsters == numOfMonsters then
	  local dead = 0
	  print("todos os monstros surgiram")
	  for _, monster in pairs(_G.monsters) do
        local hp = monster:get_hp()
        print(monster:get_name(), monster:get_hp())
        if  hp <= 0 then
          dead = dead + 1
        end
      end
      if dead == numOfMonsters then
        monstersAlive = false
      end
      print("mortos=", dead)
    end

    if herosAlive == false then
      print("OS HERÓIS PERDERAM")
      _G.heros = {}
      return self:pop(params)
    end
    
    if monstersAlive == false then
      print("OS HERÓIS VENCERAM")
      _G.monsters = {}
      return self:pop(params)
    end

    if _G.storeQuest then
      return self:pop(params)
    end

  end
end

return EncounterState
