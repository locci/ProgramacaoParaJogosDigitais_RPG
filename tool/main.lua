--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 18/10/2019
-- Time: 10:44
-- To change this template use File | Settings | File Templates.
--

local FRAME = require "frameView"
local quad = {}
local image
local frame
local index = 1

function love.load()

    local path = "kenney-1bit.png"
    image = love.graphics.newImage(path)
    quad = FRAME:getFrame(path)
    frame = quad[index]

end

function love.keypressed(key)

    if  index >= 1 and index < #quad then

        if key == "up" then

            frame = quad[index]
            index = index + 1

        end

        if key == "down" then

            frame = quad[index]
            index = index - 1

        end

    else

        if index == 0 then index = 1 end
        if index == 931 then index = 929 end


    end

end

function love.update(dt)

    love.keypressed()


end

function love.draw()

    love.graphics.push()
    love.graphics.scale(3, 3)
    love.graphics.draw(image, frame, 100, 100)
    love.graphics.print("id " .. index, 80, 80)
    love.graphics.pop()

end