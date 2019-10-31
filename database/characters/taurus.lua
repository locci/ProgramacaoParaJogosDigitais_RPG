
return {
  name = "Taurus Sign",
  appearance = 'taurus',
  max_hp = 200,
  hero = true,
  combat = {
    power = 25,
    resistance = 15,
    velocity = 8,
  },
  uncertainty = {
    hitChance = 80,
    hitCritical = 20,
  },
  skill={
    eagleEye = {
      hitChance =  5,
      consumo   = -1,
      target    =  1,
    },
    arrowrain = {
      hitChance =  2,
      consumo   = -2,
      target    =  3,
    }
  },
  item = {--item equipavel
    firearrow = {
      name = 'firearrow',
      power = 4,
      max   = 5,
      now   = 5,
    },
    icearrow = {
      name = 'icearrow',
      power = 2,
      max   = 10,
      now   = 5,
    },
    arrow = {
      name = 'arrow',
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
    money      =  0,

  },
}
