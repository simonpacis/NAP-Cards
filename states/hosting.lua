require "lib.lube"
require 'data.functions'

hosting = {}
protocolServer = lube.tcpServer:subclass("protocolServer")
protocolServer._implemented = true
server = protocolServer()

function hosting:init()
	if ishosting == true then
		server.handshake = "quartermaster"
		server.callbacks.recv = onServerReceive
		server.callbacks.connect = onServerConnect
		server:setPing(true, 30, "pings")
		server:listen(45558)
		printit = "Awaiting connection..."
    hostingitem1 = Button:new(true, true, 200, 300, "Back", longbutton, longbutton_pressed, true, false, zombie)
	end
end

function hosting:update(dt)
	server:update(dt)
   	if hostingitem1:Click() then
      ishosting = false
      server:listen(46000)
   		Gamestate.switch(host)
		end
end

function onServerConnect(id)
	sendmsg('{"username":"'..username..'"}')
	Gamestate.push(game)
end

function onServerReceive(data, id)
  parse(data, "server")
end

function hosting:draw()
    love.graphics.setColor(40, 40, 40, 255)
		love.graphics.setFont(sysfont)
		love.graphics.print(tostring(printit), 10, 20)
    love.graphics.setFont(zombie);
    love.graphics.setColor(255, 255, 255, 255)
		-- draw graphics
    love.graphics.draw(hostingitem1.image, hostingitem1.x, hostingitem1.y)
    love.graphics.setColor(230, 230, 230, 255)
    love.graphics.print(hostingitem1.text, hostingitem1.text_x, hostingitem1.text_y)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end