class = require 'lib.middleclass'
require 'lib.middleclass-commons'
--============================--
-- GAME ELEMENTS								--
--============================--

--------------------------------
-- CARD
Card = class('Card')
function Card:initialize(id, place)
	self.id = id
	self.x = width - 30 -- start at own pile
	self.y = height / 2 -- start at own pile
	self.cardtype = cards[id]['cardtype']
	if self.cardtype == "blank" then
		self.z = 0
		self.upsize = false
		self.y = height / 4
		self.art = special -- change to blank artwork when created
		self.place = place
		if self.place == "enemyhand" then
			self.slot = 10 - tablelength(enemyhand) + 1
	  	self.scale = 0.5
	  	self.orient = 0
	  	self.orgx = (200) + ((self.art:getWidth() / 1.5 * self.scale) * self.slot) --- ((self.art:getWidth() / 1.5 * self.scale) * (self.slot))
	  	self.orgy = self.art:getHeight() / 2 * self.scale
	  	flux.to(self, 0.5, { x = self.orgx, y = self.orgy, orient = math.rad(180), scale = 0.5 })
		end
	else
		self.cost = cards[id]['cost']
		if cards[id]['effect'] ~= ""  or cards[id]['effect'] ~= nil then
			self.effect = cards[id]['effect']
			self.flavoreffect = parseeffect(self.effect)
		end
		self.type = cards[id]['type']
		self.amount = cards[id]['amount']
		self.name = cards[id]['name']
		self.z = 0
		self.upsize = false
		self.orient = 0
		if self.cardtype == "mob" then
			self.attack = cards[id]['attack']
			self.defense = cards[id]['defense']
		end
		if cards[id]['rarity'] == nil then
			self.art = spell
		else
			if cards[id]['rarity'] == "common" then
				self.art = common
			elseif cards[id]['rarity'] == "uncommon" then
				self.art = uncommon
			elseif cards[id]['rarity'] == "special" then
				self.art = special
			elseif cards[id]['rarity'] == "legendary" then
				self.art = legendary
			elseif cards[id]['rarity'] == "mythical" then
				self.art = mythical
			end
	  end
	  self.place = place
	  self.moved = false
	  if place == "hand" then
	  	self.slot = tablelength(friendlyhand) + 1
	  	self.scale = 0.5
	  	self.orgx = (width / 2) - 350 + ((self.art:getWidth() / 1.5 * self.scale) * (self.slot))
	  	self.orgy = (height) - (self.art:getHeight() * self.scale) + 15
	  	flux.to(self, 0.5, { x = (width - 200), y = (height / 2), orient = 0, scale = 1 })
	  	Timer.add(1.25, function(func) flux.to(self, 0.5, { x = self.orgx, y = self.orgy, orient = 0, scale = 0.5 }) end)
			self.nextx = (width / 2) - 350 + ((self.art:getWidth() / 1.5 * self.scale) * (self.slot + 1 )) 
	  end
	 end
end

function Card:hover()
	if ingrab ~= true then
		if self.place == "hand" then
			if (love.mouse.getX()) >= self.x
					and love.mouse.getX() < self.nextx
					and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + (self.art:getHeight() * self.scale)) then
					self:mouseenter()
			else
					self:mouseexit()
			end
		end
	end
end

function Card:mouseenter()
	if self.place == "hand" then
		if self.moved == false then
			self.upsize = true
			self.z = 1
			self.scale = 1
			self.moved = true
		end
	end
end

function Card:mouseexit()
	if self.place == "hand" then
		if self.moved == true then
			self.scale = 0.5
			self.z = 0
			self.moved = false
		end
	end
end

function Card:click()
	if love.mouse.isDown("l") then
		if stop == false then
			if (love.mouse.getX()) >= self.x
					and love.mouse.getX() < self.nextx
					and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + (self.art:getHeight() * self.scale)) then
				if self.pressed ~= true then
					self.grabbed = true
					ingrab = true
					self.scale = 0.5
					self.z = 0
					self.upsize = false
					self.moved = false
				else
					self.grabbed = false
				end
			end
		end
	else
		stop = false
	end
	if self.pressed == true then
		self.pressed = false
		stop = true
		return true
	end
end

function Card:rclick()
	if love.mouse.isDown("r") then
		if stop == false then
			if self.grabbed == true then
					self.grabbed = false
					ingrab = false
					self.z = 0
					flux.to(self, 0.5, { x = self.orgx, y = self.orgy })
				end
			end
	else
		stop = false
	end
	if self.pressed == true then
		self.pressed = false
		stop = true
		return true
	end
end

function Card:grab()
	if self.grabbed == true then
		self.z = 1
		self.x = love.mouse.getX() - (self.art:getWidth() / 2 * self.scale)
		self.y = love.mouse.getY() - (self.art:getHeight() / 2 * self.scale)
	end
