--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 10/11/2019
-- Time: 13:01
-- To change this template use File | Settings | File Templates.
--

local ENVIROMENT = {}

function ENVIROMENT.calcEnvEf(envi, char)


    if envi == 'neve' and char:get_environment() == 'neve' then
        char:set_resistance(-1)
        return "It is cold! So " .. char:get_name() .. " lost 1 resistency point."
    end

    if envi == 'cave' and char:get_environment() == 'cave' then
        char:set_velocity(-1)
        return "It is a cave! It is very dark! \nSo " .. char:get_name() .. " lost 1 speed point."
    end

    return " "

end

return ENVIROMENT
