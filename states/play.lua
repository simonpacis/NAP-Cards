require 'data.gamefunctions'
play = {}

function play:enter(previous, selecteddeck)
  cardwidth = 252
  cardheight = 181
  -- friendly starting variables
  friendlydeck = json.decode(love.filesystem.read('user/decks/'.. tostring(selecteddeck) .. '.json'), 1, err)
  friendlydeck = shuffle(friendlydeck['cards'])
  friendlyhand = {}

  friendlywealth = 0

  -- enemy starting variables
  enemyhand = {}
  enemywealth = 0

  -- board starting variables
  friendlyboard = {}
  enemyboard = {}

  -- draw initial cards
    if ishosting then
    math.randomseed( os.time() )
    cointoss = math.random(2)
    if cointoss == 1 then
      sendcmd("draw(4)|givecard(M010)|playsound(diceroll)|playsound(enemybegins)|setvar(yourround, false)")
      playsound("diceroll")
      playsound("youbegin")
      draw(3)
      yourround = true
    else
      sendcmd("draw(3)|playsound(diceroll)|playsound(youbegin)|setvar(yourround, true)")
      playsound("diceroll")
      playsound("enemybegins")
      draw(4)
      givecard('M010')
      yourround = false
    end
  end
end

function play:update(dt)
  if ishosting then
    server:update(dt)
  end
  if isjoining then
    client:update(dt)
  end
  flux.update(dt)
  Timer.update(dt)
  for k, v in ipairs(friendlyhand) do
    v:check()
  end
  TEsound.cleanup()
end


function onClientReceive(data, id)
  parse(data, "client")
end

function onServerReceive(data, id)
  if ishosting then
    parse(data, "server")
  end
end


function play:draw()
    for k, v in ipairs(enemyhand) do
      if v.z == 0 then
        v:draw()
      end
    end  
    for k, v in ipairs(enemyhand) do
      if v.z == 1 then
        if v.upsize == true then
          v:draw(true)
          --love.graphics.draw( v.art, v.x, v.y, v.orient, v.scale, v.scale, v.art:getWidth()/4, v.art:getHeight()/1.3)
        else
          v:draw()
        end
      end
    end 
    for k, v in ipairs(friendlyhand) do
      if v.z == 0 then
        v:draw()
      end
    end  
    for k, v in ipairs(friendlyhand) do
      if v.z == 1 then
        if v.upsize == true then
          v:draw(true)
          --love.graphics.draw( v.art, v.x, v.y, v.orient, v.scale, v.scale, v.art:getWidth()/4, v.art:getHeight()/1.3)
        else
          v:draw()
        end
      end
    end 
    love.graphics.setFont(sysfont)
    love.graphics.setColor(40, 40, 40, 255)
    if _G['message'] ~= nil then
      local localwidth = width - (sysfont:getWidth(message) + 10)
      love.graphics.print(_G['message'], localwidth, 20)
    else
      love.graphics.print("no message", 10, 20)
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end