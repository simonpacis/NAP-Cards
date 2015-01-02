require 'data.functions'
require 'data.cardfunctions'

function tohand(hand, card)
	if tablelength(hand) < 10 then
		--_G[tostring(hand)..(tablelength(hand)+1)] = Card:new(card, 'hand')
		--table.insert(hand, Card:new(card, 'hand'))
		table.insert(hand, Card:new(card, 'hand'))
	else
		burncard(hand, card)
	end
end

function burncard(hand, card)
	-- burn effects
end