--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 04/11/2019
-- Time: 10:56
-- To change this template use File | Settings | File Templates.
--

local STORE = {}

local Sound = require 'common.sound'

function STORE:select_buyer(character, merchandise, checkTable, message, view)

    if character:get_side() and merchandise[1] == nil and _G.storeQuest and
            checkTable then
        Sound:play('coins')
        table.insert(_G.heroSelect, character)
        local str = "You select The " .. character:get_name() .. "... good  shop!!"
        message:set(str)
        return character
    end

end

function STORE:select_item(character, merchandise, message, view)

    if character:get_side() == false and merchandise[1] ~= nil and merchandise[2] == nil then
        local operation = merchandise[1]:get_money() - character:get_price()
        if operation >= 0  then
            Sound:play('regmachine')  table.insert(merchandise, character)
            message:set("You buy: " .. merchandise[2]:get_name())
            character = merchandise[1]
            if merchandise[2]:get_appearance() == 'unguentoPW' then
                character:set_power(merchandise[2]:get_gain())
            elseif merchandise[2]:get_appearance() == 'unguentoRE' then
                character:set_resistance(merchandise[2]:get_gain())
            else
                character:set_velocity(merchandise[2]:get_gain())
            end
            character:set_money(character:get_price())
            local gain = merchandise[2]   merchandise = {}
            return character, merchandise
        else
            Sound:play('regmachine')  table.insert(merchandise, character)
            message:set("You dont have money!!!")
        end
    end

end


return STORE
