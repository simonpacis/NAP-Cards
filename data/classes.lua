class = require 'lib.middleclass'
require 'lib.middleclass-commons'
--============================--
-- GAME ELEMENTS								--
--============================--

--------------------------------
-- CARD
Card = class('Card')
function Card:initialize(id, place)
	self.x = width - 30 -- start at own pile
	self.y = height / 2 -- start at own pile
	self.cardtype = cards[id]['cardtype']
	self.cost = cards[id]['cost']
	self.effect = cards[id]['effect']
	self.type = cards[id]['type']
	self.z = 0
	self.upsize = false
	self.orient = math.rad(90)
	if self.cardtype == "mob" then
		self.attack = cards[id]['attack']
		self.defense = cards[id]['defense']
	end
  self.art = love.graphics.newImage("resources/images/cards/".. self.cardtype .."/".. id ..".png")
  self.place = place
  self.moved = false
  if place == "hand" then
  	self.slot = tablelength(friendlyhand) + 1
  	self.scale = 0.5
  	self.orgx = (width / 2) - 350 + ((self.art:getWidth() / 1.5 * self.scale) * (self.slot))
  	self.orgy = (height) - (self.art:getHeight() * self.scale) + 15
  	flux.to(self, 1, { x = self.orgx, y = self.orgy, orient = 0 }) -- ANIMATE IT
		self.nextx = (width / 2) - 350 + ((self.art:getWidth() / 1.5 * self.scale) * (self.slot + 1 )) 
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
    if self:grab() then end
    if self:hover() then end
    if self:click() then end
    if self:rclick() then end
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


