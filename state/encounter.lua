--local Combat = require 'combat.combat_quest'
local Vec = require 'common.vec'
local MessageBox = require 'view.message_box'
local SpriteAtlas = require 'view.sprite_atlas'
local BattleField = require 'view.battlefield'
local State = require 'state'
--local Stack = require 'stack'
local CharacterStats = require 'view.character_stats'
--local TurnCursor = require 'view.turn_cursor'
--local ListMenu = require 'view.list_menu'
local Clash = require 'clashCalc'
local FightState = require 'state.fight'
local imSelec = require 'view.imageSelector'
local Sound = require 'common.sound'


_G.hero   = {}
_G.noHero = {}

local EncounterState = require 'common.class' (State)

local CHARACTER_GAP = 96

local MESSAGES = {
    Fight = "%s attacked ",
    Skill = "%s unleashed a skill",
    Item = "%s used an item",
}

local battlefield = BattleField()
local bfbox = battlefield.bounds
local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))

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
        if character:get_side() then
            table.insert(_G.allHeros, character)
        end
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
    local str = "You stumble upon an encounter \n" .. "Are you prepared?"
    message:set(str)
end

function EncounterState:leave()
    self:view():get('atlas'):clear()
    self:view():remove('atlas')
    self:view():remove('battlefield')
    self:view():remove('message')
end

