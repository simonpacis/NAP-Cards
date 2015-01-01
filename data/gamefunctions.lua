require 'data.cardfunctions'

function tohand(hand, card)
	if tablelength(hand) < 10 then
		table.insert(hand, card)
	else
		burncard(hand, card)
	end
end

function burncard(hand, card)
	-- burn effects
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end