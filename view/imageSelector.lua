--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 09/11/2019
-- Time: 11:01
-- To change this template use File | Settings | File Templates.
--

local IMASELECTOR = {}

local scene = {
  ["Default"] = { img = 1 },
  ["Battle of Signs"] = { img = 1 },
  ["Giant Attack"] = { img = 3 },
  ["Slime Infestation"] = { img = 1 },
  ["Store"] = { img = 2 },
  ["Game Over"] = { img = 4 }
}

function IMASELECTOR.set_image(name)

    if name then
      if scene[name] then
        _G.contImg = scene[name].img
      else
        _G.contImg = scene["Default"].img
      end
    end
    _G.storeQuest = (name == "Store")

    if (name  == 1) then
        _G.contImg = 1
    end

end

return IMASELECTOR
