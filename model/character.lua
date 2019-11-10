--ignore 212/self
local Character = require 'common.class' ()

function Character:_init(spec)
  self.spec = spec
  self.hp = spec.max_hp
  self.index = Character:create_index()
end

function Character:create_index()
  _G.lastCharIndex = _G.lastCharIndex + 1
  --print("index=", _G.lastCharIndex)
  return _G.lastCharIndex
end

function Character:get_index()
  print("index de", self.spec.name, "e'", self.index)
  return self.index
end

function Character:get_name()
  return self.spec.name
end

function Character:get_appearance()
  return self.spec.appearance
end

function Character:get_side()
  return self.spec.hero
end

function Character:get_hp()
  return self.hp, self.spec.max_hp
end

function Character:set_hp(gain)
    self.hp = self.hp + gain
    self.spec.max_hp = self.spec.max_hp + gain
end

function Character:get_item()
  return self.spec.item
end

function Character:get_power()
  return self.spec.combat['power']
end

function Character:get_resistance()
  return self.spec.combat['resistance']
end

function Character:set_power(gain)
    self.spec.combat['power'] = self.spec.combat['power'] + gain
end

function Character:set_resistance(gain)
    self.spec.combat['resistance'] = self.spec.combat['resistance'] + gain
end

function Character:get_velocity()
  return self.spec.combat['velocity']
end

function Character:set_velocity(gain)
    self.spec.combat['velocity'] = self.spec.combat['velocity'] + gain
end

function Character:get_money()
  return self.spec.px['money']
end


function Character:set_money(price)
   self.spec.px['money'] = self.spec.px['money'] - price
end

function Character:get_price()
  return self.spec.price
end

function Character:get_gain()
    return self.spec.gain
end

function Character:get_uncertainty()
    local uncert = self.spec.uncertainty
    return uncert.hitChance, uncert.hitCritical
end

function Character:get_skills()
  return self.spec.skill
end


function Character:hit(power)
    self.hp = math.max(0, self.hp - power)
end

return Character
