require 'data.gamefunctions'

game = {}
function game:init()
    love.graphics.setFont(zombie);
    love.graphics.setBackgroundColor(200,200,200)
    files = love.filesystem.getDirectoryItems( "user/decks" )
    ypos = 100
    for k, file in ipairs(files) do
      content, pos, err = json.decode(love.filesystem.read('user/decks/' .. file), 1, err)
      _G['deck'..k] = Button:new(true, false, 200, ypos, content['name'], longbutton, longbutton_pressed, true, false, zombie)
      ypos = ypos + 60
    end
end

function game:update(dt)
  for k, file in ipairs(files) do
    content, pos, err = json.decode(love.filesystem.read('user/decks/' .. file), 1, err)
    if _G['deck'..k]:Click() then
      Gamestate.switch(play, k)
    end
  end
end

function game:draw()
    love.graphics.setColor(255, 255, 255, 255)
    for k, file in ipairs(files) do
      love.graphics.draw(_G['deck'..k].image, _G['deck'..k].x, _G['deck'..k].y)
    end
    love.graphics.setFont(sysfont);
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print( strings['deckselect']['instructions'], 10, 20)
    love.graphics.setFont(zombie);
    for k, file in ipairs(files) do
      love.graphics.print(_G['deck'..k].text, _G['deck'..k].text_x, _G['deck'..k].text_y)
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end

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

end

function play:draw()
    love.graphics.print("Your deck:", 10, 20)
    ypos = 40
    for index, value in ipairs(friendlyhand) do
      love.graphics.print(cards[value]['name'], 10, ypos)
      ypos = ypos + 20
    end
    love.graphics.print("Enemy deck:", 130, 20)
    ypos2 = 40
    for index, value in ipairs(enemyhand) do
      love.graphics.print(cards[value]['name'], 130, ypos2)
      ypos2 = ypos2 + 20
    end
    love.graphics.setFont(sysfont);
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print( deck, 10, 20)

end

math.randomseed( os.time() )
function shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end