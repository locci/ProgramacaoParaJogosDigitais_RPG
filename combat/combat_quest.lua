--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 25/10/2019
-- Time: 10:01
-- To change this template use File | Settings | File Templates.
--

local TESTSCREEN = {}

        function love.load()
            --splash = o_ten_one()
            --splash.onDone = function() print "DONE" end
        end

        function love.update(dt)
            --splash:update(dt)
        end

        function love.draw()
            love.graphics.print("Esta é uma splash screen.", 10, 200)
        end

        function love.keypressed()

        end

return TESTSCREEN


