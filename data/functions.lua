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