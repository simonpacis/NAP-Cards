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
        else
          newuserconf()
        end
end

function newuserconf()
            userconf = {}
            userconf['username'] = usernames[math.random(tablelength(usernames))]
            userconf['wins'] = "0"
            userconf['losses'] = "0"
            userconf['myths'] = {}
            userconf['leggies'] = {}
            userconf['fullscreen'] = "true"
            userconf['resw'] = nil
            userconf['resh'] = nil
            jsonuserconf = json.encode(userconf)
            writesuccess = love.filesystem.write('user/userconf.nap', jsonuserconf)
            usersha256 = hash.sha256()
            usersha256:process(love.filesystem.read('user/userconf.nap'))
            shafinal = usersha256:finish()
            memoirwrite = love.filesystem.write("system/memoir", shafinal)
end

function savememoir()
if love.filesystem.exists("system/memoir") then
  usersha256 = hash.sha256()
  usersha256:process(love.filesystem.read('user/userconf.nap'))
  shafinal = usersha256:finish()
  memoirwrite = love.filesystem.write("system/memoir", shafinal)
end
end