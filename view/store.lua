--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 28/10/2019
-- Time: 17:11
-- To change this template use File | Settings | File Templates.
--
local suit    = require 'suit-master'


local input = {text = ""} -- text input data

function love.update(dt)
    suit.layout:reset(100,100)
    suit.Input(input, suit.layout:row(200,30))
    suit.Label("Hello, "..input.text, {align = "left"}, suit.layout:row())
    suit.layout:row() -- padding of one cell
    if suit.Button("Close", suit.layout:row()).hit then
        --love.event.quit()
    end
end

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end

function love.draw()
    suit.draw()
end

return suit

