require "lib.lube"
require 'data.functions'

join = {}

protocolClient = lube.tcpClient:subclass("protocolClient")
protocolClient._implemented = true
-- define protocolserver
client = protocolClient()

function join:init()
	if isjoining then
		client.handshake = "quartermaster"
		client.callbacks.recv = onClientReceive
		--client:setPing(true, 30, "pings")
		success, error = client:connect("2.109.204.105", 45558)
		printit = "Connecting to server..."
		connected = false
	end
end

function join:update(dt)
	if isjoining then
	client:update(dt)
	if success == true and connected == false then
		connected = true
		sendmsg('{"username":"'..username..'"}')
		Gamestate.push(game)
	end
	end
end

function onClientReceive(data, id)
	if isjoining then
  if client.connected == true then
    Gamestate.push(game, client)
  end
  parse(data, "client")
 end
end

function join:draw()
    love.graphics.setColor(40, 40, 40, 255)
		love.graphics.setFont(sysfont)
		love.graphics.print(printit, 10, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end