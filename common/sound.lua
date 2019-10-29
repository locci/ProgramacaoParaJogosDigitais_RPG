--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 29/10/2019
-- Time: 19:03
-- To change this template use File | Settings | File Templates.
--

local SOUND = {}

 function SOUND:play(soundName)

     if soundName == 'sword' then
         local src1 = love.audio.newSource("assets/sound/sword.wav", "static")
         src1:setVolume(0.9) -- 90% of ordinary volume
         src1:setPitch(0.5) -- one octave lower
         src1:play()
     end

     if soundName == 'monster' then
         local src1 = love.audio.newSource("assets/sound/monster.wav", "static")
         src1:setVolume(0.4) -- 90% of ordinary volume
         src1:setPitch(0.9) -- one octave lower
         src1:play()
     end

 end


return SOUND

