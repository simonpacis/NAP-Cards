require 'data.functions'

menu = {}
function menu:init()
    usernames = { "Almarkinda", "Ilmadun", "Munotes", "Miangoré", "Vayne", "Baron", "Professor", "Firelord" }
    username = usernames[math.random(tablelength(usernames))]
    love.graphics.setFont(zombie);
    love.graphics.setBackgroundColor(200,200,200)
    item1 = Button:new(true, true, 200, 300, strings['menu']['item1'], longbutton, longbutton_pressed, true, false, zombie)
    item2 = Button:new(true, true, 200, 230, strings['menu']['item2'], longbutton, longbutton_pressed, true, false, zombie)
    item3 = Button:new(true, true, 200, 185, strings['menu']['item3'], longbutton, longbutton_pressed, true, false, zombie)
    item4 = Button:new(true, true, 200, 150, strings['menu']['item4'], longbutton, longbutton_pressed, true, false, zombie)
end

function menu:update()
		-- check for mouse events

   	if item1:Click() then
      isjoining = true
   		Gamestate.switch(join)
		end
   	if item2:Click() then
      Gamestate.switch(host)
		end
   	if item4:Click() then
   		love.event.quit( )
    end
end

function menu:draw()
    love.graphics.setFont(sysfont);
    love.graphics.setColor(40,40,40, 255)
		love.graphics.print( "NAP Cards", 10, 20)
    love.graphics.print( "dev prealpha 0000", 10, 40)
    love.graphics.print( "Your username is: " .. username, 10, 60)
    love.graphics.setFont(zombie)
    love.graphics.setColor(255,255,255, 255)
		-- draw graphics
    love.graphics.draw(item1.image, item1.x, item1.y)
    love.graphics.draw(item2.image, item2.x, item2.y)
    love.graphics.draw(item3.image, item3.x, item3.y)
    love.graphics.draw(item4.image, item4.x, item4.y)
    love.graphics.setColor(230,230,230, 255)
    love.graphics.print(item1.text, item1.text_x, item1.text_y)
    love.graphics.print(item2.text, item2.text_x, item2.text_y)
    love.graphics.print(item3.text, item3.text_x, item3.text_y)
    love.graphics.print(item4.text, item4.text_x, item4.text_y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end