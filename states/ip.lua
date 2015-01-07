ip = {}

function ip:init()
	joinip = ""
	ipitem1 = Button:new(true, true, 200, 300, "Connect", longbutton, longbutton_pressed, true, false, zombie)
	ipitem2 = Button:new(true, true, 200, 230, "Back", longbutton, longbutton_pressed, true, false, zombie)
	allowedkeys = {}
	allowedkeys["0"] = true
	allowedkeys["1"] = true
	allowedkeys["2"] = true
	allowedkeys["3"] = true
	allowedkeys["4"] = true
	allowedkeys["5"] = true
	allowedkeys["6"] = true
	allowedkeys["7"] = true
	allowedkeys["8"] = true
	allowedkeys["9"] = true
	allowedkeys["."] = true
end

function ip:keyreleased(key)
	if allowedkeys[key] then
		joinip = joinip .. key
	end
	if key == "backspace" then
		joinip = string.sub(joinip, 1, -2)
	end
	if key == "return" then
   	Gamestate.switch(join, joinip)
	end
end

function ip:update(dt)
  if ipitem1:Click() then
   	Gamestate.switch(join, joinip)
	end
  if ipitem2:Click() then
   	Gamestate.switch(menu)
	end
end

function ip:draw()
    love.graphics.draw(ipitem1.image, ipitem1.x, ipitem1.y)
    love.graphics.draw(ipitem2.image, ipitem2.x, ipitem2.y)
    love.graphics.setColor(230,230,230, 255)
		love.graphics.setFont(zombie)
    love.graphics.print(ipitem1.text, ipitem1.text_x, ipitem1.text_y)
    love.graphics.print(ipitem2.text, ipitem2.text_x, ipitem2.text_y)
		love.graphics.setFont(sysfont)
		love.graphics.setColor(40,40,40,255)
    love.graphics.print("Please enter the IP of the server you want to join.", (width/2) - longbutton:getWidth() / 2 - 70 , 80) 
    love.graphics.print("IP: " .. tostring(joinip), (width/2) - longbutton:getWidth() / 2 , 100) 
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end