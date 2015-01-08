function sendmsg(data)
  if isjoining then 
    client:send(data)
  elseif ishosting then
    server:send(data)
  end
end

function parse(data, role)
  data = json.decode(data, 1, err)
  if Gamestate.current() == game then
    if data.cmd == "chosen" then
      enemychosen = true
    end
    if data.username ~= nil then
      enemyusername = data.username
    end
  end
  if Gamestate.current() == play then

  end
  if data ~= nil then
    message = data
  end
end

function parseeffect(effect)
  effects = json.decode(love.filesystem.read('resources/data/effects'), 1, err)
  if effect ~= nil then -- if there even is an effect
    if string.find(effect, "|", 1, true) then -- if the string contains an effect seperator
      effect = split(effect, "|") -- split it by seperator
      parsedeffect = nil -- set the returning string to nil
      for k, v in ipairs(effect) do -- iterate over all the different effects (from split function)
        if parsedeffect == nil then -- if it is first time we run this loop
          if string.find(v, "(", 1, true) then -- if effect contains arguments
            parsedeffect = singleeffectparse(v) -- send it to singleeffectparse
          else -- if effect does not contain arguments
            parsedeffect = effects[v] -- find the corresponding flavor text in the effects table
          end
        else -- if it is not first time that the loop runs
          if string.find(v, "(", 1, true) then -- same as earlier and self-explanatory
            parsedeffect = parsedeffect .. "\n" .. singleeffectparse(v)
          else
            parsedeffect = parsedeffect .. "\n" .. effects[v]
          end
        end
      end -- end loop
      return parsedeffect -- return the string of effects
    else -- if there is only one effect
      if string.find(effect, "(", 1, true) then -- if effect contains arguments
        parsedeffect = singleeffectparse(effect) -- send it to singleeffectparse
      else -- if effect does not contain arguments
        parsedeffect = effects[effect] -- find the corresponding flavor text in the effects table
      end
    end
  else -- if there is no effect
    return nil
  end
end

function singleeffectparse(effect)
    base = split(effect, "(") -- split the core effect and the arguments
    core = base[1] -- define the core
    args = base[2] -- define the arguments
    args = stripchars(args, "()") -- remove parenthesis
    return string.format(effects[core], args) -- replace the %s's with the arguments and return
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end


math.randomseed( os.time() )
function shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

function stripchars(str, chrs)
  local s = str:gsub("["..chrs.."]", '')
  return s
end
 

function prepuserconf()
      if love.filesystem.exists("system") == false then
        love.filesystem.createDirectory("system")
      end
        if love.filesystem.exists("user/userconf.nap") and love.filesystem.exists("system/memoir") then
            usersha256 = hash.sha256()
            usersha256:process(love.filesystem.read('user/userconf.nap'))
            shafinal = usersha256:finish()
              memoir = love.filesystem.read('system/memoir')
              if memoir == shafinal then
                  userconf = json.decode(love.filesystem.read('user/userconf.nap'), 1, err)
              else
                newuserconf()
              end
          if love.filesystem.exists("user/userstats.nap") and love.filesystem.exists("system/memoire") then
            usersha256 = hash.sha256()
            usersha256:process(love.filesystem.read('user/userstats.nap'))
            sha2final = usersha256:finish()
            memoire = love.filesystem.read('system/memoire')
            if memoire == shafinal then
                 userstats = json.decode(love.filesystem.read('user/userstats.nap'), 1, err)
            else
              newuserstats()
            end
          end
        else
          newuserconf()
        end
end

function newuserconf()
            usernames = { "Almarkinda", "Ilmadun", "Munotes", "Miangore", "Vayne" }
            userconf = {}
            userconf['username'] = usernames[math.random(tablelength(usernames))]
            userconf['fullscreen'] = "true"
            userconf['resw'] = nil
            userconf['resh'] = nil
            jsonuserconf = json.encode(userconf)
            writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
            usersha256 = hash.sha256()
            usersha256:process(love.filesystem.read('user/userconf.nap'))
            shafinal = usersha256:finish()
            memoirwrite = love.filesystem.write("system/memoir", shafinal)
            newuserstats()
end

function savememoir()
if love.filesystem.exists("system/memoir") then
  usersha256 = hash.sha256()
  usersha256:process(love.filesystem.read('user/userconf.nap'))
  shafinal = usersha256:finish()
  memoirwrite = love.filesystem.write("system/memoir", shafinal)
end
end

function savememoire()
if love.filesystem.exists("system/memoire") then
  usersha256 = hash.sha256()
  usersha256:process(love.filesystem.read('user/userstats.nap'))
  shafinal = usersha256:finish()
  memoirwrite = love.filesystem.write("system/memoire", shafinal)
end
end

function newuserstats()
  userstats = {}
  userstats['losses'] = "0"
  userstats['wins'] = "0"
  userstats['myths'] = {}
  userstats['leggies'] = {}
  jsonuserstats = json.encode(userstats)
  write2success = love.filesystem.write('user/userstats.nap', jsonuserstats)
  usersha256 = hash.sha256()
  usersha256:process(love.filesystem.read('user/userstats.nap'))
  sha2final = usersha256:finish()
  memoirewrite = love.filesystem.write("system/memoire", shafinal)
end