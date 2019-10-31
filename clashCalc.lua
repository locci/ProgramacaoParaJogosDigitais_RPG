
local clashCalc = {}

function clashCalc:acerto()
  local rand = math.random(1, 100)
  if rand / 100 > .5 then
    return true
  end
  return false
end

function clashCalc:critical(unit)
  local rand = math.random(1, 100)

  if rand / 100 > unit:get_critical() then
    return true
  end
  return false
end

function clashCalc:attack()

end

return clashCalc
