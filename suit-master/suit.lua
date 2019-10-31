--source https://github.com/vrld/SUIT

local SUIT = {}

local suit = require 'suit-master' -- suit up

local input = {text = ""} -- text input data

-- the entire UI is defined inside love.update(dt) (or functions that are called from love.update)
function love.update(dt)
    suit.layout:reset(100,100)

    suit.Input(input, suit.layout:row(200,30))
    suit.Label("Hello, "..input.text, {align = "left"}, suit.layout:row())

    suit.layout:row() -- padding of one cell
    if suit.Button("Close", suit.layout:row()).hit then
        love.event.quit()
    end
end

function love.draw()
    suit.draw()
end

function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)       
    suit.keypressed(key)
end

return SUIT
