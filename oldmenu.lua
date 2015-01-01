require 'classes'

function love.load()
		-- set resolution
		love.window.setMode( 1024, 576, {fullscreen=false} ) -- make this relative to the computer being played on
		width, height, flags = love.window.getMode( )
		-- set title
		love.window.setTitle( "NAP Cards" )
    -- Load the "cursor"
    cursor = love.graphics.newImage("resources/images/system/png/cursorGauntlet_grey.png")
    -- Hide the default mouse.
    love.mouse.setVisible(false)
    zombie = love.graphics.newFont( "resources/fonts/ZOMBIE.ttf", 25 )
    love.graphics.setFont(zombie);
    love.graphics.setBackgroundColor(200,200,200)

    longbutton = love.graphics.newImage("resources/images/system/png/buttonLong_grey.png")
    longbutton_pressed = love.graphics.newImage("resources/images/system/png/buttonLong_grey_pressed.png")
    item1 = Button:new(200, 300, "Join game", longbutton, longbutton_pressed, true, false, zombie)
    item2 = Button:new(200, 230, "Host game", longbutton, longbutton_pressed, true, false, zombie)
    item3 = Button:new(200, 185, "Options", longbutton, longbutton_pressed, true, false, zombie)
    item4 = Button:new(200, 150, "Exit", longbutton, longbutton_pressed, true, false, zombie)


end

function love.update(dt)
   	text = ""
   	text2 = ""

		-- check for mouse events

   	if item1:Click() then
   		text = "clicked 1"
		end
   	if item2:Click() then
   		text = "clicked 2"
		end
   	if item3:Click() then
   		text = "clicked 3"
		end
   	if item4:Click() then
   		love.event.quit( )
		end

		if item1:Hover() then
			text2 = "hover 1"
		end
		if item2:Hover() then
			text2 = "hover 2"
		end
		if item3:Hover() then
			text2 = "hover 3"
		end
		if item4:Hover() then
			text2 = "hover 4"
		end
end

function love.draw()
		love.graphics.print( text, 10, 20)
		love.graphics.print( text2, 10, 40)

		-- draw graphics
    love.graphics.draw(item1.image, item1.x, item1.y)
    love.graphics.draw(item2.image, item2.x, item2.y)
    love.graphics.draw(item3.image, item3.x, item3.y)
    love.graphics.draw(item4.image, item4.x, item4.y)
    love.graphics.setColor(40, 40, 40, 255)
    love.graphics.print(item1.text, item1.text_x, item1.text_y)
    love.graphics.print(item2.text, item2.text_x, item2.text_y)
    love.graphics.print(item3.text, item3.text_x, item3.text_y)
    love.graphics.print(item4.text, item4.text_x, item4.text_y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end