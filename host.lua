host = {}
function host:init()
    love.graphics.setFont(zombie);
    love.graphics.setBackgroundColor(200,200,200)
    longbutton = love.graphics.newImage("resources/images/system/png/buttonLong_grey.png")
    longbutton_pressed = love.graphics.newImage("resources/images/system/png/buttonLong_grey_pressed.png")
    hostitem1 = Button:new(200, 300, "host game", longbutton, longbutton_pressed, true, false, zombie)
    hostitem2 = Button:new(200, 230, "Back", longbutton, longbutton_pressed, true, false, zombie)
end

function host:update()
   	text = ""
   	text2 = ""

		-- check for mouse events

   	if hostitem1:Click() then
   		text = "clicked 1"
		end
   	if hostitem2:Click() then
      Gamestate.switch(menu)
		end

		if hostitem1:Hover() then
			text2 = "hover 1"
		end
		if hostitem2:Hover() then
			text2 = "hover 2"
		end
end

function host:draw()
		love.graphics.print( text, 10, 20)
		love.graphics.print( text2, 10, 40)

		-- draw graphics
    love.graphics.draw(hostitem1.image, hostitem1.x, hostitem1.y)
    love.graphics.draw(hostitem2.image, hostitem2.x, hostitem2.y)
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print(hostitem1.text, hostitem1.text_x, hostitem1.text_y)
    love.graphics.print(hostitem2.text, hostitem2.text_x, hostitem2.text_y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end