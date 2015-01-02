json = require 'lib.json'
Gamestate = require 'lib.gamestate'
require 'data.classes'
require 'data.functions'
require 'states.menu'
require 'states.host'
require "states.hosting"
require 'states.join'
require 'states.game'
require 'states.play'

function love.load()
    isjoining = false
    ishosting = false
	-- set resolution
	love.window.setMode( 1024, 576, {fullscreen=false} ) -- make this relative to the computer being played on
	width, height, flags = love.window.getMode( )
	-- set title
	love.window.setTitle( "NAP Cards" )
    -- Load the "cursor"
    cursor = love.graphics.newImage("resources/images/system/png/cursorGauntlet_grey.png")
    -- Hide the default mouse.
    love.mouse.setVisible(false)
    longbutton = love.graphics.newImage("resources/images/system/png/buttonLong_blue.png")
    longbutton_pressed = love.graphics.newImage("resources/images/system/png/buttonLong_blue_pressed.png")
    strings, pos, err = json.decode(love.filesystem.read('strings'), 1, err)
    zombie = love.graphics.newFont( "resources/fonts/ZOMBIE.ttf", 25 )
    sysfont = love.graphics.newFont(14)
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
