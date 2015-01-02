require 'lib.middleclass'
require 'lib.middleclass-commons'
require "lib.lube"
join = {}

function join:init()
	if isjoining then
		protocolClient = lube.tcpClient:subclass("tcpClient")
		protocolClient._implemented = true
		-- define protocolserver
		client = protocolClient()
		client.callbacks.recv = onReceive
		success = "Establishing connection..."
		success, error = client:connect("localhost", 45558)
	end
end

function join:update(dt)
	client:update(dt)
	client:send("Hi")
end

function onReceive(data, clientid)
	success = client:receive()
end

function join:draw()
		love.graphics.setFont(sysfont)
		love.graphics.print("Connected: " .. tostring(success), 10, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end