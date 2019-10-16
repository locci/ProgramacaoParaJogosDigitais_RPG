
local Character = require 'model.character'
local State = require 'state'

local FollowQuestState = require 'common.class' (State)

function FollowQuestState:_init(stack)
  self:super(stack)
  self.party = nil
  self.encounters = nil
  self.next_encounter = nil
end

function FollowQuestState:enter(params)
  local quest = params.quest
  self.encounters = quest.encounters
  self.next_encounter = 1
  self.party = {}
  for i, character_name in ipairs(quest.party) do
    local character_spec = require('database.characters.' .. character_name)
    self.party[i] = Character(character_spec)
  end
end

function FollowQuestState:update(_)
  if self.next_encounter <= #self.encounters then
    local encounter = {}
    local encounter_specnames = self.encounters[self.next_encounter]
    self.next_encounter = self.next_encounter + 1
    for i, character_name in ipairs(encounter_specnames) do
      local character_spec = require('database.characters.' .. character_name)
      encounter[i] = Character(character_spec)
    end
    local params = { party = self.party, encounter = encounter }
    return self:push('encounter', params)
  else
    return self:pop()
  end
end

return FollowQuestState