end

function Card:move(newx, newy, time, format)
	flux.to(self, time, { x = self.newx, y = self.newy })
end

function Card:check()
    self:grab()
    self:hover()
    self:click()
    self:rclick()
end

function Card:draw(upsize)
	love.graphics.setColor(255, 255, 255, 255)
	if upsize == true then
		love.graphics.draw( self.art, self.x, self.y, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
	else
		love.graphics.draw( self.art, self.x, self.y, self.orient, self.scale, self.scale )
	end
	love.graphics.setColor(40, 40, 40, 255)
	love.graphics.setFont(homestead)

	if self.cardtype ~= "blank" then
	if playfair:getWidth(self.name) > self.art:getWidth() then
		namefont = playfair_medium
		namex = self.x + (self.art:getWidth() * self.scale / 2) - (playfair_medium:getWidth(self.name) * self.scale / 2)
	else
		namefont = playfair
		namex = self.x + (self.art:getWidth() * self.scale / 2) - (playfair:getWidth(self.name) * self.scale / 2)
	end
	namey = self.y + ((self.art:getHeight() / 2) * self.scale)

	amountx = (self.x + (self.art:getWidth() * self.scale)) - (20 * self.scale)
	amounty = (self.y + (self.art:getHeight() * self.scale)) - (28 * self.scale)
	typex = self.x + (self.art:getWidth() * self.scale / 2) - ((playfair_small:getWidth(self.type) * self.scale) / 2)
	typey = self.y + ((self.art:getHeight() / 2) * self.scale) - (13 * self.scale)
	costx = self.x + (13 * self.scale)
	costy = (self.y + (self.art:getHeight() * self.scale)) - (30 * self.scale)
	if self.flavoreffect ~= nil then
		effectx = self.x + (self.art:getWidth()/2 * self.scale) - (playfair_small:getWidth(self.flavoreffect) * self.scale / 2)
		effecty = self.y + ((self.art:getHeight() * self.scale / 2)) + (30 * self.scale)
	end
	if upsize == true then
		love.graphics.setColor(219,159,45, 255)
		love.graphics.print(self.cost, costx, costy, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
		circlex = costx + 17
		circley = costy + (self.scale * 5)
		love.graphics.setColor(255,255,255, 255)
		if tonumber(self.cost) > 0 then
			for circleamount = 1, tonumber(self.cost) do
				love.graphics.draw( wealth, circlex, circley, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
				circlex = circlex + (12 * self.scale)
			end
		end
		love.graphics.setColor(96, 95, 93, 255)
		love.graphics.print(tostring(self.amount), amountx, amounty, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
		love.graphics.setFont(namefont)
		love.graphics.setColor(0,0,0,255)
		love.graphics.print(self.name, namex, namey, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
		love.graphics.setFont(playfair_small)
		love.graphics.print(self.type, typex, typey, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
		love.graphics.print(self.type, typex, typey, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
		if self.flavoreffect ~= nil then
			love.graphics.printf(self.flavoreffect, effectx, effecty, self.art:getWidth() / 2, "center", self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
		end
	else
		love.graphics.setColor(219,159,45, 255)
		love.graphics.print(self.cost, costx, costy, self.orient, self.scale, self.scale)
		circlex = costx + 17
		circley = costy + (self.scale * 5)
		love.graphics.setColor(255,255,255, 255)
		if tonumber(self.cost) > 0 then
			for circleamount = 1, tonumber(self.cost) do
				love.graphics.draw( wealth, circlex, circley, self.orient, self.scale, self.scale)
				circlex = circlex + (12 * self.scale)
			end
		end
		love.graphics.setColor(96, 95, 93, 255)
		love.graphics.print(tostring(self.amount), amountx, amounty, self.orient, self.scale, self.scale)
		love.graphics.setFont(namefont)
		love.graphics.setColor(0,0,0,255)
		love.graphics.print(self.name, namex, namey, self.orient, self.scale, self.scale)
		love.graphics.setFont(playfair_small)
		love.graphics.setColor(0,0,0,255)
		love.graphics.print(self.type, typex, typey, self.orient, self.scale, self.scale)
		if self.flavoreffect ~= nil then
			love.graphics.printf(self.flavoreffect, effectx, effecty, self.art:getWidth() / 2, "center", self.orient, self.scale, self.scale)	
		end
	end

	if self.cardtype == "mob" then
		attackx = self.x + (17 * self.scale)
		attacky = self.y + (13 * self.scale)
		defensex = (self.x + (self.art:getWidth() * self.scale)) - (27 * self.scale)
		defensey = self.y + (13 * self.scale)

		love.graphics.setFont(homestead)
		if upsize == true then
			love.graphics.setColor(131, 27, 2, 255)
			love.graphics.print(tostring(self.attack), attackx, attacky, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)
			love.graphics.setColor(235, 213, 93, 255)
			love.graphics.print(tostring(self.defense), defensex, defensey, self.orient, self.scale, self.scale, self.art:getWidth()/4, self.art:getHeight()/1.3)

		else
			love.graphics.setColor(131, 27, 2, 255)
			love.graphics.print(tostring(self.attack), attackx, attacky, self.orient, self.scale, self.scale)
			love.graphics.setColor(235, 213, 93, 255)
			love.graphics.print(tostring(self.defense), defensex, defensey, self.orient, self.scale, self.scale)
		end
		love.graphics.setColor(40, 40, 40, 255)
	end
end	
end

-- assert(loadstring(s))() -- load from string and execute
--============================--
-- GUI ELEMENTS								--
--============================--

--------------------------------
-- BUTTON
-- Initialization arguments:
-- x = window width divided by x / 100 (relative to resolution)
-- y = window height divided by y / 100 (relative to resolution)
-- text = Text to be displayed on button - if you do not want text, don't draw it in love_draw
-- image = image element for standard button display.
-- image_pressed = image element for when clicked.
-- hcenter = if the anchor should be centered horizontally (true/false) - optional, default false
-- vcenter = if the anchor should be centered vertically (true/false) - optional, default false
-- font = font to calculate text coordinates based on - optional
--
-- Variables:
-- x = the x coordinate of the button
-- y = the y coordinate of the button
-- image = the image of the button (draw this)
-- image_pressed = the pressed image of the button
-- image_passive = the passive image of the button
-- text = the text on the button
-- text_x = the x coordinates of the button - requires font argument to be defined
-- text_y = the y coordinates of the button - requires font argument to be defined
--
-- Functions:
--
-- Click(): Checks whether the button is clicked on with the left mouse button.
-- returns: true if clicked
-- Arguments:
-- pressedimage = if the button image should change to pressed on click (true/false) - optional, default true
--
-- Hover(): Checks whether the button is hovered over.
-- returns: true on hover
--
-- RClick(): Checks whether the button is clicked on with the right mouse button.
-- returns: true if right clicked
--------------------------------
Button = class('Button')
function Button:initialize(relativex, relativey, x, y, text, image, image_pressed, hcenter, vcenter, font)
	self.image = image
	self.image_pressed = image_pressed
	self.image_passive = image

	if relativex == false then
		self.x = x
	else
	if hcenter ~= true then
		self.x = (width / (x / 100))
	else
		self.x = (width / (x / 100)) - (self.image:getWidth() / 2)
	end
	end

	if relativey == false then
		self.y = y
	else
	if vcenter ~= true then
		self.y = (height / (y / 100))
	else
		self.y = (height / (y / 100)) - (self.image:getHeight() / 2)
	end
	end

	self.text = text
	if font ~= nil then
		self.text_x = self.x + (self.image:getWidth() / 2) - (font:getWidth( text ) / 2)
		self.text_y = self.y + (self.image:getHeight() / 2) - (font:getHeight( text ) / 2)
	end

end

function Button:Hover()
		if (love.mouse.getX() >= self.x and love.mouse.getX() < (self.x + self.image_passive:getWidth()) and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + self.image_passive:getHeight())) then
			--hover:play()
			return true
		end
end

function Button:Click(pressedimage, audioplay)
	if love.mouse.isDown("l") then
		if stop == false then
		if (love.mouse.getX() >= self.x and love.mouse.getX() < (self.x + self.image_passive:getWidth()) and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + self.image_passive:getHeight())) then
			if audioplay ~= false then
				click:play()
			end
			if pressedimage ~= false then
				self.image = self.image_pressed
			end
			pressed = true
		end
		end
	else
		self.image = self.image_passive
		stop = false
	end
	if pressed == true then
		pressed = false
		stop = true
		return true
	end
end

function Button:RClick()
	if love.mouse.isDown("r") then
		if stop == false then
		if (love.mouse.getX() >= self.x and love.mouse.getX() < (self.x + self.image_passive:getWidth()) and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + self.image_passive:getHeight())) then
			return true
		end
		end
	else
		stop = false
	end
	if pressed == true then
		pressed = false
		stop = true
		return true
	end
end

function Button:Hold(pressedimage)
	if love.mouse.isDown("l") then
		if (love.mouse.getX() >= self.x and love.mouse.getX() < (self.x + self.image_passive:getWidth()) and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + self.image_passive:getHeight())) then
			if pressedimage ~= false then
				self.image = self.image_pressed
			end
			return true
		end
	else
		self.image = self.image_passive
	end
end

function Button:RHold()
	if love.mouse.isDown("r") then
		if (love.mouse.getX() >= self.x and love.mouse.getX() < (self.x + self.image_passive:getWidth()) and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + self.image_passive:getHeight())) then
			return true
		end
	end
end


