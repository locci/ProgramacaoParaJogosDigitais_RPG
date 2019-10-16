
local Box = require 'common.class' ()

function Box:_init(left, right, top, bottom)
  self.left = left or 0
  self.right = right or 0
  self.top = top or 0
  self.bottom = bottom or 0
end

function Box:__tostring()
  return string.format("box: left=%.2f right=%.2f top=%.2f bottom=%.2f",
                       self:get())
end

function Box:get()
  return self.left, self.right, self.top, self.bottom
end

function Box:set(left, right, top, bottom)
  self.left = left or self.left
  self.right = right or self.right
  self.top = top or self.top
  self.bottom = bottom or self.bottom
end

function Box:get_width()
  return self.right - self.left
end

function Box:get_height()
  return self.bottom - self.top
end

function Box:get_dimensions()
  return self.right - self.left, self.bottom - self.top
end

function Box:get_rectangle()
  return self.left, self.top, self:get_dimensions()
end

function Box:__add(vec)
  return Box(self.left + vec.x, self.right + vec.x,
             self.top + vec.y, self.bottom + vec.y)
end

function Box:is_inside(point)
  return point.x >= self.left and point.x <= self.right and
         point.y >= self.top and point.y <= self.bottom
end

function Box:intersects(other)
  if self.left > other.right or
     self.right < other.left or
     self.top > other.bottom or
     self.bottom < other.top
  then
    return false
  else
    return true
  end
end

return Box

