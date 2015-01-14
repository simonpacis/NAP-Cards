require "lib.lube"
require 'data.functions'

protocolServer = lube.tcpServer:subclass("protocolServer")
protocolServer._implemented = true
server = protocolServer()

hosting = {}

function hosting:init()
	if ishosting == true then
		server.handshake = "quartermaster"
		server.callbacks.recv = onServerReceive
		server.callbacks.connect = onServerConnect
		server:setPing(true, 30, "pings")
		server:listen(45558)
		printit = "Awaiting connection... You can not return to main menu. Please shut down game and open again to do so."
	end
end

function hosting:update(dt)
	server:update(dt)
end

function onServerConnect(id)
	sendmsg('{"username":"'..username..'"}')
	Gamestate.switch(game)
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
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end