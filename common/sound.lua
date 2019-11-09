-- luacheck: globals love
--
-- Created by IntelliJ IDEA.
-- User: alexandre
-- Date: 29/10/2019
-- Time: 19:03
-- To change this template use File | Settings | File Templates.
--

local SOUND = {}

 function SOUND.play(soundName)

     if soundName == 'fail' then
         local src1 = love.audio.newSource("assets/sound/fail.ogg", "static")
         src1:setVolume(0.9)
         src1:play()
     end
     if soundName == 'monster' then
         local src1 = love.audio.newSource("assets/sound/monster.ogg", "static")
         src1:setVolume(0.4)
         src1:setPitch(3)
         src1:play()
     end
     if soundName == 'coins' then
         local src1 = love.audio.newSource("assets/sound/coins.ogg", "static")
         src1:setVolume(0.4)
         src1:setPitch(3)
         src1:play()
     end
     if soundName == 'regmachine' then
         local src1 = love.audio.newSource("assets/sound/regmachine.ogg", "static")
         src1:setVolume(0.4) -- 90% of ordinary volume
         src1:setPitch(3) -- one octave lower
         src1:play()
     end

      if soundName == 'page' then
         local src1 = love.audio.newSource("assets/sound/turnepage.ogg", "static")
         src1:setVolume(0.4) -- 90% of ordinary volume
         src1:setPitch(3) -- one octave lower
         src1:play()
      end

     if soundName == 'updown' then
         local src1 = love.audio.newSource("assets/sound/updown.ogg", "static")
         src1:setVolume(0.4) -- 90% of ordinary volume
         src1:setPitch(3) -- one octave lower
         src1:play()
     end

 end

return SOUND

