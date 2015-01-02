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

  card = Card:new('S1', 'hand')
  card1 = Card:new('S2', 'hand')
  card2 = Card:new('S3', 'hand')
  -- enemy starting variables
  enemyhand = {}
  enemywealth = 0

  -- board starting variables
  friendlyboard = {}
  enemyboard = {}

  -- heads or tails
  cointoss = math.random(2)
  
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
  if card:hover() then
  end
  if card1:hover() then
  end
  if card2:hover() then
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
    ypos = 40
    --[[for index, value in ipairs(friendlyhand) do
      love.graphics.print(cards[value]['name'], 10, ypos)
      ypos = ypos + 20
    end]]
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(card.art, card.x, card.y, card.orient, 0.7, 0.7)
    love.graphics.draw(card1.art, card1.x, card1.y, card1.orient, 0.7, 0.7)
    love.graphics.draw(card2.art, card2.x, card2.y, card2.orient, 0.7, 0.7)
    love.graphics.setFont(sysfont)
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print( deck, 10, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end