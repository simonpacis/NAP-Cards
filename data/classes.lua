class = require 'lib.middleclass'
require 'lib.middleclass-commons'
--============================--
-- GAME ELEMENTS								--
--============================--

--------------------------------
-- CARD
Card = class('Card')
function Card:initialize(id, place)
	self.cardtype = cards[id]['cardtype']
	self.cost = cards[id]['cost']
	self.effect = cards[id]['effect']
	self.type = cards[id]['type']
	if self.cardtype == "mob" then
		self.attack = cards[id]['attack']
		self.defense = cards[id]['attack']
	end
  self.art = love.graphics.newImage("resources/images/cards/".. self.cardtype .."/".. id ..".png")
  self.place = place
  if place == "hand" then
  	self.slot = tablelength(friendlyhand) + 1
  	self.x = (width / 2) - 300 + (self.art:getWidth() * 0.7 * (self.slot - 1) / 2)
  	self.y = (height) - (self.art:getHeight() * 0.7) + 15
  	self.orient = math.rad(0)
  	tohand(friendlyhand, id)
  end
end

function Card:hover()
	if self.place == "hand" then
		if (love.mouse.getX() >= self.x
			and love.mouse.getX() < (self.x + self.art:getWidth()) --something wrong here
			and love.mouse.getY() >= self.y and love.mouse.getY() < (self.y + self.art:getHeight())) then
			if stop == false then
				self.y = self.y - 50
				hovered = true
			end
		else
			self.y = (height) - (self.art:getHeight() * 0.7) + 15
			stop = false
		end
		if hovered == true then
			stop = true
			hovered = false
		end
	end
end
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


