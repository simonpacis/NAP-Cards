--[[
    This file is a part of the J2H client
    J2H is a free MMO-game (not yet released)
    ----

    Copyright (C) 2008-2011  TsT <tst@worldmaster.fr>

    This program is free software: you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation, either version 3 of
    the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
]]--

--[[
  Hello,
  If you found a bug or have a question, don't hesitate to contact me
  by email at <tst@worldmaster.fr> (in french or english please)
  Thanks,
  Have fun!
]]--

--[[ VERSION=0.1.0 20110425 ]]--

assert(love, "love required")
assert(love.graphics, "the love.graphics module was required")

if love and not love.screen then love.screen = {} end

-- function to copy some love.graphics.* functions
local import = function()
	local m = {}

	-- list of the love.graphics functions to copy
	local tocopy = {"getCaption", "setCaption", "checkMode", "getModes", "setMode", "toggleFullscreen", "getHeight", "getWidth"}

	for i,f in ipairs(tocopy) do
		if love.graphics and love.graphics[f] then
			m[f] = love.graphics[f]
		end
	end

	return m
end

local internal = {}
internal.lovegraphics = import()
internal.screens = {} -- empty screen list
internal.defaultscreen = "main"
internal.defaultvsync = false
internal.defaultfsaa = 0
internal.defaultfullscreen = false

------------------------------------------------
-- define the Screen object and his functions --
------------------------------------------------

local Screen = {}
Screen.__index = Screen
Screen.screens = {}

local function newScreen(name)
	local self = {}
	setmetatable(self, Screen)

	self.name = name

	self.type = "screen"
	self.title = ""
	self.height = 0
	self.width = 0
	self.vsync = false
	self.fsaa = 0

	table.insert(internal.screens, self) -- register the new screen into the screen list

	return self
end

function Screen:getCaption()
	return self.title
end

function Screen:setCaption(title)
	if self.isMain then
		internal.lovegraphics.setCaption(title)
	end
	self.title = title
end

function Screen:checkMode(width, height, fullscreen)
	if self.isMain then
        	return internal.lovegraphics.checkMode(width, height, fullscreen)
	end
	return true
end

function Screen:getModes()
	if self.isMain then
		return internal.lovegraphics.getModes()
	end
	return nil
end

function Screen:setMode(width, height, fullscreen, vsync, fsaa)
	width      = width      ~= nil and width      or self.width
	height     = height     ~= nil and height     or self.height
	fullscreen = fullscreen ~= nil and fullscreen or self.fullscreen
	vsync      = vsync      ~= nil and vsync      or self.vsync
	fsaa       = fsaa       ~= nil and fsaa       or self.fsaa

	local ok = true
	if self.isMain then
		ok = internal.lovegraphics.setMode(width, height, fullscreen, vsync, fsaa)
	end
	if ok then
		self.width = width
		self.height = height
		self.fullscreen = fullscreen
		self.vsync = vsync
		self.fsaa = fsaa
	end
	return ok
end

function Screen:toggleFullscreen()
	local ok = true
	if self.isMain then
		ok = internal.lovegraphics.toggleFullscreen()
	end
	if ok then
		self.fullscreen = not fullscreen
	end
	return ok
end

function Screen:getHeight()
	return self.height
end

function Screen:getWidth()
	return self.width
end

function Screen:getFullscreen()
	return self.fullscreen
end

function Screen:getVsync()
	return self.vsync
end

function Screen:getFsaa()
	return self.fsaa
end

function Screen:getMode(width, height, fullscreen, vsync, fsaa)
	width      = width      ~= nil and width      or self.width
	height     = height     ~= nil and height     or self.height
	fullscreen = fullscreen ~= nil and fullscreen or self.fullscreen
	vsync      = vsync      ~= nil and vsync      or self.vsync
	fsaa       = fsaa       ~= nil and fsaa       or self.fsaa
	return width, height, fullscreen, vsync, fsaa
end

---------------------------------
-- the love.screen.* functions --
---------------------------------

local function initCheck()
	if #internal.screens == 0 then
		error("ERROR: the screen list is empty. Remember to run the love.screen.init() before")
	end
end

local function getScreen(name)
	initCheck()
	name = name or internal.defaultscreen
	for i,v in ipairs(internal.screens) do
		if v.name == name then
			return v
		end
	end
	error("Unknown screen name")
end

local function getNumScreens()
	return #internal.screens
end

local function getScreens()
	initCheck()
        return internal.screens
end

local function init()
	local screen = newScreen(internal.defaultscreen)
	screen.isMain = true

	-- get the default settings from love.conf (usually defined in conf.lua)
	local t = {}
	if love and love.conf then
		t.screen = {}
		t.modules = {}
		-- load default settings
		love.conf(t)
	end

	-- apply default settings if not already set (for fullscreen, vsync and fsaa)
	if not t.screen then t.screen = {} end
	if not t.screen.fullscreen then t.screen.fullscreen = internal.defaultfullscreen end
	if not t.screen.vsync then t.screen.vsync = internal.defaultvsync end
	if not t.screen.fsaa then t.screen.fsaa = internal.defaultfsaa end

	-- title, width and height can be get drectly with love functions
	screen.title = internal.lovegraphics.getCaption()
	screen.width = internal.lovegraphics.getWidth()
	screen.height = internal.lovegraphics.getHeight()
	screen.fullscreen = t.screen.fullscreen
	screen.vsync = t.screen.vsync
	screen.fsaa = t.screen.fsaa
end


-- public functions

love.screen.newScreen = newScreen
love.screen.getScreen = getScreen
love.screen.getNumScreens = getNumScreens
love.screen.getScreens = getScreens
love.screen.init = init
