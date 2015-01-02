require 'lib.middleclass'
require 'lib.middleclass-commons'
require "lib.lube"
hosting = {}
protocolServer = lube.tcpServer:subclass("protocolServer")
protocolServer._implemented = true
-- define protocolserver
server = protocolServer()

function hosting:init()
	if ishosting == true then
		server.callbacks.recv = onReceive
		server.callbacks.connect = onConnect
		server:setPing(true, 30, "Pingeling")
		server.port = 45558
		server:listen(45558)
		data = "Awaiting connection..."
	end
end

function hosting:update(dt)
	server:update(dt)
	server:send("Hi")
end

function onReceive(data, clientid)
		data, clientid = server:receive()
		data = "Connected."
end

function onConnect(clientid)
	data = "Connected."
end

function hosting:draw()
		love.graphics.setFont(sysfont)
		love.graphics.print(tostring(data), 10, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end