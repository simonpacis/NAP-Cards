require 'data.functions'
require 'data.cardfunctions'

function tohand(deck)
	if tablelength(friendlyhand) < 10 then
		table.insert(friendlyhand, Card:new(deck[1], 'hand'))
		table.remove(friendlydeck, 1)
	else
		burncard(friendlyhand, deck[1])
	end
end

function burncard(hand, card)
	-- burn effects
end