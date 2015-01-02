require 'data.gamefunctions'
selected = false

game = {}
function game:init()
    sendmsg("In")
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
    if message ~= nil then
      love.graphics.print(message, 10, 20)
    end
    love.graphics.setColor(255, 255, 255, 255)
    for k, file in ipairs(files) do
      love.graphics.draw(_G['deck'..k].image, _G['deck'..k].x, _G['deck'..k].y)
    end
    love.graphics.setColor(230, 230, 230, 255)
    love.graphics.setFont(zombie);
    for k, file in ipairs(files) do
      love.graphics.print(_G['deck'..k].text, _G['deck'..k].text_x, _G['deck'..k].text_y)
    end
    love.graphics.setFont(sysfont);
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print( strings['deckselect']['instructions'], 10, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end