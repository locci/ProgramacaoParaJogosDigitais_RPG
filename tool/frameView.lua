--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 18/10/2019
-- Time: 10:44
-- To change this template use File | Settings | File Templates.
--

-- luacheck: globals love

local FRAME = {}

function FRAME:getFrame(path)

    local animation = {}

    local file = io.open(path , "r")
    local contents = file:read("*all")
    local data = love.filesystem.newFileData( contents, "img.png", "file" )
    animation.spriteSheet = love.graphics.newImage(data)
    file:close()

    local width  = 17
    local height = 17
    local quad = {}

    for y = 0, animation.spriteSheet:getHeight() , height do
        for x = 0, animation.spriteSheet:getWidth() , width do
            table.insert(quad, love.graphics.newQuad(x, y, width, height,
                animation.spriteSheet:getDimensions()))
        end
    end

    return quad

end

return FRAME
