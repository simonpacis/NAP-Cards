play = {}
function play:init()
  deck = ""
end

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

  -- heads or tails
  cointoss = math.random(2)
  draw(3)
  -- draw initial cards
  --[[if cointoss == 1 then -- friendly starts
    draw(3)
    draw(4, false, true)
    givecard("S33", false, true)
  else -- enemy starts
    draw(3, false, true)
    draw(4)
    givecard("S33")
  end
end]]
end

function play:update(dt)
  flux.update(dt)
  Timer.update(dt)
  for k, v in ipairs(friendlyhand) do
    v:check()
  end
  if ishosting then
    server:update(dt)
  else
    client:update(dt)
  end
end

function play:draw()

    --if message ~= nil then
    --  love.graphics.print(message, 10, 20)
    --end
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
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end