function EncounterState:update(_)
    self.next_turn = (self.next_turn % #self.turns) + 1
    local currentChar = self.turns[self.next_turn]

    --Lado dos herois e true (meio estranho de ler o codigo assim)
    if _G.select == "monster" then
        while currentChar:get_side() and _G.storeQuest == false do
            self.next_turn = (self.next_turn % #self.turns) + 1
            currentChar = self.turns[self.next_turn]
        end
    elseif _G.select == "hero" and _G.storeQuest == false then
        local maxV = 0
        local index = 0
        for i, hero in pairs(_G.allHeros) do
            if (hero:get_velocity() > maxV) and hero:get_hp() > 0 then
                maxV = hero:get_velocity()
                index = i
            end
        end
        currentChar = _G.allHeros[index]
    end
    local params = { currentChar = currentChar }
    return self:push('player_turn', params)
end


local combat = {}
_G.fightState = true


function EncounterState:resume(params)

    if params.action ~= 'Run' then
        print(params.action)
        if params.action == 'Fight' then
            _G.fightState = true
        else
            _G.fightState = false
        end

    else
        local tab = {}
        if _G.storeQuest  then _G.contImg = 1 end
        local str = ""


        for _, j in ipairs(_G.combat) do

            tab = j
            local char1 = tab[1]
            local char2 = tab[2]

            if(Clash.acerto(char1:get_uncertainty()) and
                    char1:get_hp() > 0 and char2:get_hp() > 0) then
                char2:hit(char1:get_power())
                --print("heroi acertou \nvida inimigo:", char2:get_hp())
                --if(char2:get_hp() <= 0) then break end
            end
            if(Clash.acerto(char2:get_uncertainty()) and
                    char1:get_hp() > 0 and char2:get_hp() > 0) then
                char1:hit(char2:get_power())
                --print("inimigo acertou \nvida heroi:", char1:get_hp())
                --if(char1:get_hp() <= 0) then break end
            end

            _G.heros[char1:get_index()] = char1
            _G.monsters[char2:get_index()] = char2

            love.timer.sleep(1)
        end
        _G.combat = {}
        _G.heroSelect = {}

        local party = _G.quest.party
        local encounter = params.encounter
        print(encounter)
        print()
        local numOfMonsters = 0
        local numOfHeros = 0
        print("heros inserted = {")
        for i, hero in pairs(_G.heros) do
            print(i, hero)
        end
        print("}\nmonsters inserted = {")
        for i, hero in pairs(_G.monsters) do
            print(i, hero)
        end
        print("}\n")

        print(encounter)

        print()
        local numOfMonsters = 0
        local numOfHeros = 0
        print("heros inserted = {")
        for i, hero in pairs(_G.heros) do
            numOfHeros = numOfHeros + 1
            print(i, hero)
        end
        print("}\nmonsters inserted = {")
        for i, monster in pairs(_G.monsters) do
            numOfMonsters = numOfMonsters + 1
            print(i, monster)
        end
        print("}\n")

        print("Numero total de herois: ", _G.numberOfHeros)
        print("Herois que apareceram: ", numOfHeros)
        print("Numero total de monstros: ", _G.numberOfMonsters)
        print("Monstros que apareceram: ", numOfMonsters)

        _G.whichEncounter = _G.whichEncounter + 1
        local herosAlive, monstersAlive = true, true

        if _G.numberOfHeros == numOfHeros then
            local dead = 0
            print("todos os herois surgiram")
            for _, hero in pairs(_G.heros) do
                local hp = hero:get_hp()
                if  hp <= 0 then
                    dead = dead + 1
                end
            end
            if dead == numOfHeros then
                herosAlive = false
            end
            print("Herois Mortos = ", dead)
        end

        if _G.numberOfMonsters == numOfMonsters then
            local dead = 0
            print("todos os monstros surgiram")
            for _, monster in pairs(_G.monsters) do
                local hp = monster:get_hp()
                if  hp <= 0 then
                    dead = dead + 1
                end
            end
            if dead == numOfMonsters then
                monstersAlive = false
            end
            print("Monstros Mortos = ", dead)
        end

        if herosAlive == false then
            str = "HEROES LOST - press esc"
            self:view():add('message', message)
            message:set(str)
            str = ""

            print("OS HERÓIS PERDERAM")
            imSelec:set_image("Game Over")
            love.event.wait(100000)
            love.event.quit()
        end

        if monstersAlive == false then
            print("OS HERÓIS VENCERAM")
            Sound.play('victory')
            --local num = math.random(1,3)
            imSelec:set_image("Default")
            _G.monsters = {}
            self:pop(params)
        end

        --[[local numOfMonsters = 0
        local numOfHeros = 0
        print("\nheros inserted = {")
        for i, hero in pairs(_G.heros) do
          numOfHeros = numOfHeros + 1
          print(i, hero)
        end
        print("}\nmonsters inserted = {")
        for i, monster in pairs(_G.monsters) do
          numOfMonsters = numOfMonsters + 1
          print(i, monster)
        end
        print("}\n")
        print("Numero total de herois: ", _G.numberOfHeros)
        print("Herois que apareceram: ", numOfHeros)
        print("Numero total de monstros: ", _G.numberOfMonsters)
        print("Monstros que apareceram: ", numOfMonsters)
        _G.whichEncounter = _G.whichEncounter + 1
        local herosAlive, monstersAlive = true, true
        if _G.numberOfHeros == numOfHeros then
          local dead = 0
          print("todos os herois surgiram")
          for _, hero in pairs(_G.heros) do
                  local hp = hero:get_hp()
                  if  hp <= 0 then
                      dead = dead + 1
                end
           end
           if dead == numOfHeros then
                  herosAlive = false
           end
           print("Herois Mortos = ", dead)
        end
        if _G.numberOfMonsters == numOfMonsters then
          local dead = 0
          print("todos os monstros surgiram")
          for _, monster in pairs(_G.monsters) do
              local hp = monster:get_hp()
              if  hp <= 0 then
                  dead = dead + 1
              end
          end
          if dead == numOfMonsters then
              monstersAlive = false
          end
          print("Monstros Mortos = ", dead)
        end
        if herosAlive == false then
          imSelec:set_image(nil)
          print("OS HERÓIS PERDERAM")
          IMASELECTOR:set_image(4)
          love.event.wait(10)
          love.event.quit()
        end
        if monstersAlive == false then
          print("OS HERÓIS VENCERAM")
          _G.monsters = {}
          self:pop(params)
        end]]
        if _G.storeQuest then
            return self:pop(params)
        end

    end
end

return EncounterState
