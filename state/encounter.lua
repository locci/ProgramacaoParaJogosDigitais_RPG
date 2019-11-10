-- luacheck: globals love

local Vec = require 'common.vec'
local MessageBox = require 'view.message_box'
local SpriteAtlas = require 'view.sprite_atlas'
local BattleField = require 'view.battlefield'
local State = require 'state'
local Clash = require 'clashCalc'
local imSelec = require 'view.imageSelector'
local Sound = require 'common.sound'

_G.hero   = {}
_G.noHero = {}

local EncounterState = require 'common.class' (State)

local CHARACTER_GAP = 96


local battlefield = BattleField()
local bfbox = battlefield.bounds
local message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))

function EncounterState:_init(stack)
    self:super(stack)
    self.turns = nil
    self.next_turn = nil
end

function EncounterState:enter(params)
    local atlas = SpriteAtlas()
    battlefield = BattleField()
    bfbox = battlefield.bounds
    message = MessageBox(Vec(bfbox.left, bfbox.bottom + 16))
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

    if _G.select == "monster" then
        while (currentChar:get_side() or currentChar:get_hp() <= 0)
              and _G.storeQuest == false do
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

_G.fightState = true

function EncounterState:resume(params)

    if params.action ~= 'Run' then
        if params.action == 'Fight' then
            _G.fightState = true
        else
            _G.fightState = false
        end

    else
        local tab
        if _G.storeQuest  then _G.contImg = 1 end
        local str = ""


        for _, j in ipairs(_G.combat) do

            tab = j
            local char1 = tab[1]
            local char2 = tab[2]

            if Clash.acerto(char1:get_uncertainty()) and
                    char1:get_hp() > 0 and char2:get_hp() > 0 then
                local pow = char1:get_power()
                local item = char1:get_item().power
                local skill = char1:get_skill().hitChance
                local damage = pow + item + skill
                char2:hit(damage)
                str = str .. "Hit " .. char2:get_name() .. " New HP " .. char2:get_hp() .. "\n"
            end
            if Clash.acerto(char2:get_uncertainty()) and
                    char1:get_hp() > 0 and char2:get_hp() > 0 then
                local pow = char2:get_power()
                local item = char2:get_item().power
                local skill = char2:get_skill().hitChance
                local damage = pow + item + skill
                char1:hit(damage)
                str = str .. "Hit " .. char1:get_name() .. " New HP " .. char1:get_hp() .. "\n"
            end

            _G.heros[char1:get_index()] = char1
            _G.monsters[char2:get_index()] = char2

            love.timer.sleep(1)
        end

        self:view():add('message', message)
        message:set(str)
        --local victory =  _G.combat

        _G.combat = {}
        _G.heroSelect = {}


        local numOfMonsters = 0
        local numOfHeros = 0

        for _, _ in pairs(_G.heros) do
            numOfHeros = numOfHeros + 1
        end

        for _, _ in pairs(_G.monsters) do
            numOfMonsters = numOfMonsters + 1
        end

        _G.whichEncounter = _G.whichEncounter + 1
        local herosAlive, monstersAlive = true, true

        if _G.numberOfHeros == numOfHeros then
            local dead = 0
            for _, hero in pairs(_G.heros) do
                local hp = hero:get_hp()
                if  hp <= 0 then
                    dead = dead + 1
                end
            end
            if dead == numOfHeros then
                herosAlive = false
            end
        end

        if _G.numberOfMonsters == numOfMonsters then
            local dead = 0
            for _, monster in pairs(_G.monsters) do
                local hp = monster:get_hp()
                if  hp <= 0 then
                    dead = dead + 1
                end
            end
            if dead == numOfMonsters then
                monstersAlive = false
            end
        end

        if herosAlive == false then
            str = "HEROES LOST - press esc"
            self:view():add('message', message)
            message:set(str)
            imSelec.set_image("Store")
            _G.gameOver = true
        end

        if monstersAlive == false then
            Sound.play('victory')
            imSelec.set_image("Default")
            _G.monsters = {}
            self:pop(params)
        end

        if _G.storeQuest then
            return self:pop(params)
        end

    end
end

return EncounterState
