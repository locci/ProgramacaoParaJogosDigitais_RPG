
local Stack = require 'common.class' ()

function Stack:_init(game)
  self.top = 0
  self.states = {}
  self.registered = {}
  self.game = game
end

function Stack:update(dt)
  self:dispatch_call('update', dt)
  if not self:get_current_state() then
    love.event.push 'quit'
  end
end

function Stack:draw()
  return self:dispatch_call('draw')
end

function Stack:forward(eventname, ...)
  return self:dispatch_call('call_handler', eventname, ...)
end

function Stack:push(statename, info)
  self:dispatch_call('suspend')
  self.top = self.top + 1
  self.states[self.top] = statename
  self:dispatch_call('enter', info)
end

function Stack:pop(info)
  self:dispatch_call('leave')
  self.states[self.top] = false
  self.top = self.top - 1
  self:dispatch_call('resume', info)
end

function Stack:dispatch_call(method_name, ...)
  local current_state = self:get_current_state()
  if current_state then
    local method = current_state[method_name]
    if method then
      method(current_state, ...)
    end
  end
end

function Stack:get_current_state()
  return self:get_state(self.states[self.top])
end

function Stack:get_state(name)
  if name then
    local state = self.registered[name] if not state then
      state = require('state.' .. name) (self)
      self.registered[name] = state
    end
    return state
  end
end

return Stack

