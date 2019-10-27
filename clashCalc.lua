
local clashCalc = {}

function clashCalc:acerto(hit)
  print("depois", hit)
  local rand = math.random(1, 100)
  if rand / 100 > hit then
    return true
  end
  return false
end

function clashCalc:critical()
  local rand = math.random(1, 100)

  if rand / 100 > unit:get_critical() then
    return true
  end
  return false
end

function clashCalc:attack()

end

return clashCalc
