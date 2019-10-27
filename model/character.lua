
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

function Character:get_critical()
  return self.critical
end

function Character:get_hit()
  return self.hit
end

function Character:get_damage()
  return self.damage
end

return Character
