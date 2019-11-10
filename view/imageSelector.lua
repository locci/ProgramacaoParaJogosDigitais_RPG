--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 09/11/2019
-- Time: 11:01
-- To change this template use File | Settings | File Templates.
--

local IMASELECTOR = {}

function IMASELECTOR:set_iamge(name)

    if (name  == 'Store') then
        _G.contImg = 2
        _G.storeQuest = true
    else
        _G.storeQuest = false
    end

    if (name  == 'Giant Attack') then
        _G.contImg = 3
    end

    if (name  == 1) then
        _G.contImg = 1
    end

end

return IMASELECTOR

