--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 09/11/2019
-- Time: 11:01
-- To change this template use File | Settings | File Templates.
--

local IMASELECTOR = {}

local scenarios = {
  ["Battle of Signs"] = {img = 1},
  ["Giant Attack"] = { img = 3 },
  ["Slime Infestation"] = { img = 1 },
  ["Store"] = { img = 2 },
  ["Game Over"] = { img = 4 }
}

function IMASELECTOR:set_image(name)

    if name then
      _G.contImg = scenarios[name].img
    end
    _G.storeQuest = (name == "Store")

    if (name  == 1) then
        _G.contImg = 1
    end

end

return IMASELECTOR
