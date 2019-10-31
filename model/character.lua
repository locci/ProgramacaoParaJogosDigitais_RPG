
local Character = require 'common.class' ()

function Character:_init(spec)
  self.spec = spec
  self.hp = spec.max_hp
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

function Character:get_item()
  return self.item
end

function Character:get_power()
  return self.spec.combat['power']
end

function Character:get_resistance()
  return self.spec.combat['resistance']
end

function Character:get_velocity()
  return self.spec.combat['velocity']
end

function Character:get_money()
  return self.spec.px['money']
end

function Character:get_damage()
  return self.damage
end

return Character
