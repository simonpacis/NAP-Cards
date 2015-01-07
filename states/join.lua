require "lib.lube"
require 'data.functions'

join = {}

protocolClient = lube.tcpClient:subclass("protocolClient")
protocolClient._implemented = true
-- define protocolserver
client = protocolClient()

function join:enter(previous, ip)
	if isjoining then
		client.handshake = "quartermaster"
		client.callbacks.recv = onClientReceive
		--client:setPing(true, 30, "pings")
		success, error = client:connect(ip, 45558)
		printit = "Connecting to server..."
		connected = false
    joinitem1 = Button:new(true, true, 200, 300, "Back", longbutton, longbutton_pressed, true, false, zombie)
	end
end

function join:update(dt)
	if isjoining then
		client:update(dt)
	end
	if success == true and connected == false then
		connected = true
		sendmsg('{"username":"'..username..'"}')
		Gamestate.push(game)
	end
	if success == false then
		printit = "Connection failed. Make sure that the host has port 45558 open as TCP."
	end
  if joinitem1:Click() then
  	isjoining = false
   	Gamestate.switch(ip)
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
    if success == false then
			love.graphics.setFont(zombie)
  		love.graphics.setColor(255, 255, 255, 255)
  	love.graphics.draw(joinitem1.image, joinitem1.x, joinitem1.y)
    love.graphics.setColor(230,230,230, 255)
    love.graphics.print(joinitem1.text, joinitem1.text_x, joinitem1.text_y)
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end