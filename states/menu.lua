require 'data.functions'

menu = {}
function menu:init()
    --menumusic:play)
    username = userconf['username']
    love.graphics.setFont(zombie);
    love.graphics.setBackgroundColor(200,200,200)
    item1 = Button:new(true, true, 200, 340, strings['menu']['item1'], longbutton, longbutton_pressed, true, false, zombie)
    item2 = Button:new(true, true, 200, 260, strings['menu']['item2'], longbutton, longbutton_pressed, true, false, zombie)
    item3 = Button:new(true, true, 200, 210, strings['menu']['item3'], longbutton, longbutton_pressed, true, false, zombie)
    item4 = Button:new(true, true, 200, 175, strings['menu']['item4'], longbutton, longbutton_pressed, true, false, zombie)
    item5 = Button:new(true, true, 200, 150, strings['menu']['item5'], longbutton, longbutton_pressed, true, false, zombie)
    item6 = Button:new(true, true, 200, 130, strings['menu']['item6'], longbutton, longbutton_pressed, true, false, zombie)
end

function menu:update()
		-- check for mouse events

   	if item1:Click() then
        isjoining = true
   	    Gamestate.switch(ip)
	end
   	if item2:Click() then
        Gamestate.switch(host)
		end
    if item5:Click() then
        Gamestate.switch(optionsstate)
    end
   	if item6:Click() then
   		love.event.quit( )
    end

    item1:Hover()
    item2:Hover()
    item3:Hover()
    item4:Hover()
end

function menu:draw()
    love.graphics.setFont(sysfont);
    love.graphics.setColor(40,40,40, 255)
	love.graphics.print( "NAP Cards", 10, (height-50))
    love.graphics.print( "Pre-alpha 0101", 10, (height-30))
    love.graphics.print( "Welcome, " .. username .. ".", 10, 20)
    love.graphics.print( "Statistics:", 10, 80)
    love.graphics.print( "Wins: "..userconf['wins'], 10, 100)
    love.graphics.print( "Losses: "..userconf['losses'], 10, 120)
    love.graphics.print( "Legendary cards: "..tostring(tablelength(userconf['leggies'])), 10, 140)
    love.graphics.setFont(zombie)
    love.graphics.setColor(255,255,255, 255)
		-- draw graphics
    love.graphics.draw(item1.image, item1.x, item1.y)
    love.graphics.draw(item2.image, item2.x, item2.y)
    love.graphics.draw(item3.image, item3.x, item3.y)
    love.graphics.draw(item4.image, item4.x, item4.y)
    love.graphics.draw(item5.image, item5.x, item5.y)
    love.graphics.draw(item6.image, item6.x, item6.y)
    love.graphics.setColor(230,230,230, 255)
    love.graphics.print(item1.text, item1.text_x, item1.text_y)
    love.graphics.print(item2.text, item2.text_x, item2.text_y)
    love.graphics.print(item3.text, item3.text_x, item3.text_y)
    love.graphics.print(item4.text, item4.text_x, item4.text_y)
    love.graphics.print(item5.text, item5.text_x, item5.text_y)
    love.graphics.print(item6.text, item6.text_x, item6.text_y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end