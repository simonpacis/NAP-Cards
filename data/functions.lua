function sendmsg(data)
  if ishosting then 
    server:send(data .. "<eom>")
  else
    client:send(data .. "<eom>")
  end
end

function sendcmd(cmd)
  sendmsg('{"cmd":"' .. cmd .. '"}')
end

function parse(data, role)
  if string.find(data, "<eom>", 1, true) then -- received full message
    if count_substring(data, "<eom>") > 1 then -- more than one message
      splitdata = data:split("<eom>") -- split by messages
      for k,v in ipairs(splitdata) do -- perform all received messages
        _G['message'] = _G['message'] .. "!" .. v .. "!"
        if string.find(v, "{") then
          parsesinglemessage(v, role)
        end
      end
    else
      pos = string.find(data, "<eom>", 1, true)
      remdata = string.sub(data, 1, pos - 1) -- remove eom
      parsesinglemessage(remdata, role)
    end
  else
      _G['message'] = "uncomplete message"
  end
  data = nil
end

function parsesinglemessage(data, role)
    if data ~= nil then
    datajson, dpos, derror = json.decode(data, 1, err)
    if derror ~= nil then
      _G['message'] = derror
      return
    end
    if datajson ~= nil then
      _G['message'] = data
    end

    if Gamestate.current() == game then
      if datajson.cmd == "chosen" then
        enemychosen = true
      end
      if datajson.username ~= nil then
        enemyusername = datajson.username
      end
    end

    if Gamestate.current() == play then
      if string.find(datajson.cmd, "|", 1, true) then -- if the string contains a function seperator (multiple functions)
        datajson.cmd = split(datajson.cmd, "|") -- seperate by seperator
        for k,v in ipairs(datajson.cmd) do
          local base = split(v, "(") -- split the core effect and the arguments
          local core = base[1] -- define the core
          local args = base[2] -- define the arguments
          local found = false
          args = stripchars(args, "()") -- remove parenthesis
          if string.find(args, ", ", 1, true) then -- if multiple arguments found with comma and space
            splitargs = args:split(", ") -- split by comma and space
            found = true
          elseif string.find(args, ",", 1, true) then-- if multiple arguments found with comma and no space
            splitargs = args:split(",") -- split by comma
            found = true
          end
          newargs = {} -- newargs is the manipulated arguments
          if found then -- if multiple arguments are found
            argiter = 1 -- set iteration variable to 1
            for k, v in ipairs(splitargs) do -- iterate over all the split-up arguments
              newv = tonumber(v) -- try to convert argument to number
              if newv == nil then -- if it is not convertible to number
                newv = string.gsub(v, "'", '') -- remove eventual quotation marks and set as string
              end
              newargs[argiter] = newv -- add argument to newargs table
              argiter = argiter + 1 -- increase arg iteration varible
            end
          else -- if only one argument is found
            newargs[1] = tonumber(args) -- convert argument to number
            if newargs[1] == nil then -- if argument is not convertible to number
              newargs[1] = string.gsub(args, "'", '') -- use original arguments (remove the quotationmarks)
            end
          end
          _G['message'] = data
          _G[core](unpack(newargs)) -- execute command (unpack for eventual multiple arguments)
        end
      else -- if only one command is found in message
        if string.find(datajson.cmd, "(", 1, true) then -- if command has parenthesis (to be sure)
          local base = split(datajson.cmd, "(") -- split the core function and the arguments
          local core = base[1] -- define the core
          local args = base[2] -- define the arguments
          local found = false
          args = stripchars(args, "()") -- remove parenthesis
          if string.find(args, ", ", 1, true) then -- if multiple arguments found with comma and space
            splitargs = args:split(", ") -- split by comma and space
            found = true
          elseif string.find(args, ",", 1, true) then-- if multiple arguments found with comma and no space
            splitargs = args:split(",") -- split by comma
            found = true
          end
          newargs = {} -- newargs is the manipulated arguments
          if found then -- if multiple arguments are found
            argiter = 1 -- set iteration variable to 1
            for k, v in ipairs(splitargs) do -- iterate over all the split-up arguments
              newv = tonumber(v) -- try to convert argument to number
              if newv == nil then -- if it is not convertible to number
                newv = string.gsub(v, "'", '') -- remove eventual quotation marks and set as string
              end
              newargs[argiter] = newv -- add argument to newargs table
              argiter = argiter + 1 -- increase arg iteration varible
            end
          else -- if only one argument is found
            newargs[1] = tonumber(args) -- convert argument to number
            if newargs[1] == nil then -- if argument is not convertible to number
              newargs[1] = string.gsub(args, "'", '') -- use original arguments (remove the quotationmarks)
            end
          end
          _G['message'] = data
          _G[core](unpack(newargs)) -- execute command (unpack for eventual multiple arguments)
        end
      end
    end
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

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

function playsound(sound)
  _G[sound]:play()
end

function setvar(variable, value)
  _G[variable] = value
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

function count_substring( s1, s2 )
 local magic =  "[%^%$%(%)%%%.%[%]%*%+%-%?]"
 local percent = function(s)return "%"..s end
    return select( 2, s1:gsub( s2:gsub(magic,percent), "" ) )
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