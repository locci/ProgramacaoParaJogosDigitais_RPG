
local View = require 'common.class' ()

function View:_init()
  self.drawables = {}
end

function View:add(name, drawable)
  self.drawables[name] = drawable
end

function View:remove(name)
  self.drawables[name] = nil
end

function View:get(name)
  return self.drawables[name]
end

function View:update(dt)
  for _, drawable in pairs(self.drawables) do
    if drawable.update then
      drawable:update(dt)
    end
  end
end

function View:draw()
  for _, drawable in pairs(self.drawables) do
    drawable:draw()
  end
end

return View

