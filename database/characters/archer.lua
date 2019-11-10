
return {
  name = "Recluse Archer",
  appearance = 'archer',
  max_hp = 12,
  hero=true,
  combat = {
    power = 9,
    resistance = 15,
    velocity = 10,
  },
  uncertainty = {
    hitChance = 80,
    hitCritical = 20,
  },
  skill={
    ["Eagle Eye"] = {
      name = "Eagle Eye",
      hitChance =  5,
      consumo   = -1,
      target    =  1,
    },
    ["Arrow Rain"] = {
      name = "Arrow Rain",
      hitChance =  2,
      consumo   = -2,
      target    =  3,
    }
  },
  item = {--item equipavel
    ["Fire Arrow"] = {
      name = 'Fire Arrow',
      power = 4,
      max   = 5,
      now   = 5,
    },
    ["Ice Arrow"] = {
      name = 'Ice Arrow',
      power = 2,
      max   = 10,
      now   = 5,
    },
    ["Arrow"] = {
      name = 'Arrow',
      power = 1,
      max   = 20,
      now   = 20,
    },
  },
  cx = {--implementar



  },
  lx = {
    cave = false,
    darkness = false, --paralisa
  },
  rx = {
    dark = -2 --hitchance
  },
  px = { --progrssao
    experience =  0,
    level      = 20,
    money      =  5,
  },
}
