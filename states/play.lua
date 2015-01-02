play = {}
function play:init()
  deck = ""
end

function play:enter(previous, selecteddeck)
  cards = json.decode(love.filesystem.read('resources/data/cards'), 1, err)

  -- friendly starting variables
  friendlydeck = json.decode(love.filesystem.read('user/decks/'.. tostring(selecteddeck) .. '.json'), 1, err)
  friendlydeck = shuffle(friendlydeck['cards'])
  friendlyhand = {}
  friendlywealth = 0

  -- enemy starting variables
  enemydeck = json.decode(love.filesystem.read('user/decks/2.json'), 1, err)
  enemydeck = shuffle(enemydeck['cards'])
  enemyhand = {}
  enemywealth = 0

  -- board starting variables
  friendlyboard = {}
  enemyboard = {}

  -- heads or tails
  cointoss = math.random(2)
  
  -- draw initial cards
  if cointoss == 1 then -- friendly starts
    draw(3)
    draw(4, false, true)
    givecard("S33", false, true)
  else -- enemy starts
    draw(3, false, true)
    draw(4)
    givecard("S33")
  end
end

function play:update(dt)
  if ishosting then
    server:update(dt)
  else
    client:update(dt)
  end
end

function play:draw()
    if message ~= nil then
    love.graphics.print(message, 10, 20)
    end
    ypos = 40
    for index, value in ipairs(friendlyhand) do
      love.graphics.print(cards[value]['name'], 10, ypos)
      ypos = ypos + 20
    end
    love.graphics.print("Enemy deck:", 160, 20)
    ypos2 = 40
    for index, value in ipairs(enemyhand) do
      love.graphics.print(cards[value]['name'], 160, ypos2)
      ypos2 = ypos2 + 20
    end
    love.graphics.setFont(sysfont);
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print( deck, 10, 20)

end