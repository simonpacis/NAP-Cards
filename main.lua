json = require 'lib.json'
Gamestate = require 'lib.gamestate'
Timer = require 'lib.timer'
flux = require 'lib.flux'
hash = require 'lib.hash'
require 'data.classes'
require 'data.functions'
require 'states.menu'
require 'states.host'
require "states.hosting"
require 'states.ip'
require 'states.join'
require 'states.options'
require 'states.game'
require 'states.play'

function love.load()
    usernames = { "Almarkinda", "Ilmadun", "Munotes", "Miangore", "Vayne" }
    if love.filesystem.exists("user") == false then
        ok = love.filesystem.createDirectory("user")
    end
    prepuserconf()
    
    isjoining = false
    ishosting = false
    ingrab = false
	-- set resolution
    userwidth, userheight = love.window.getDesktopDimensions(1)
    resolutions = {{1024, 576},{1280, 720},{1366, 768},{1600, 900},{1920, 1080},{2048, 1152}}
    selectedres = 1
    orgres = 1
    if userconf['resw'] == nil and userconf['resh'] == nil then -- if the user does not have a resolution in his config (new user)
    for k, v in pairs(resolutions) do -- iterate the available resolutions
        if v[1] >= userwidth then -- if userwidth is below or equal to given resolution
        	if v[2] >= userheight then -- if userheight is below or equal to given resolution
            reswidth = userwidth -- set resolution to be this
            resheight = userheight
            selectedres = selectedres + 1
            orgres = orgres + 1
          end
        end
    end
        if userconf['fullscreen'] == "true" then
          userfullscreen = true
        else
          userfullscreen = false
        end
        jsonuserconf = json.encode(userconf)
        writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
        savememoir()
    else -- if the user has a resolution in his config (returning user)
        for k, v in pairs(resolutions) do -- iterate the available resolutions
            if v[1] >= userconf['resw'] then -- if userwidth is below or equal to given resolution
                if v[2] >= userconf['resh'] then -- if userheight is below or equal to given resolution
                  selectedres = selectedres + 1
                  orgres = orgres + 1
                end
            end
        end
      reswidth = userconf['resw']
      resheight = userconf['resh']
      if userconf['fullscreen'] == "true" then
        userfullscreen = true
      else
        userfullscreen = false
      end
    end
	love.window.setMode( reswidth, resheight, {fullscreen=userfullscreen} )
	width, height, flags = love.window.getMode( )
	-- set title
	love.window.setTitle( "NAP Cards" )
    -- Load audio resources
    click = love.audio.newSource("resources/sounds/click.wav", "static")
    hover = love.audio.newSource("resources/sounds/hover.ogg", "static")
    drawcard = love.audio.newSource("resources/sounds/drawcard.wav", "static")
    menumusic = love.audio.newSource("resources/music/dragonwarrior.wav")

    -- Load the "cursor"
    cursor = love.graphics.newImage("resources/images/system/png/cursorGauntlet_grey.png")
    -- Hide the default mouse.
    love.mouse.setVisible(false)
    cards = json.decode(love.filesystem.read('resources/data/cards'), 1, err)
    longbutton = love.graphics.newImage("resources/images/system/png/buttonLong_blue.png")
    longbutton_pressed = love.graphics.newImage("resources/images/system/png/buttonLong_blue_pressed.png")
    strings, pos, err = json.decode(love.filesystem.read('strings'), 1, err)
    zombie = love.graphics.newFont( "resources/fonts/ZOMBIE.ttf", 25 )
    zombig = love.graphics.newFont( "resources/fonts/ZOMBIE.ttf", 50 )

    homestead = love.graphics.newFont( "resources/fonts/homestead.ttf", 15 )
    sysfont = love.graphics.newFont(14)
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
