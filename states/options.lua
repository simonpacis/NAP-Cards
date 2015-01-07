optionsstate = {}

function optionsstate:init()
	optionsaved = ""
	tempusername = username
	optionsallowedkeys = {}
	optionsallowedkeys["a"] = true
	optionsallowedkeys["b"] = true
	optionsallowedkeys["c"] = true
	optionsallowedkeys["d"] = true
	optionsallowedkeys["e"] = true
	optionsallowedkeys["f"] = true
	optionsallowedkeys["g"] = true
	optionsallowedkeys["h"] = true
	optionsallowedkeys["i"] = true
	optionsallowedkeys["j"] = true
	optionsallowedkeys["k"] = true
	optionsallowedkeys["l"] = true
	optionsallowedkeys["m"] = true
	optionsallowedkeys["n"] = true
	optionsallowedkeys["o"] = true
	optionsallowedkeys["p"] = true
	optionsallowedkeys["q"] = true
	optionsallowedkeys["r"] = true
	optionsallowedkeys["s"] = true
	optionsallowedkeys["t"] = true
	optionsallowedkeys["u"] = true
	optionsallowedkeys["v"] = true
	optionsallowedkeys["w"] = true
	optionsallowedkeys["x"] = true
	optionsallowedkeys["y"] = true
	optionsallowedkeys["z"] = true
	optionsallowedkeys["'"] = true
	optitem1 = Button:new(true, true, 200, 300, "Fullscreen?", longbutton, longbutton_pressed, true, false, zombie)
	optitem2 = Button:new(true, true, 200, 230, "Res down", longbutton, longbutton_pressed, true, false, zombie)
	optitem3 = Button:new(true, true, 200, 185, "Res to org", longbutton, longbutton_pressed, true, false, zombie)
	optitem4 = Button:new(true, true, 200, 155, "Save", longbutton, longbutton_pressed, true, false, zombie)
	optitem5 = Button:new(true, true, 200, 130, "Back", longbutton, longbutton_pressed, true, false, zombie)
end

function optionsstate:keyreleased(key)
	if optionsallowedkeys[key] and string.len(tempusername) < 16 then
		if love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift") then
			key = string.upper(key)
		end
		tempusername = tempusername .. key
	end
	if key == "backspace" then
		tempusername = string.sub(tempusername, 1, -2)
	end
	if key == "return" then
   	saveoptions()
	end
end

function saveoptions()
	username = tempusername
	userconf['username'] = tempusername
	jsonuserconf = json.encode(userconf)
	writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
	savememoir()
	optionsaved = "Information saved."
end

function optionsstate:update(dt)
	if optitem1:Click() then
		if userfullscreen == true then
			love.window.setFullscreen( false )
			userconf['fullscreen'] = "false"
			userfullscreen = false
		else
			love.window.setFullscreen( true )
			userconf['fullscreen'] = "true"
			userfullscreen = true
		end
	jsonuserconf = json.encode(userconf)
	writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
	savememoir()
	end
	if optitem2:Click() then
    if selectedres >= 3 then
			userconf['resw'] = resolutions[selectedres-2][1]
	    userconf['resh'] = resolutions[selectedres-2][2]
    	selectedres = selectedres - 1
    elseif selectedres == 2 then
			userconf['resw'] = resolutions[1][1]
	    userconf['resh'] = resolutions[1][2]
    	selectedres = 1
	  end

			jsonuserconf = json.encode(userconf)
			writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
			savememoir()
			optionsaved = "Please restart to apply new resolution."
	end
	if optitem3:Click() then
		selectedres = 1
		orgres = 1
    for k, v in pairs(resolutions) do -- iterate the available resolutions
        if v[1] >= userwidth then -- if userwidth is below or equal to given resolution
        	if v[2] >= userheight then -- if userheight is below or equal to given resolution
            reswidth = userwidth -- set resolution to be this
            resheight = userheight
            selectedres = selectedres + 1
            orgres = orgres + 1
          end
        end
    end
        userconf['resw'] = reswidth
      	userconf['resh'] = resheight
        jsonuserconf = json.encode(userconf)
        writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
        savememoir()
		optionsaved = "Please restart to apply new resolution."
	end
	if optitem4:Click() then
		saveoptions()
	end
	if optitem5:Click() then
		Gamestate.switch(menu)
	end
end

function optionsstate:draw()
    love.graphics.draw(optitem1.image, optitem1.x, optitem1.y)
    love.graphics.draw(optitem2.image, optitem2.x, optitem2.y)
    love.graphics.draw(optitem3.image, optitem3.x, optitem3.y)
    love.graphics.draw(optitem4.image, optitem4.x, optitem4.y)
    love.graphics.draw(optitem4.image, optitem5.x, optitem5.y)

    love.graphics.setColor(230,230,230, 255)
		love.graphics.setFont(zombie)
    love.graphics.print(optitem1.text, optitem1.text_x, optitem1.text_y)
    love.graphics.print(optitem2.text, optitem2.text_x, optitem2.text_y)
    love.graphics.print(optitem3.text, optitem3.text_x, optitem3.text_y)
    love.graphics.print(optitem4.text, optitem4.text_x, optitem4.text_y)
    love.graphics.print(optitem5.text, optitem5.text_x, optitem5.text_y)
		love.graphics.setColor(40,40,40,255)
		love.graphics.setFont(sysfont)
    love.graphics.print(tostring(optionsaved), (width/2) - longbutton:getWidth() / 2 , (height/2) - 210)
    love.graphics.print("Username: " .. tostring(tempusername), (width/2) - longbutton:getWidth() / 2 , (height/2) - 190)
    love.graphics.print("Type to change username.", (width/2) - longbutton:getWidth() / 2 , (height/2) - 170)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end