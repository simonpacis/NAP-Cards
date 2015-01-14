require 'data.functions'
require 'data.cardfunctions'

function tohand(deck, id)
	if tablelength(friendlyhand) < 10 then
		if id ~= nil then
			table.insert(friendlyhand, Card:new(id, 'hand'))
		else
			table.insert(friendlyhand, Card:new(deck[1], 'hand'))
			table.remove(friendlydeck, 1)
		end
	else
		burncard(friendlyhand, deck[1])
	end
end

function burncard(hand, card)
	-- burn effects
end

function enemydraw()
	table.insert(enemyhand, Card:new('blank', 'enemyhand'))
end